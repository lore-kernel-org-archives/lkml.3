Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab3LDUip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:38:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41058 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932999Ab3LDUik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:38:40 -0500
Date: Wed, 4 Dec 2013 21:38:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: rui wang <ruiv.wang@gmail.com>
Cc: Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@intel.com, tony.luck@intel.com,
        rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        gong.chen@intel.com
Subject: Re: [PATCH v10 1/3] aerdrv: Trace Event for AER
Message-ID: <20131204203837.GA7517@pd.tnic>
References: <20130116235102.16015.77379.stgit@grignak.americas.hpqcorp.net>
 <CANVTcTaP18CiGOSEcX5Ch_wPw9mEhkgokfp+d+ZOMFD+Ce4juA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANVTcTaP18CiGOSEcX5Ch_wPw9mEhkgokfp+d+ZOMFD+Ce4juA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 01:05:16PM +0800, rui wang wrote:
> > +	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
> > +		__get_str(dev_name),
> > +		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
> > +			__entry->severity == HW_EVENT_ERR_FATAL ?
> > +			"Fatal" : "Uncorrected",
> > +		__entry->severity == HW_EVENT_ERR_CORRECTED ?
> > +		__print_flags(__entry->status, "|", aer_correctable_errors) :
> > +		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
> > +);
> 
> This causes inconsistency between dmesg and the trace event output.
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
> #define AER_NONFATAL                    0
> #define AER_FATAL                       1
> #define AER_CORRECTABLE                 2
> 
> So which one is the standard? Is there a plan to unify all these names?

Yes, the AER tracepoint above should use the AER_* defines and not the
HW_EVENT_ERR_* ones which are for memory errors.

Wanna send a fix?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
