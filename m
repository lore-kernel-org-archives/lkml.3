Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaDUVFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:05:08 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:37605
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbaDUVFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:05:05 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=BdtlclQ1lucA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=9xZ5ZFGArI9Z6wTsXvUA:9
 a=QEXdDO2ut3YA:10 a=_dQi-Dcv4p4A:10
Date: Mon, 21 Apr 2014 22:05:02 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display
Message-ID: <20140421210502.GA27983@milliways>
References: <20140421203207.GA27025@milliways>
 <CADnq5_OhN7B2FG_tHSJq-FCnqVUz4Bwh1EDXwTqCtv0zrAiDKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_OhN7B2FG_tHSJq-FCnqVUz4Bwh1EDXwTqCtv0zrAiDKQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 04:54:15PM -0400, Alex Deucher wrote:
> On Mon, Apr 21, 2014 at 4:32 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> >  I've just built 3.15.0-rc2 on this box, and discovered that I get a
> > blank screen.  The boot appears to complete (it sends me information
> > from SMART which is from my last bootscript), and it responds to
> > MagicSysRQ to reboot.  I tried to login and run startx, but that
> > didn't seem to make any difference - possibly something went wrong,
> > it wasn't in my history when I booted a good kernel.
> >
> >  This machine uses a regular old VGA cable to connect it, the
> > following lines in dmesg make me think it has chosen the wrong
> > connector:
> 
> VGA is implemented as a DP to VGA bridge on APUs.
> 
> >
> > Apr 21 19:32:45 bluesbreaker kernel: [    1.273246]
> > [drm:radeon_dp_link_train_cr] *ERROR* displayport link status failed
> > Apr 21 19:32:45 bluesbreaker kernel: [    1.273247]
> > [drm:radeon_dp_link_train_cr] *ERROR* clock recovery failed
> > Apr 21 19:32:45 bluesbreaker kernel: [    1.295116] Console:
> > switching to colour frame buffer device 85x34
> >
> >  On a boot with 3.14.0 and earlier I get a different console size -
> > Apr 21 20:42:44 bluesbreaker kernel: [    1.445992] Console:
> > switching to colour frame buffer device 133x54
> >
> >  My console font is 12x22, and my screen is 1600x1200 but it looks
> > as if 3.15-rc2 has fallen back to trying to use 1024x768.
> >
> >  I'm attaching what look like the relevant parts of the messages
> > from the system logs for 3.15-rc2 and 3.14.0.
> >
> >  Any ideas, please ?  This is an AMD A4-5300 APU and not the world's
> > fastest machine for bisecting :-(
> 
> I'd guess it's either the pll rework patches or the switch to the
> common dp helper code patches.  It would be helpful if you could
> bisect.
> 
> Alex

 OK, I guess I can do the builds on a faster machine.

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
