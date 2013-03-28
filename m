Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3C1FEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 01:04:15 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:62792 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3C1FEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 01:04:13 -0400
Message-ID: <1364447081.15039.5.camel@gitbox>
Subject: Re: [PATCH 6/6] video: fb: vt8500: Convert framebuffer drivers to
 standardized binding
From: Tony Prisk <linux@prisktech.co.nz>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Cc: linux-fbdev@vger.kernel.org, florianschandinat@gmx.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 18:04:41 +1300
In-Reply-To: <5152D39F.1090104@ti.com>
References: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
	 <1364374021-10844-7-git-send-email-linux@prisktech.co.nz>
	 <5152D39F.1090104@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 13:10 +0200, Tomi Valkeinen wrote:
> Hi,
> 
> On 2013-03-27 10:47, Tony Prisk wrote:
> > Now that a display timing binding is available, convert our almost identical
> > binding to use the standard binding.
> > 
> > This patch converts the vt8500 and wm8505 framebuffer drivers and
> > associated dts/dtsi files to use the standard binding as defined in
> > bindings/video/display-timing.txt.
> > 
> > There are two side-effects of making this conversion:
> > 
> > 1) The fb node should now be in the board file, rather than the soc file as
> > the display-timing node is a child of the fb node.
> > 
> > 2) We still require a bits per pixel property to initialize the framebuffer
> > for the different lcd panels. Rather than including this as part of the
> > display timing, it is moved into the framebuffer node.
> > 
> > I have also taken the opportunity to alphabetise the includes of each
> > driver to avoid double-ups.
> 
> I don't think this is correct. I don't have that much experience with
> DT, but I think you should have, for example:
> 
> wm8850.dtsi:
> 
> 	fb: fb@d8051700 {
> 		compatible = "wm,wm8505-fb";
> 		reg = <0xd8051700 0x200>;
> 	};
> 
> wm8850-w70v2.dts:
> 
> &fb {
> 	bits-per-pixel = <16>;
> 
> 	display-timings {
> 		native-mode = <&timing0>;
> 		timing0: 800x480 {
> 			clock-frequency = <0>;
> 			...
> 		};
> 	};
> };
> 
> So, the core fb part should be in the SoC's file, as it's part of the
> SoC. And the stuff that tells what kind of display is attached is in the
> board dts file.
> 
> Also, just a word of warning, I think the videomode series I've sent for
> review will cause some breakage with this series if the videomode series
> is accepted. Nothing difficult to fix, though, but we'll need some extra
> management to avoid compilation failures.
> 
>  Tomi
> 
> 

Thanks for the feedback and the heads-up.

I believe you are correct about the DT info - it looks right when
described the way you did, so I have changed it.

If there is no other feedback, I will post a version 2 after Easter.

Regards
Tony P

