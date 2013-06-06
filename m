Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3FFTgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:36:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48153 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3FFTg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:36:29 -0400
Date: Thu, 6 Jun 2013 21:36:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Message-ID: <20130606193612.GM20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-5-git-send-email-bp@alien8.de>
 <20130606131439.GI30420@console-pimps.org>
 <20130606132908.GE20972@pd.tnic>
 <20130606155822.GH20972@pd.tnic>
 <51B0E2D4.3040007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51B0E2D4.3040007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 12:28:20PM -0700, H. Peter Anvin wrote:
> Or we could materialize mappings for this specific PGD. However,
> adding a read of %cr3 in __do_page_fault sounds expensive.

Yes, I think we want to make sure all mappings are there when we do an
EFI runtime call so that we never #PF while it executes.

Matt mentioned on IRC that the it could be that his EFI runtime is
referencing EFI_RESERVED area which we don't map. However, we need to
confirm/disprove that first, as it is currently only a hunch.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
