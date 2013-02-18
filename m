Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3BRTkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:40:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39122 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3BRTke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:40:34 -0500
Date: Mon, 18 Feb 2013 20:40:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218194031.GD16622@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
 <20130218155215.GB2663@arwen.pp.htv.fi>
 <20130218171334.GA31329@kroah.com>
 <20130218172700.GH2663@arwen.pp.htv.fi>
 <20130218174527.GB16628@pd.tnic>
 <20130218184735.GD10755@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130218184735.GD10755@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 08:47:35PM +0200, Felipe Balbi wrote:
> On Mon, Feb 18, 2013 at 06:45:27PM +0100, Borislav Petkov wrote:
> > On Mon, Feb 18, 2013 at 07:27:00PM +0200, Felipe Balbi wrote:
> > > No such device - /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
> > 
> > Looks like your edac module doesn't allow scrub rate setting. Which edac
> > driver is that? dmesg?
> 
> $ lsmod | grep -i edac
> i7core_edac            22414  0 
> edac_core              43453  2 i7core_edac

Ok, that would be those i7s which reportedly do
not support reading/setting the scrub rate, see
27100db0e0d381d24b6f3cb1a4f439996e7c00c8, for example.

So this is as expected.

Maybe it would be more correct if the core would return "N/A" or
"unsupported" or something to that effect in such cases, to conform with
the readable flag of the sysfs file.

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
