Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3ART6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:58:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45771 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3ART6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:58:13 -0500
Date: Fri, 18 Jan 2013 20:58:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>, Andre Przywara <andre@andrep.de>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas <linuxuser330250@gmx.net>
Subject: Re: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to
 fall back to acpi-cpufreq and it is unavailable.
Message-ID: <20130118195806.GA3252@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
	"rjw@sisk.pl" <rjw@sisk.pl>, Andre Przywara <andre@andrep.de>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas <linuxuser330250@gmx.net>
References: <20130111144940.GB21882@liondog.tnic>
 <20130111165054.GD10751@liondog.tnic>
 <4923C2DE085EEB4FAB1D375DD09D0BA6100CF170@sausexdag04.amd.com>
 <20130117115436.GA3853@pd.tnic>
 <20130118162347.GA31499@srcf.ucam.org>
 <20130118170755.GB4062@pd.tnic>
 <20130118190021.GD4062@pd.tnic>
 <20130118190659.GB16757@srcf.ucam.org>
 <20130118193656.GE4062@pd.tnic>
 <20130118193834.GA17734@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130118193834.GA17734@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 07:38:34PM +0000, Matthew Garrett wrote:
> On Fri, Jan 18, 2013 at 08:36:56PM +0100, Borislav Petkov wrote:
> 
> > Ok, how much can we rely on ACPI to have this ACPI_ADR_SPACE_SYSTEM_IO
> > properly set on K8? Because the thing is, we want to use acpi-cpufreq on
> > F10h onwards and leave powernow-k8 to K8s.
> 
> SYSTEM_IO only supports single processors and was superceded in ACPI 
> 2.0. Are there any single-core F10h?

Hmm, maybe some downcored creations, who knows? But actually, that
doesn't matter: we want to exit early from acpi-cpufreq loading on K8
only so the check should simply be:

	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
	    boot_cpu_data.x86 == 0xf) {
		pr_debug(...)
		...
	}

Yeah, I think that should work. I'll add your patch to the others and
make a patchset to give it a run. If it looks good, we'll queue it for
3.9 so that it can see more testing.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
