Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaAIMCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:02:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65479 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753489AbaAIMCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:02:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: joeyli <jlee@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
Date: Thu, 09 Jan 2014 13:16:21 +0100
Message-ID: <2612691.m9rj3jIJ1M@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1389239259.24105.2.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com> <52CD9139.2070302@zytor.com> <1389239259.24105.2.camel@linux-s257.site>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 11:47:39 AM joeyli wrote:
> 於 三，2014-01-08 於 09:56 -0800，H. Peter Anvin 提到：
> [...]
> > > Document of Windows XP:
> > >
> > http://www.freelists.org/post/windows_errors/what-error-messages-really-mean-WinXP-IO-Ports-Blocked-from-Bios-AML-on-Windows-XP
> > > 
> > > If just for ACPI TAD testing, we can remove the port protection
> > check of
> > > RTC ports in hwvalid.c. I have read 0x70/0x71 port success after
> > removed
> > > the checking in acpica/hwvalid.c.
> > > 
> > > I will try to write RTC port in AML after remove acpica check, maybe
> > > have other unpredictable situation.
> > > 
> > 
> > Now *THERE* is a good use of the "no RTC bit".  In the case that bit
> > is
> > set we should presumably remove these ports from the block list.
> 
> Thanks for your suggestion, I will put a testing patch on this.
> 
> > 
> > Otherwise we should use the CMOS address space, not the I/O port
> > address
> > space.
> > 
> >         -hpa 
> 
> Unfortunately current acpica leaks the SystemCMOS handler:
> 
> ACPI Error: Region SystemCMOS (ID=5) has no handler (20131115/exfldio-299)

This is not an ACPICA problem.  We have no CMOS address space handler in Linux
and arguably there should be one.  So I'd suggest implementing that to start
with or we risk conflicts between kernel code and AML accessing registers in
that space.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
