Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaG1POV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:14:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaG1POC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:14:02 -0400
Date: Mon, 28 Jul 2014 08:13:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>, Peter Hurley <peter@hurleysoftware.com>,
        gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] tty/n_gsm.c: do not clear gsm_mux entry when the gsm is
 not closed
Message-ID: <20140728151324.GA12973@kroah.com>
References: <53D0CF0D.9060103@intel.com>
 <20140727180953.GA7232@kroah.com>
 <53D5F8C9.4070008@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D5F8C9.4070008@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:16:25PM +0800, xinhui.pan wrote:
> > Why can't you do dynamic reference counting of your structure, that
> > would allow you to get rid of your global array, right?
> > 
> 
> Thanks for your nice comments.
> Struct gsm has a ref-count already. :)

Then you should be fine, no need to keep it in an array.

> And also adding a ref-count is a little hard to me. :(
> This global array is used to keep tracking the gsms that stands for the gsmttyXX.

You shouldn't need that at all, just use a list, you don't care what the
XX number is within the driver, just allocate a new one with the next
available number and you should be fine.

> and it can tell us if we can create a new gsm. :)

You should always be able to create a new gsm if you need to :)

> In gsm_init we set *gsm_tty_driver = alloc_tty_driver(256);*

Why limit to 256?  Just use a list, and a idr structure to allocate the
minor number, and all should be good.

thanks,

greg k-h
