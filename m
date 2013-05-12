Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3ELOrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:47:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44534 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab3ELOrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:47:12 -0400
Date: Sun, 12 May 2013 16:47:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "naveen.n.rao@in.ibm.com" <naveen.n.rao@in.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] MCE, APEI: Don't enable CMCI when Firmware First mode is
 set in HEST for corrected machine checks
Message-ID: <20130512144708.GA5589@pd.tnic>
References: <1367881102.4518.68.camel@oc3432500282.ibm.com>
 <20130506232537.GF22041@pd.tnic>
 <1367897566.4518.83.camel@oc3432500282.ibm.com>
 <20130507131946.GC7633@pd.tnic>
 <1367941214.4518.90.camel@oc3432500282.ibm.com>
 <20130508212237.GI30955@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA47E5E@ORSMSX101.amr.corp.intel.com>
 <20130508221501.GK30955@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA47F03@ORSMSX101.amr.corp.intel.com>
 <1368208744.4518.182.camel@oc3432500282.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368208744.4518.182.camel@oc3432500282.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And I was wondering why this is not reaching lkml. Fixed.

On Fri, May 10, 2013 at 10:59:04AM -0700, Max Asbock wrote:
> I'll try to summarize the situation:
> 
> We proposed two iterations of a patch that would parse HEST for a
> Corrected Machine Check entry and cause CMCI to be disabled if the
> Firmware First flag was found to be on in that entry.
> Several shortcomings of this approach were subsequently pointed out:
> a) Disabling CMCI doesn't go far enough. If the firmware wants to
> control corrected machine checks then we shouldn't even be polling the
> MCi_STATUS registers. Therefore we need to disable CMCI and disable
> polling if FF is set.
> 
> b) The firmware may take over only a subset of the possible corrected
> machine check events. If we turn off CMCI (and polling) for all banks we
> may miss out on some types of errors. Therefore we should not
> indiscriminately disable CMCI on all banks.
> 
> The question arose whether the APEI spec allows to specify individual
> machine check banks which fall under FF control. The answer appears to
> be 'possibly'. The Corrected Machine Check (CMC) structure defined in
> the APEI spec allows for a list of Machine Check Bank structures which
> could be used to designate a set of banks falling under FF control.
> However, the spec is silent on how the list of Machine Check Bank
> structures in the CMC structure is be used. 
> 
> Further steps in this endeavor may depend on the interpretation of the
> CMC structure in APEI an whether we can specify individual machine check
> banks that fall under FF control.

Right, so we need a complete solution where all FF banks are excluded
from polling. The question is, does the CMC table in APEI enumerate
*all* FF banks or we need to parse something else too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
