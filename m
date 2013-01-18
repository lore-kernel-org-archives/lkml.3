Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3ARQXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:23:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45905 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3ARQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:23:53 -0500
Date: Fri, 18 Jan 2013 16:23:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>,
        "Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>, Andre Przywara <andre@andrep.de>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas <linuxuser330250@gmx.net>
Subject: Re: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to
 fall back to acpi-cpufreq and it is unavailable.
Message-ID: <20130118162347.GA31499@srcf.ucam.org>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130111144940.GB21882@liondog.tnic>
 <20130111165054.GD10751@liondog.tnic>
 <4923C2DE085EEB4FAB1D375DD09D0BA6100CF170@sausexdag04.amd.com>
 <20130117115436.GA3853@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117115436.GA3853@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 12:54:37PM +0100, Borislav Petkov wrote:

> So, handoff to acpi-cpufreq still has some issues. When both are
> built-in, the module_init functions turn into normal initcalls and
> in that case, they're executed in link order and it can happen that
> powernowk8_init() runs before acpi_cpufreq_init().

Just flip the link order? It's only the way it is because in the past we 
wanted to try hardware-specific drivers before more generic ones, and I 
don't think that's a concern in this case now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
