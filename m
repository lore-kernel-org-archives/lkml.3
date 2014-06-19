Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbaFSO3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:29:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59203 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbaFSO3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:29:03 -0400
Date: Thu, 19 Jun 2014 16:28:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>, rjw@rjwysocki.net,
        lenb@kernel.org, tony.luck@intel.com, m.chehab@samsung.com, bp@suse.de,
        linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v3 3/5] acpi, apei, ghes: Introduce more generic
 mechanism to init/deinit GHES error notifications.
Message-ID: <20140619142855.GF22025@pd.tnic>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
 <1402657380-18539-4-git-send-email-tomasz.nowicki@linaro.org>
 <20140613131051.GY27560@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140613131051.GY27560@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 03:10:51PM +0200, Robert Richter wrote:
> On 13.06.14 13:02:58, Tomasz Nowicki wrote:
> 
> > @@ -811,6 +819,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
> >  	int sev, sev_global = -1;
> >  	int ret = NMI_DONE;
> >  
> > +	BUG_ON(!IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI));
> > +
> 
> Now that we have the ARCH_HAS_ACPI_APEI_NMI option, group nmi code,
> put it in an #ifdef ... and make function stubs for the !nmi case
> where necessary. That code should moved to patch #2. If an arch does
> not support nmi code, we don't want to compile it into the kernel.
> 
> Also this patch is quit a bit large and should further split into
> moving functional code into separate functions and the introduction of
> the notifier setup. This makes review much easier.
> 
> I did not yet took a deep look into your notifier framework, but I
> don't really see a reason for the dynamic collection of function
> pointers in ghes_notify_tab. See below.

Ok, I'll wait out with further review after you've integrated Robert's
comments.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
