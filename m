Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaKWUzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 15:55:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34434 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaKWUza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:55:30 -0500
Date: Sun, 23 Nov 2014 21:55:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: rui wang <ruiv.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Message-ID: <20141123205527.GB7355@pd.tnic>
References: <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
 <20141121164140.GA4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
 <20141121181334.GC4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329504FD@ORSMSX114.amr.corp.intel.com>
 <20141121213547.GF4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F32950618@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32950618@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:59:49PM +0000, Luck, Tony wrote:
> > Oh, cpu errata. So this would mean that we can't even rely on the
> > contents of the MCA banks, can we?
> >
> > In any case, is any of the information in the MCA banks in such cases
> > even usable then? Because if not, we're definitely barking up the wrong
> > tree...
> 
> See above - I think even if there is a bug in the core that isn't setting the
> right bits in the MCi_STATUS register - we could get good data from
> devices out in the uncore.

Btw, since we're talking about errata - I guess you could use X86_BUG
and static_cpu_has_bug* to query in do_machine_check and modify logging
behavior of mce_log to bypass mce_severity and put all errors of the
last round in mce_log and then dump them out at panic time.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
