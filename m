Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaHTS54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:57:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46350 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaHTS5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:57:54 -0400
Date: Wed, 20 Aug 2014 20:57:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adam Duskett <aduskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: amd_mce.c redundant if check?
Message-ID: <20140820185755.GB18684@nazgul.tnic>
References: <CAFSsvmrZ3adzO_eNTc_ZWB3QGpfjPybj6O=x1-=a9=02pSG2qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFSsvmrZ3adzO_eNTc_ZWB3QGpfjPybj6O=x1-=a9=02pSG2qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 11:18:21AM -0600, Adam Duskett wrote:
> I have recently come upon this section of code in
> arch/x86/kernel/cpu/mcheck/mce_amd.c that seems to be a redundant
> unnecessary if check.
> 
> 
> From line 170 - 176:
> 
> if (tr->set_lvt_off) {
> if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
> /* set new lvt offset */
> hi &= ~MASK_LVTOFF_HI;
> hi |= tr->lvt_off << 20;
> }
> }
> 
> 
> This seems like it's not actually doing anything because it's setting
> the same value that the bit-field already has to itself.

Are you sure?

Just try to find out what MASK_LVTOFF_HI is and then do the operations
with a pen and paper to check whether something else actually happens.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
