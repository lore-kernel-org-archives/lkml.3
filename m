Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3LUCoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:44:55 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:59531 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3LUCox (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 20 Dec 2013 21:44:53 -0500
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
From: joeyli <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
In-Reply-To: <2787644.ytU7M33B4r@vostro.rjw.lan>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <1387517916.3539.4446.camel@linux-s257.site> <52B4B242.5010002@zytor.com>
	 <2787644.ytU7M33B4r@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Dec 2013 10:43:25 +0800
Message-ID: <1387593805.3539.4983.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2013-12-20 於 22:45 +0100，Rafael J. Wysocki 提到：
> On Friday, December 20, 2013 01:10:26 PM H. Peter Anvin wrote:
> > On 12/19/2013 09:38 PM, joeyli wrote:
> > > 
> > > If don't use EFI time, then the first priority is using ACPI TAD if it
> > > present. Due to ACPI TAD is a generic acpi device that's need OS parsing
> > > DSDT table before set system time.
> > > 
> > > Either move DSDT parser from subsystem initial stage to start_kernel or
> > > move timekeeping initial to after DSDT be parsed. Which one you think is
> > > more possible and risk less? Then I will try that way.
> > > 
> > 
> > I discussed the DSDT/SSDT parsing issue with Rafael and he claims it
> > would require a lot of restructuring.  Unfortunately ACPI is at this
> > point done rather late, as I understand.  All of this is a big problem.
> 
> My understanding, however, is that to use the TAD, we don't actually need to
> create a struct acpi_device for it.  We just need a handle to the ACPICA
> object which can be found using acpi_get_devices() as soon as the namespace
> has been extracted from the DSDT and friends.  That in turn happens in
> acpi_early_init(), which is called from start_kernel() right before
> efi_late_init().
> 
> Is that early enough?
> 
> Rafael
> 

Thanks for your good suggestion, then I have a direction on using ACPI
TAD earlier.

Joey Lee


