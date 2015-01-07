Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbbAGRHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:07:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40925 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbbAGRHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:07:00 -0500
Date: Wed, 7 Jan 2015 18:06:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tony.luck@intel.com,
        dougthompson@xmission.com, mchehab@osg.samsung.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        dave.hansen@linux.intel.com, mgorman@suse.de, bp@suse.de,
        riel@redhat.com, jacob.w.shin@gmail.com
Subject: Re: [PATCH 0/3] Fix MCE handling for AMD multi-node processors
Message-ID: <20150107170654.GG3984@pd.tnic>
References: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141222201542.GB1942@pd.tnic>
 <5498858F.1030209@amd.com>
 <20141222231929.GC1942@pd.tnic>
 <5499C57B.5030900@amd.com>
 <54AC75A7.6050608@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54AC75A7.6050608@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:54:15PM -0600, Aravind Gopalakrishnan wrote:
> Hi Boris,
> It seems my earlier understanding of hardware behavior was not completely
> right.
> Here are some clarifications I have received after some internal discussion-
> When D18F3x44[NBMstToMstCpuEn] is set, the interrupt is also routed to the
> NBC.

Good :)

> This was not immediately clear to me from the description for the field in
> the BKDG.
> The BKDG states that errors are reported to the NBC and also that status,
> addr, ctl
> MSRs for MC4 are only accessible from the NBC.
> I took this to understand that the error info is written to the NBC MSRs
> while
> the #MC could be generated from the non-NBC.
> 
> Now, given that setting NBMstToMstCpuEn ensures #MC is generated only on NBC
> for MC4 errors,
> we don't have a problem to solve in the #MC handler code.
> So, we can discard patch2 of the series,
> 
> But we still need to change the error injection interfaces in mce_amd_inj:
> mce_amd_inj triggers a #MC on the cpu number that the user specifies on
> debugfs.
> For any error other than MC4 errors, this is fine.
> But we should really be triggering #MC only on NBC for MC4 errors.

Why?

As you said yourself, the errors get reported on the NBC. Where they get
*triggered* is a different story.

We do injection as it is described in "2.15.2 Error Injection and
Simulation" in F15h BKDG, for example. Reporting of the thusly injected
bank4 error goes to the NBC.

I don't see the need to fix anything in the code as it is.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
