Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3JSJ57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 05:57:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57312 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3JSJ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 05:57:57 -0400
Date: Sat, 19 Oct 2013 11:57:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131019095753.GA26338@pd.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
 <20131018125326.GC1007@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31D41E37@ORSMSX106.amr.corp.intel.com>
 <20131018212741.GA26049@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31D41FD3@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D41FD3@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:22:26PM +0000, Luck, Tony wrote:
> @@ -154,6 +154,10 @@ void mce_log(struct mce *mce)
>  	/* Emit the trace record: */
>  	trace_mce_record(mce);
>  
> +	if (mce_ext_err_print)
> +		if (mce_ext_err_print(NULL, m.extcpu, i))
> +			return;
> +
>  	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
>  	if (ret == NOTIFY_STOP)
>  		return;
> 
> If we move mce_ext_err_print() this far ... then it's only one line further down
> to have it be part of the x86_mce_decoder_chain as suggested by Naveen.

Right, if you want mce_ext_err_print() to be the first and the only one
called on the chain, then you'd have to play with the priority.

But yes, this is possible and it would make it all even cleaner
and simpler by simply not needing the reg/dereg interfaces for
mce_ext_err_print but adding it to the chain.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
