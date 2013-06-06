Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3FFN30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:29:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35982 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3FFN3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:29:24 -0400
Date: Thu, 6 Jun 2013 15:29:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Message-ID: <20130606132908.GE20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-5-git-send-email-bp@alien8.de>
 <20130606131439.GI30420@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130606131439.GI30420@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 02:14:39PM +0100, Matt Fleming wrote:
> This patch makes my TunnelMountain machine spin in handle_pte_fault()
> when triggering one of the "firmware makes references to physical
> addresses" code paths.
>
> I'll try and dig into this tomorrow to figure out what's going on.

Hmmm, looks like we have forgotten to map an EFI region and we do a #PF
when executing the EFI code.

If so, I'm thinking we don't want to touch the #PF code and teach it
about EFI so maybe we should make sure we've mapped *everything* EFI
runtime would need before we switch PGDs...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
