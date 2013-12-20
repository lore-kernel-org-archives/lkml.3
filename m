Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3LTVbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:31:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62937 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753512Ab3LTVbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:31:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: joeyli <jlee@suse.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 22:45:11 +0100
Message-ID: <2787644.ytU7M33B4r@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52B4B242.5010002@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <1387517916.3539.4446.camel@linux-s257.site> <52B4B242.5010002@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 20, 2013 01:10:26 PM H. Peter Anvin wrote:
> On 12/19/2013 09:38 PM, joeyli wrote:
> > 
> > If don't use EFI time, then the first priority is using ACPI TAD if it
> > present. Due to ACPI TAD is a generic acpi device that's need OS parsing
> > DSDT table before set system time.
> > 
> > Either move DSDT parser from subsystem initial stage to start_kernel or
> > move timekeeping initial to after DSDT be parsed. Which one you think is
> > more possible and risk less? Then I will try that way.
> > 
> 
> I discussed the DSDT/SSDT parsing issue with Rafael and he claims it
> would require a lot of restructuring.  Unfortunately ACPI is at this
> point done rather late, as I understand.  All of this is a big problem.

My understanding, however, is that to use the TAD, we don't actually need to
create a struct acpi_device for it.  We just need a handle to the ACPICA
object which can be found using acpi_get_devices() as soon as the namespace
has been extracted from the DSDT and friends.  That in turn happens in
acpi_early_init(), which is called from start_kernel() right before
efi_late_init().

Is that early enough?

Rafael

