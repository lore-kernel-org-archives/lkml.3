Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaKUVfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:35:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37250 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaKUVfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:35:50 -0500
Date: Fri, 21 Nov 2014 22:35:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: rui wang <ruiv.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Message-ID: <20141121213547.GF4274@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
 <20141121164140.GA4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
 <20141121181334.GC4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329504FD@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F329504FD@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:31:56PM +0000, Luck, Tony wrote:
> >
> >        /*
> >         * No machine check event found. Must be some external
> >         * source or one CPU is hung. Panic.
> >         */
> >        if (global_worst <= MCE_KEEP_SEVERITY && mca_cfg.tolerant < 3)
> >                mce_panic("Machine check from unknown source", NULL, NULL);
> >
> > Provided this comment is correct, it doesn't sound like any MCE record
> > will ever tell us what causes the error as an external source or a hung
> > CPU doesn't generate an MCE record in any bank, does it?
> 
> That means there were no VALID=1, EN=1, S=1 errors anywhere.  But there
> might be some other things logged that would help us understand.

By "other things" you mean other MCEs?

> We are into cpu errata territory here though ... we aren't supposed to get
> machine checks that don't have a logged cause.  We panic for spurious
> machine checks because we know something has gone horribly wrong,
> even if we don't know what that something was.

Oh, cpu errata. So this would mean that we can't even rely on the
contents of the MCA banks, can we?

In any case, is any of the information in the MCA banks in such cases
even usable then? Because if not, we're definitely barking up the wrong
tree...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
