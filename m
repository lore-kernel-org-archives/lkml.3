Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3J1Lpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:45:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33428 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab3J1Lpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:45:44 -0400
Date: Mon, 28 Oct 2013 12:45:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028114541.GI4314@pd.tnic>
References: <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028103428.GA2278@thinkpad.fritz.box>
 <20131028105731.GF4314@pd.tnic>
 <20131028112505.GD2278@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131028112505.GD2278@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop Dave's stale mail address.

On Mon, Oct 28, 2013 at 12:25:05PM +0100, Andreas Werner wrote:
> > but you end up doing
> > 
> >   PAT=Write-Back + MTRR=Write-Through = Effective Memory of Write-Back
> >
> No the effective memory type is WT, check out the Intel document with the
> table of Effective memory type combinations.

You need to read what I'm saying more carefully.

> Yes but, there is no way in the kernel to mark a memory WT,

That doesn't mean you can return _PAGE_CACHE_WB for MTRR_TYPE_WRTHROUGH.
The correct thing to do, IMHO, would be to set the PWT bit in the PTEs
of those pages comprising your buffer.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
