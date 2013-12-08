Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab3LHOnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:43:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49872 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab3LHOnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:43:15 -0500
Date: Sun, 8 Dec 2013 15:43:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rui Wang <ruiv.wang@gmail.com>
Cc: lance.ortiz@hp.com, bhelgaas@google.com, lance_ortiz@hotmail.com,
        jiang.liu@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com,
        m.chehab@samsung.com, Rui Wang <rui.y.wang@intel.com>
Subject: Re: [PATCH] aerdrv: Fix severity usage in aer trace event
Message-ID: <20131208144312.GC4338@pd.tnic>
References: <1386476273-2418-1-git-send-email-rui.y.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386476273-2418-1-git-send-email-rui.y.wang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 12:17:53PM +0800, Rui Wang wrote:
> There's inconsistency between dmesg and the trace event output.
> When dmesg says "severity=Corrected", the trace event says
> "severity=Fatal". What happens is that HW_EVENT_ERR_CORRECTED is
> defined in edac.h:
> 
> enum hw_event_mc_err_type {
>         HW_EVENT_ERR_CORRECTED,
>         HW_EVENT_ERR_UNCORRECTED,
>         HW_EVENT_ERR_FATAL,
>         HW_EVENT_ERR_INFO,
> };
> 
> while aer_print_error() uses aer_error_severity_string[] defined as:
> 
> static const char *aer_error_severity_string[] = {
>         "Uncorrected (Non-Fatal)",
>         "Uncorrected (Fatal)",
>         "Corrected"
> };
> 
> In this case dmesg is correct because info->severity is assigned in
> aer_isr_one_error() using the definitions in include/linux/ras.h:
> 
> Signed-off-by: Rui Wang <rui.y.wang@intel.com>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
