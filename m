Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3J1N6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:58:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59325 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab3J1N6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:58:51 -0400
Date: Mon, 28 Oct 2013 14:58:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028135847.GK4314@pd.tnic>
References: <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028103428.GA2278@thinkpad.fritz.box>
 <20131028105731.GF4314@pd.tnic>
 <20131028112505.GD2278@thinkpad.fritz.box>
 <20131028114541.GI4314@pd.tnic>
 <20131028120358.GE2278@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131028120358.GE2278@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 01:03:58PM +0100, Andreas Werner wrote:
> > That doesn't mean you can return _PAGE_CACHE_WB for MTRR_TYPE_WRTHROUGH.
> > The correct thing to do, IMHO, would be to set the PWT bit in the PTEs
> > of those pages comprising your buffer.
> > 
> But why? the combination of PAT=WB and MTRR=WT is allowed isn´t it?
> What should i return instead of?

Well, since the pat code can't give you PWT, I'm thinking the cleaner
thing would be to do it yourself. I.e., allocate a WT buffer with
mtrr_add and then set the PWT bit of each page in that buffer.

Alternatively, your solution - albeit not that correct - is a simple one
and probably could use a good comment in the code explaining why you're
doing that if we decide to go that way.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
