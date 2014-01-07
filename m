Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaAGF5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:57:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37655 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaAGF5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:57:49 -0500
Date: Tue, 07 Jan 2014 00:57:47 -0500 (EST)
Message-Id: <20140107.005747.2228695405723185015.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net 1/2] macvlan: forbid L2 fowarding offload for
 macvtap
From: David Miller <davem@davemloft.net>
In-Reply-To: <52CB71B2.4070005@redhat.com>
References: <1388978467-2075-1-git-send-email-jasowang@redhat.com>
	<20140106.154740.590358835696689785.davem@davemloft.net>
	<52CB71B2.4070005@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 21:57:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 07 Jan 2014 11:17:06 +0800

> On 01/07/2014 04:47 AM, David Miller wrote:
>> From: Jason Wang <jasowang@redhat.com>
>> Date: Mon,  6 Jan 2014 11:21:06 +0800
>>
>>> L2 fowarding offload will bypass the rx handler of real device. This will make
>>> the packet could not be forwarded to macvtap device. Another problem is the
>>> dev_hard_start_xmit() called for macvtap does not have any synchronization.
>>>
>>> Fix this by forbidding L2 forwarding for macvtap.
>>>
>>> Cc: John Fastabend <john.r.fastabend@intel.com>
>>> Cc: Neil Horman <nhorman@tuxdriver.com>
>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> I think I agree with Neil that the rx_handler change might be the best
>> way to fix this.  That change seems to have a lot of nice unintended
>> side effects, no?
> 
> Not all sides effects are nice.
> 
> One obvious issue is it disables the multiqueue macvtap transmission,
> since all queues will contend on a single qdisc lock of macvlan. And
> even more, multiqueue macvtap support creating and destroying a queue on
> demand which is not supported by L2 forwarding offload.
> 
> So L2 forwarding offload needs more fixes to let the multiqueue macvtap
> works. Currently, we really need this patch to make sure macvtap works
> as expected.

Ok I moved these two patches back to "Under Review".

These are pretty last minute and we'll need to make a decision on
what to do before Friday if you want these changes to really make
it into 3.13
