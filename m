Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3J1LZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:25:12 -0400
Received: from mout.gmx.net ([212.227.17.21]:54224 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab3J1LZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:25:10 -0400
Date: Mon, 28 Oct 2013 12:25:05 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028112505.GD2278@thinkpad.fritz.box>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028103428.GA2278@thinkpad.fritz.box>
 <20131028105731.GF4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131028105731.GF4314@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:O+6oCvh2Nr+ihVUD8DxcInN1X4+/UGX2lBOOjfdG5eCz4hHL+kA
 LL/H15D2W68CAHj/7+r2WVHElU+iPetpjEknXHAVty6QRYy5K10U/RZupZJ7zFDoem3Nch8
 K1gsR7lLN1aD81pY80NaYjSQr/W73RagQYpRn3Np7/dCxI6QGKwqDpcYziCAtnH41Mg1272
 OeqF7eGpEInYldKGXr6Bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:57:31AM +0100, Borislav Petkov wrote:
> On Mon, Oct 28, 2013 at 11:34:28AM +0100, Andreas Werner wrote:
> > Yes the reads are only for packet data, the commands or configuration
> > registers are mapped non cachable.
> > 
> > I´ve tried WB, but on PCIe Tracer i could not see any burst access.
> > Thats the reason why i have created this patch.
> > 
> > Is there a chance to get this patch into the kernel? Or
> > is this solution so special?
> 
> Ok, but your patch returns WB pat type for WT MTRR type, AFAICT.
> 
> You want to do:
> 
>   PAT=Write-Back + MTRR=Write-Through = Effective Memory of Write-Through
>
Yes thats right.
 
> but you end up doing
> 
>   PAT=Write-Back + MTRR=Write-Through = Effective Memory of Write-Back
>
No the effective memory type is WT, check out the Intel document with the
table of Effective memory type combinations.
 
> What am I missing or misunderstanding?
> 
> AFAICT, you want to return _PAGE_PWT for MTRR_TYPE_WRTHROUGH, no?

Yes but, there is no way in the kernel to mark a memory WT,
there is just ioremap_wc for Write combining and ioremap_cache
for Write Back, and as you can see in the Intel Effective Memory type
table, if you combine PAT=WB and MTRR=WT you will get a effective memory
of WT.

regards 
Andy
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
