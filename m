Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaHKI2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:28:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHKI2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:28:48 -0400
Date: Mon, 11 Aug 2014 16:28:11 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: hdegoede@redhat.com, kraxel@redhat.com, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Message-ID: <20140811082811.GC1422@kroah.com>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration

Really?  On what processor type?  I don't see that being the case on a
few processors, but I didn't check them all, or I might be totally
confused with all of the arch_spin_is_locked() definitions in the tree.

> and therefore it
> would be advise to repalce with assert_spin_locked().

This implies that all uses of this function is wrong and should be
replaced and removed, right?

thanks,

greg k-h
