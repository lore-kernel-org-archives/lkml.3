Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3LTKxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:53:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab3LTKxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:53:13 -0500
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: joeyli <jlee@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 11:53:10 +0100
Message-ID: <1775986.qxTh3ADDRn@skinner>
User-Agent: KMail/4.11.3 (Linux/3.11.6-4-desktop; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52B3C5F0.1060303@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <1387512357.3539.4317.camel@linux-s257.site> <52B3C5F0.1060303@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 19, 2013 08:22:08 PM H. Peter Anvin wrote:
> On 12/19/2013 08:05 PM, joeyli wrote:
> > Then that means the priority of PNP0B0x is higher then "CMOS RTC Not
> > Present" flag. ACPI spec doesn't have clear definition on this.
> 
> According to the Microsoft requirements documents, such a platform is
> broken and shouldn't exist.

Is this a public document?
Probably not but if, a pointer in this thread would help.
Does Microsoft mention ACPI Time and Alarm Device interface in
such a document already?

I expect that future platforms will make more and more use of the
ACPI/EFI specified time functions.

It's probably up to Microsoft requiring this at some point of time,
then this stuff will work reliable, possibly others will not anymore.

Given the fact that there are machines which implement this interface
already and it is likely that more and more will, IMHO a first
implementation of this stuff in the kernel, even there are broken BIOSes
around, makes *a lot of* sense.

I suggest a whitelist, however it looks like:
  -> platforms which do not have a PNP0B0x device?
  -> dmi whitelist working platforms
  -> Extend it later with conditions where we know things work as expected

best also introduce an acpi=enable/disable_tad (or simlar) boot param which 
overrides white/blacklisting.
This will allow users to make use of this which may otherwise run into
problems and it will also allow easier testing and feedback
how reliable latest BIOS implementations are.


    Thomas
