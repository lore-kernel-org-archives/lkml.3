Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaBMEFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:05:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36327 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaBMEFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:05:23 -0500
Date: Wed, 12 Feb 2014 23:05:06 -0500 (EST)
Message-Id: <20140212.230506.1305102368255894549.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qinchuanyu@huawei.com, joern@logfs.org, anatol.pomozov@gmail.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140213013902.GA21261@kroah.com>
References: <20140212165630.GA22991@kroah.com>
	<20140212.190637.328045386111912135.davem@davemloft.net>
	<20140213013902.GA21261@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2014 20:05:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 12 Feb 2014 17:39:02 -0800

> Yes, that's horrible as well, but as was already pointed out in this
> thread, you can't rely on that value to really be "1" after reading it
> due to the way krefs work, what happened if someone else just grabbed
> it?
> 
> If all they want is a "count" for when to start polling, then use a
> separate atomic count, but don't abuse the kref interface for this, I
> don't think that will work properly at all.

They want to know which thread of control decrements the count to "1"
as buffers are released.

That seems entirely reasonable to me.

They could add another atomic counter for this, but that's rather
silly since the kref already has an atomic they can use for this
purpose.
