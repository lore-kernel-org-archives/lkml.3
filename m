Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaBMAGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:06:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34228 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBMAGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:06:39 -0500
Date: Wed, 12 Feb 2014 19:06:37 -0500 (EST)
Message-Id: <20140212.190637.328045386111912135.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qinchuanyu@huawei.com, joern@logfs.org, anatol.pomozov@gmail.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140212165630.GA22991@kroah.com>
References: <1392222846-26699-1-git-send-email-mst@redhat.com>
	<1392222846-26699-2-git-send-email-mst@redhat.com>
	<20140212165630.GA22991@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2014 16:06:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 12 Feb 2014 08:56:30 -0800

> On Wed, Feb 12, 2014 at 06:38:21PM +0200, Michael S. Tsirkin wrote:
>> It is sometimes useful to get the value of the reference count after
>> decrement.
>> For example, vhost wants to execute some periodic cleanup operations
>> once number of references drops below a specific value, before it
>> reaches zero (for efficiency).
> 
> You should never care about what the value of the kref is, if you are
> using it correctly :)

It isn't being used to determine when to destroy things.

They use it to as a heuristic of when to trigger polling.

Each ubuf attached gets a kref to the higher level virtio_net buffer
holding object, they want to trigger polling when that reference drops
to 1 or lower.

Right now they are reading the atomic refcount directly, which
I think is much worse than this helper.
