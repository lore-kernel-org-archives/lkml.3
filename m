Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3LTWFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:05:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63362 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751463Ab3LTWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:05:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, joeyli <jlee@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 23:18:56 +0100
Message-ID: <3476450.BMEcId2Lgj@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131220215056.GA29501@console-pimps.org>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <52B4BA0A.1030902@zytor.com> <20131220215056.GA29501@console-pimps.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 20, 2013 09:50:56 PM Matt Fleming wrote:
> On Fri, 20 Dec, at 01:43:38PM, H. Peter Anvin wrote:
> > 
> > Possibly... will have to investigate.  I would also ask if the same
> > applies to the PNP0B0x devices -- all we really need there is the
> > presence/absence indication and the I/O port base.
> 
> It's worth noting that efi_late_init() exists solely because the ACPI
> infrastructure to find the BGRT table isn't available any earlier.
> 
> If we could setup ACPI earlier that would be awesome.

I'm not sure 100%, but I *think* we need to do that with interrupts enabled.
At least after mm_init(), because it relies on things initialized there if I
remember correctly.

>From what I can tell at the moment, it might be possible to move it before
efi_enter_virtual_mode() if that would help.

Thanks,
Rafael

