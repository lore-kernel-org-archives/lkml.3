Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3LCRCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:02:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34107 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3LCRCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:02:36 -0500
Date: Tue, 3 Dec 2013 17:02:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Graeme Gregory <graeme.gregory@linaro.org>, patches@linaro.org,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jon Masters <jonathan@jonmasters.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part1 PATCH 3/7] ACPI / processor_core: Rework _PDC
 related stuff to make it more arch-independent
Message-ID: <20131203170223.GA14624@srcf.ucam.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <1386088611-2801-4-git-send-email-hanjun.guo@linaro.org>
 <20131203165140.24a05540@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203165140.24a05540@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:51:40PM +0000, One Thousand Gnomes wrote:
> On Wed,  4 Dec 2013 00:36:47 +0800
> Hanjun Guo <hanjun.guo@linaro.org> wrote:
> 
> > _PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
> > rework the code to make it more arch-independent.
> > 
> > The return value of acpi_processor_eval_pdc() should be 'acpi_status' but
> > defined as 'int', fix it too.
> 
> Why not just define boot_options_idle_override as well. Then you can
> leave the code unchanged. Also more importantly you can have override
> values for ARM when it turns out you need those too and the logic will be
> the same for both processor families

The arguments to _PDC are architecture specific, so there do need to be 
code changes here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
