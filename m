Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3JRMxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:53:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50628 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3JRMx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:53:29 -0400
Date: Fri, 18 Oct 2013 14:53:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        joe@perches.com, m.chehab@samsung.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131018125326.GC1007@pd.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52612BA4.2060906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 06:07:56PM +0530, Naveen N. Rao wrote:
> >@@ -624,6 +641,9 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
> >  		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
> >  			continue;
> >
> >+		if (mce_ext_err_print)
> >+			mce_ext_err_print(NULL, m.extcpu, i);
> >+
> 
> Can we use the notifier chain we already have:
> mce_register_decode_chain()? EDAC uses this and I'm wondering if it
> is a good fit here. As an added bonus, it seems to honor dont_log_ce
> option as well.

Hmm, that's a good question you raise: but the more important question
is, do you guys - Gong and Tony - want to replace the logging we're
already doing, i.e. mce_log() with extlog or not.

Because if you want to replace the current logging you actually have to
exit machine_check_poll() after having done mce_ext_err_print() so that
the rest of the chain doesn't see the error.

And, does mce_ext_err_print only report DRAM ECC errors or other error
types too?

Btw, if we keep both, then we're going to have two tracepoints -
trace_mce_record() in mce_log() and this one - issuing each a record for
the same event. Which is not really what we want I'd say...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
