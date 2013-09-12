Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3ILWMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:12:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54593 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472Ab3ILWM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:12:28 -0400
X-Sasl-enc: pcSLluVwEC5Lni+wnPiUNmkiVRPz2LnIfTL4zMZRFLvf 1379023945
Date: Thu, 12 Sep 2013 15:12:24 -0700
From: Greg KH <greg@kroah.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Minchan Kim <minchan@kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: fix handle_pending_slot_free() and
 zram_reset_device() race
Message-ID: <20130912221224.GA11463@kroah.com>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
 <20130910145802.GD19256@mwanda>
 <20130910231250.GA2450@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910231250.GA2450@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 02:12:50AM +0300, Sergey Senozhatsky wrote:
> Dan Carpenter noted that handle_pending_slot_free() is racy with
> zram_reset_device(). Take write init_lock in zram_slot_free(), thus
> preventing any concurrent zram_slot_free(), zram_bvec_rw() or
> zram_reset_device(). This also allows to safely check zram->init_done
> in handle_pending_slot_free().
> 
> Initial intention was to minimze number of handle_pending_slot_free()
> call from zram_bvec_rw(), which were slowing down READ requests due to
> slot_free_lock spin lock. Jerome Marchand suggested to remove
> handle_pending_slot_free() from zram_bvec_rw().
> 
> Link: https://lkml.org/lkml/2013/9/9/172
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

I have multiple versions of this and the other zram patches from you,
with no idea of which to accept.

So, I'm going to drop them all, can you please resend what you wish to
submit, and in the future, be a bit more obvious with your "vN"
markings?

thanks,

greg k-h
