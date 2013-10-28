Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3J1K5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:57:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50573 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab3J1K5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:57:34 -0400
Date: Mon, 28 Oct 2013 11:57:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028105731.GF4314@pd.tnic>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028103428.GA2278@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131028103428.GA2278@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:34:28AM +0100, Andreas Werner wrote:
> Yes the reads are only for packet data, the commands or configuration
> registers are mapped non cachable.
> 
> I´ve tried WB, but on PCIe Tracer i could not see any burst access.
> Thats the reason why i have created this patch.
> 
> Is there a chance to get this patch into the kernel? Or
> is this solution so special?

Ok, but your patch returns WB pat type for WT MTRR type, AFAICT.

You want to do:

  PAT=Write-Back + MTRR=Write-Through = Effective Memory of Write-Through

but you end up doing

  PAT=Write-Back + MTRR=Write-Through = Effective Memory of Write-Back

What am I missing or misunderstanding?

AFAICT, you want to return _PAGE_PWT for MTRR_TYPE_WRTHROUGH, no?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
