Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3ARRIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:08:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46862 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3ARRIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:08:01 -0500
Date: Fri, 18 Jan 2013 18:07:55 +0100
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
Message-ID: <20130118170755.GB4062@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
	"rjw@sisk.pl" <rjw@sisk.pl>, Andre Przywara <andre@andrep.de>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas <linuxuser330250@gmx.net>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130111144940.GB21882@liondog.tnic>
 <20130111165054.GD10751@liondog.tnic>
 <4923C2DE085EEB4FAB1D375DD09D0BA6100CF170@sausexdag04.amd.com>
 <20130117115436.GA3853@pd.tnic>
 <20130118162347.GA31499@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130118162347.GA31499@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 04:23:47PM +0000, Matthew Garrett wrote:
> On Thu, Jan 17, 2013 at 12:54:37PM +0100, Borislav Petkov wrote:
> 
> > So, handoff to acpi-cpufreq still has some issues. When both are
> > built-in, the module_init functions turn into normal initcalls and
> > in that case, they're executed in link order and it can happen that
> > powernowk8_init() runs before acpi_cpufreq_init().
> 
> Just flip the link order? It's only the way it is because in the past we 
> wanted to try hardware-specific drivers before more generic ones, and I 
> don't think that's a concern in this case now.

Yeah, I heard that the acpi-idle and intel-idle drivers do that and also
heard that it was a hack. It doesn't look too ugly IMHO:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2671717265ae6e720a9ba5f13fbec3a718983b65

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
