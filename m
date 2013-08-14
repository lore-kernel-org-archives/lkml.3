Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab3HNSgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:36:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760218Ab3HNSgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:36:07 -0400
Date: Wed, 14 Aug 2013 11:36:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Xiaolong Ye <yexl@marvell.com>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add uio_sync_event interface to support mulit-instances
 case in UIO framework
Message-ID: <20130814183606.GB25715@kroah.com>
References: <1376483423-603-1-git-send-email-yexl@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376483423-603-1-git-send-email-yexl@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 08:30:22PM +0800, Xiaolong Ye wrote:
> Hi, guys,
> 
> Recently, we have met fake interrupt issue when using UIO as our vpu
> driver in mulit-instances case, the issue can be described as below:

Do you have a pointer to this driver?

> In multi-instances case, we use vpu_lock(semaphore) to implement the mutually exclusive access to the
> device, each instace open uio device once and will be associated with a fd and its own uio_listener,
> we use poll to wait for the hardware interrupt. So let's assume that there are two instances, A and B,
> their uio_listener->event_count and idev->event are all 0 at the beginning, then A get the vpu_lock and start
> to work, it will block at poll()(because listener->event_count == idev->count) until H/W interrupt happens
> (atomic_inc(&idev->event)), after it releases vpu_lock, B will get the lock and start to work, however,
> its poll will return immediately because B's uio_listener->event_count is 0 while idev->event has been 1,
> that's how the fake interrupt happens.

Why not have just one instance talking to the hardware and then do the
locking in userspace for who ever needs to access the device?

thanks,

greg k-h
