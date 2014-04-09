Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbaDIUQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:16:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41813 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbaDIUQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:16:22 -0400
Date: Wed, 9 Apr 2014 22:16:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Baron <jbaron@akamai.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
Message-ID: <20140409201615.GS6529@pd.tnic>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140409113552.GJ6529@pd.tnic>
 <20140409133433.GJ29214@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
 <20140409173633.GN6529@pd.tnic>
 <5345980F.7070604@akamai.com>
 <20140409191454.GQ6529@pd.tnic>
 <5345A54D.2050808@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5345A54D.2050808@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 03:53:49PM -0400, Jason Baron wrote:
> Unfortunately, the box reporting the ue errors just went into transit (so
> that I can better examine this issue), so I will probably not be able to
> run this experiment on that specific box until next week.
> 
> However, I was able to run it on a very similar box (same pci id for the
> mch), and I get:
>  
> # ./rdmsr 0x179
> c09

1100_0000_1001
11   7    3

Hohumm, that's interesting: 9 MCE banks, there's *no* MCG_CTL register
present (bit 8) (that's why the read below fails) so you cannot turn on
or off the error reporting banks.

bit 10 says you have CMCI so you don't need the polling, you probably
don't even need the EDAC driver at all ... unless you want to report
which DRAM channel had the error (this is probably the only additional
information your drivers gives and which the info in mcelog won't give).

Which gives the next question: what exactly is this EDAC driver going
to be used for if it reports (row, channel, syndrome) and how are you
going to use that info? I'm looking at ie31200_process_error_info().

> # ./rdmsr 0x17b
> rdmsr: CPU 0 cannot read MSR 0x0000017b

In any case, that's some strange machine. If it is a desktop MCH, I can
understand it not raising MCEs but that would be pretty nasty, still.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
