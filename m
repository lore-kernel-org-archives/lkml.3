Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaAIDt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 22:49:27 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:37876 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaAIDtX (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 8 Jan 2014 22:49:23 -0500
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
In-Reply-To: <52CD9139.2070302@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>
	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>
	 <52CB929C.6050403@zytor.com> <1389091244.3539.6095.camel@linux-s257.site>
	 <52CC2CDF.3000100@zytor.com> <1389193142.3539.6123.camel@linux-s257.site>
	 <52CD9139.2070302@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jan 2014 11:47:39 +0800
Message-ID: <1389239259.24105.2.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2014-01-08 於 09:56 -0800，H. Peter Anvin 提到：
[...]
> > Document of Windows XP:
> >
> http://www.freelists.org/post/windows_errors/what-error-messages-really-mean-WinXP-IO-Ports-Blocked-from-Bios-AML-on-Windows-XP
> > 
> > If just for ACPI TAD testing, we can remove the port protection
> check of
> > RTC ports in hwvalid.c. I have read 0x70/0x71 port success after
> removed
> > the checking in acpica/hwvalid.c.
> > 
> > I will try to write RTC port in AML after remove acpica check, maybe
> > have other unpredictable situation.
> > 
> 
> Now *THERE* is a good use of the "no RTC bit".  In the case that bit
> is
> set we should presumably remove these ports from the block list.

Thanks for your suggestion, I will put a testing patch on this.

> 
> Otherwise we should use the CMOS address space, not the I/O port
> address
> space.
> 
>         -hpa 

Unfortunately current acpica leaks the SystemCMOS handler:

ACPI Error: Region SystemCMOS (ID=5) has no handler (20131115/exfldio-299)


Regards
Joey Lee


