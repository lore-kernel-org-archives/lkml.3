Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaGBMRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:17:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43242 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaGBMRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:17:07 -0400
Date: Wed, 2 Jul 2014 14:17:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org
Subject: Re: [PATCH v4 3/3] acpi, apei, ghes: Factor out ioremap virtual
 memory for IRQ and NMI context.
Message-ID: <20140702121700.GG1318@pd.tnic>
References: <1403610095-5354-1-git-send-email-tomasz.nowicki@linaro.org>
 <1403610095-5354-4-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403610095-5354-4-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:41:35PM +0200, Tomasz Nowicki wrote:
> GHES currently maps two pages with atomic_ioremap.  From now
> on, NMI is architectural depended so there is no need to allocate
> an NMI page for platforms without NMI support.
> 
> To make it possible to not use a second page, swap the existing
> page order so that the IRQ context page is first, and the optional
> NMI context page is second.  Then, use HAVE_ACPI_APEI_NMI to decide
> how many pages are to be allocated.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
