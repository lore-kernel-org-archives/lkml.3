Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab3BVO0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:26:40 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47982 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3BVO0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:26:39 -0500
Date: Fri, 22 Feb 2013 06:26:20 -0800
From: Kumar amit mehta <gmate.amit@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: gregkh@linuxfoundation.org, fmhess@users.sourceforge.net,
        hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: drivers: usbduxsigma.c: fix DMA
 buffers on stack
Message-ID: <20130222142619.GA11141@gmail.com>
References: <1361513228-8897-1-git-send-email-gmate.amit@gmail.com>
 <51274244.6080507@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51274244.6080507@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 10:02:44AM +0000, Ian Abbott wrote:
> On 2013-02-22 06:07, Kumar Amit Mehta wrote:
> >This patch fixes an instance of DMA buffer on stack(being passed to
> >usb_control_msg)for the USB-DUXsigma Board driver. Found using smatch.
> >
> 
> Looks good here too.
> 
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> 
> Would you mind doing the same for usbdux.c and usbduxfast.c?
Sure. 
As pointed out by Dan, Do you really want the buffer to be of 16 bytes, as we
are using only the first byte and passing the length as '1' in:
usbduxsub_start, usbduxsub_stop, usbduxfastsub_start, usbduxfastsub_stop ?

~Amit
