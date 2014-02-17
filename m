Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaBQTmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:42:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50177 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbaBQTl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:41:56 -0500
Date: Mon, 17 Feb 2014 20:41:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
Message-ID: <20140217194153.GG4559@pd.tnic>
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140217182729.GE4559@pd.tnic>
 <5302625C.4050700@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5302625C.4050700@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:26:20PM -0600, Aravind Gopalakrishnan wrote:
> >  	if (c->x86_vendor != X86_VENDOR_AMD)
> >-		return 0;
> >+		return -ENODEV;
> >  	if (c->x86 < 0xf || c->x86 > 0x16)
> >-		return 0;
> >+		return -ENODEV;
> Ah. you are right. (I had tested against different family/model
> checks that happen to throw NULL dereference)
> You can ignore the patch.
> 
> Apologies for the trouble.

But we still need a fix, I guess the one I sent you does the job, yes,
no?

If not, I'd need more background info though - you're loading this on an
unsupported family, right?

If so, we need to fix the family check at the beginning:

	if (c->x86 < 0xf || c->x86 > 0x16)

maybe even look at c->x86_model if we have to.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
