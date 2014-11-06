Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaKFS4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:56:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40093 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaKFS4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:56:41 -0500
Date: Thu, 6 Nov 2014 19:56:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Yucong <slaoub@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Message-ID: <20141106185638.GH4318@pd.tnic>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
 <20141106153539.GC4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329240AE@ORSMSX114.amr.corp.intel.com>
 <20141106182206.GG4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3292433C@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292433C@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 06:32:37PM +0000, Luck, Tony wrote:
> > Basically, this check is being done only for machine check exceptions
> > only.
> 
> But you proposed setting excp by looking at mcg_status:
> > excp = ((m->mcg_status & MCG_STATUS_MCIP) ? EXCP_CONTEXT : NO_EXCP);
> 
> Which makes the code rather self referential.  If we actually did arrive in MCE handler
> with MCIP == 0 ... then your code would pretend that we'd arrived here from the
> poll code, and skip over the test for MCIP - so fail to report that MCIP wasn't set.

Is that ever possible - to have a discrepancy between the setting of
MCIP and where we call mce_severity()?

I'm under the assumption that at all times, when we get a MCE, MCIP will
be set. For example, mce_gather_info() reads MCG_STATUS before we call
mce_severity() in do_machine_check().

Or am I missing something?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
