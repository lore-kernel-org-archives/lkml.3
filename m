Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaBMEKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:10:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36363 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaBMEKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:10:04 -0500
Date: Wed, 12 Feb 2014 23:09:53 -0500 (EST)
Message-Id: <20140212.230953.770721407102955395.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qinchuanyu@huawei.com, joern@logfs.org, anatol.pomozov@gmail.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140212.230506.1305102368255894549.davem@davemloft.net>
References: <20140212.190637.328045386111912135.davem@davemloft.net>
	<20140213013902.GA21261@kroah.com>
	<20140212.230506.1305102368255894549.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2014 20:10:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 12 Feb 2014 23:05:06 -0500 (EST)

> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Wed, 12 Feb 2014 17:39:02 -0800
> 
>> Yes, that's horrible as well, but as was already pointed out in this
>> thread, you can't rely on that value to really be "1" after reading it
>> due to the way krefs work, what happened if someone else just grabbed
>> it?
>> 
>> If all they want is a "count" for when to start polling, then use a
>> separate atomic count, but don't abuse the kref interface for this, I
>> don't think that will work properly at all.
> 
> They want to know which thread of control decrements the count to "1"
> as buffers are released.
> 
> That seems entirely reasonable to me.
> 
> They could add another atomic counter for this, but that's rather
> silly since the kref already has an atomic they can use for this
> purpose.

If you still can't understand what they are trying to do, they want to
do something precisely when the number of pending buffers is dropped
to 1 or less.

They are using krefs to track how many buffers are attached at a given
moment.

The counter can re-increment after the decrement to 1 or less occurs,
they don't care.

But they want precisely the entity that drops it down to 1 or less to
perform that action.

Just reading the atomic value directly, they cannot do this.


