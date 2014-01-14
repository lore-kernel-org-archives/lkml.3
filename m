Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaANUi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:38:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49819 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaANUiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:38:54 -0500
Date: Tue, 14 Jan 2014 21:38:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140114203848.GP29865@pd.tnic>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <52D59ACC.3090100@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D59ACC.3090100@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:15:08PM -0600, Aravind Gopalakrishnan wrote:
> Scrubbing the RevGuide for Fam16, I found couple more Errata that need
> workarounds:

Before you go and do that, just ask internally whether those workarounds
are being delivered with AGESA instead. We don't want to have a fix in
the kernel for *every* erratum if it can be helped.

We're making an exception for this one because it can freeze the core
just by executing a locked insn which can be done even in userspace.

> @Boris: Could you please create a branch at bp.git with your patch so
> I can base my work on top of it?

For future AMD patches, make sure to almost always use tip master, i.e.

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git#master

to base your work off of.

> Also, I tested this patch against linux.git on a fam16 based machine
> and it works fine.

Thanks, much appreciated. I'll add your Tested-by.

> (I wasn't sure if you had access to a fam16 based box)

Yeah, I don't. So I'm relying on you for future patches :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
