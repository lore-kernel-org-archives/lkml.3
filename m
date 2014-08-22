Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaHVWsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:48:22 -0400
Received: from mout.gmx.net ([212.227.15.19]:58541 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaHVWsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:48:21 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm_tis: Verify ACPI-specified interrupt
Date: Sat, 23 Aug 2014 00:48:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.0-rc7; KDE/4.12.5; x86_64; ; )
Cc: Scot Doyle <lkml14@scotdoyle.com>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        semenzato@google.com
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain> <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain> <20140822203241.GB1733@obsidianresearch.com>
In-Reply-To: <20140822203241.GB1733@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408230048.47293.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:iaYVa8CIHVyAlmL+tbzK6WSqZCWKR0RL9JkUyL8wtzl33lyFR54
 az2mGZ62ikFMqZZsTKfGrBu2cy+0uGNGv32gG/jpoMktOnpk3+c5UQ4xz4XT+Ot3g02an/Z
 WLkWMVsaZ5cWJC3sDwNano3xk4kgJu4ahuB+nRfI/9zrneOmZDVxIsTaijDBaYi/kdafGfX
 aBxOCHszbfrwq5HxuWwOg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Luigi, he works at Google and is responsible for the TPMs in 
Chromebooks ;)

Thanks,
Peter

Am Freitag, 22. August 2014, 22:32:41 schrieb Jason Gunthorpe:
> On Fri, Aug 22, 2014 at 08:17:27PM +0000, Scot Doyle wrote:
> > On Fri, 22 Aug 2014, Jason Gunthorpe wrote:
> > > On Fri, Aug 22, 2014 at 12:58:41AM +0000, Scot Doyle wrote:
> > >> Some machines, such as the Acer C720 and Toshiba CB35, have 
TPMs
> > >> that do not use interrupts while also having an ACPI TPM 
entry
> > > 
> > > How do these machines work in Windows?
> > 
> > I don't know. Since they're Chromebooks (booted in legacy mode 
running
> > SeaBIOS instead of depthcharge or whatever ChromeOS uses), I 
think
> > they're mostly used to run Linux.
> 
> I remain somewhat confused - there have already been TPM patches 
for
> Chromebooks from Google - presumably the TPM actually does work
> fine. Make sure you are using a Linux with the ATMEL timeout fix, 
that
> is particularly applicable to Chromebooks IIRC.
> 
> And again, the driver uses interrupts when booting, so I'm 
somewhat
> confused what the problem is. I wouldn't think the driver would
> successfully attach if interrupts were enabled but the interrupt
> didn't work? Can you elaborate on what is going on during boot 
with
> the interrupt, and the boot time GET_DURATIONS and TPM_STARTUP
> sequences?
> 
> Perhaps the driver is timing out all commands and going ahead and
> attaching anyhow? If this is the case I think we'd get a good 
result
> if we just fixed that and had the driver simply not attach. Then 
your
> resume will not be broken.
> 
> > > I'd be more comfortable with some kind of ACPI black list or 
patch or
> > > something? What is normal for handling broken ACPI?
> > 
> > I would be more comfortable with this general approach as well. 
However,
> > I've had to submit several patches for individual Chromebooks 
related to
> > backlight control since the VBT also is misconfigured. Would it 
be
> > possible to find a blacklist mechanism that didn't require 
identifying
> > each Chromebook separately, since they seem to have this issue 
on an
> > ongoing basis?
> 
> So, if you are booting the Chromebook in some weird way, is this 
a
> problem that can be addressed by patching SeaBIOS instead of the
> kernel? The internet says the SeaBIOS payload is replaceable on 
the
> Chromebook.
> 
> Can it fix the ACPI tables to be correct before lauching Linux?
> 
> > A more general approach might be to verify the ACPI interrupt 
for
> > systems matching the first three identifiers.
> 
> Testing the interrupt and failing driver attach if it doesn't 
work
> seems very reasonable to me, I would view that as a bug fix in 
the driver.
> 
> Jason

