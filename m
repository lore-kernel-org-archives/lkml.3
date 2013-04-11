Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3DKURD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:17:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38838 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3DKURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:17:00 -0400
Date: Thu, 11 Apr 2013 16:16:57 -0400 (EDT)
Message-Id: <20130411.161657.2074095162745735091.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost_net: remove tx polling state
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130411072430.GC17063@redhat.com>
References: <1365663048-38332-1-git-send-email-jasowang@redhat.com>
	<20130411072430.GC17063@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 13:17:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 11 Apr 2013 10:24:30 +0300

> On Thu, Apr 11, 2013 at 02:50:48PM +0800, Jason Wang wrote:
>> After commit 2b8b328b61c799957a456a5a8dab8cc7dea68575 (vhost_net: handle polling
>> errors when setting backend), we in fact track the polling state through
>> poll->wqh, so there's no need to duplicate the work with an extra
>> vhost_net_polling_state. So this patch removes this and make the code simpler.
>> 
>> This patch also removes the all tx starting/stopping code in tx path according
>> to Michael's suggestion.
>> 
>> Netperf test shows almost the same result in stream test, but gets improvements
>> on TCP_RR tests (both zerocopy or copy) especially on low load cases.
>> 
>> Tested between multiqueue kvm guest and external host with two direct
>> connected 82599s.
 ...
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Less code and better speed, what's not to like.
> Davem, could you pick this up for 3.10 please?
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied to net-next, thanks everyone.
