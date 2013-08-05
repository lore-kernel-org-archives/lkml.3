Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3HEIDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:03:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3HEIDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:03:05 -0400
Date: Mon, 5 Aug 2013 16:04:22 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>, stable@vger.kernel.org
Subject: Re: [PATCH] zram: bug fix: delay lock holding in zram_slot_free_noity
Message-ID: <20130805080422.GB15376@kroah.com>
References: <1375687114-4001-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375687114-4001-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:18:34PM +0900, Minchan Kim wrote:
> I was preparing to promote zram and it was almost done.
> Before sending patch, I tried to test and eyebrows went up.
> 
> [1] introduced down_write in zram_slot_free_notify to prevent race
> between zram_slot_free_notify and zram_bvec_[read|write]. The race
> could happen if somebody who has right permission to open swap device
> is reading swap device while it is used by swap in parallel.
> 
> However, zram_slot_free_notify is called with holding spin_lock of
> swap layer so we shouldn't avoid holing mutex. Otherwise, lockdep
> warns it.

As it should.

> I guess, best solution is to redesign zram lock scheme totally but
> we are on the verge of promoting so it's not desirable to change a lot
> critical code and such big change isn't good shape for backporting to
> stable trees so I think the simple patch is best at the moment.

What do you mean by "verge of promoting"?  If it's wrong, it needs to be
fixed properly, don't paper over something.

Please fix this correctly, I really don't care about staging drivers in
stable kernels as lots of distros refuse to enable them (and rightly
so.)

thanks,

greg k-h
