Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaCKIws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:52:48 -0400
Received: from bes.se.axis.com ([195.60.68.10]:59045 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbaCKIwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:52:45 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2014 04:52:45 EDT
Date: Tue, 11 Mar 2014 09:43:39 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cris: Convert ffs from an object-like macro to a
 function-like macro
Message-ID: <20140311084339.GY25718@axis.com>
References: <1394457733-7141-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394457733-7141-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 02:22:13PM +0100, Geert Uytterhoeven wrote:
> This avoids bad interactions with code using identifiers called "ffs":
> 
> drivers/usb/gadget/f_fs.c: In function 'ffsmod_init':
> drivers/usb/gadget/f_fs.c:2693:494: error: 'ffsusb_func' undeclared (first use in this function)
> drivers/usb/gadget/f_fs.c:2693:494: note: each undeclared identifier is reported only once for each function it appears in
> drivers/usb/gadget/f_fs.c: In function 'ffsmod_exit':
> drivers/usb/gadget/f_fs.c:2693:677: error: 'ffsusb_func' undeclared (first use in this function)
> drivers/usb/gadget/f_fs.c: At top level:
> drivers/usb/gadget/f_fs.c:2693:35: warning: 'kernel_ffsusb_func' defined but not used [-Wunused-variable]
> drivers/usb/gadget/f_fs.c: In function 'ffsmod_init':
> drivers/usb/gadget/f_fs.c:2693:15: warning: control reaches end of non-void function [-Wreturn-type]

Yup, quite right. Andrew already added it to his queue,
but for the mailing archives here's my:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
