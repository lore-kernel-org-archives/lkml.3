Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab3J1Kbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:31:36 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:46143 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3J1Kbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:31:35 -0400
Date: Mon, 28 Oct 2013 11:31:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andreas Werner <wernerandy@gmx.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028103132.GA6274@gmail.com>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028102938.GD4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028102938.GD4314@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Oct 28, 2013 at 11:17:49AM +0100, Ingo Molnar wrote:
>
> > And regular write-back cacheable isn't sufficient because the 
> > CPU could do things like prefetch your range automatically?
> 
> Yeah, he's doing a CLFLUSH anyway which basically makes it a 
> write-through...

The CLFLUSH is done afterwards (making it a use-once thing), so WB 
might still be faster and would avoid the PAT headache ...

Thanks,

	Ingo
