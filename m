Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaIVPeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:34:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57474 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbaIVPeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:34:01 -0400
Date: Mon, 22 Sep 2014 17:33:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: sparse@chrisli.org, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rustad <mark.d.rustad@intel.com>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140922153355.GB4510@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 08:29:33AM -0700, Jeff Kirsher wrote:
> The following patches silence over 100,000 warnings in a W=2
> kernel build. This series does most of it by using the compilers
> diagnostic controls. The first patch in the series adds macros to
> invoke the pragmas for those controls. Macros are provided for GCC
> and clang. Although they are highly compatible in this area, macros
> are provided for compiler-specific controls, and there is one
> example that uses a clang-specific control (look for DIAG_CLANG_IGNORE).
> 
> Some missing-field-initializers warnings were resolved using
> the diagnostic control macros simply because so many lines
> would have had to have been changed. At this stage Mark thought 
> about avoiding possible merge issues. If the maintainer would 
> rather resolve them by using designated initialization, just 
> say so.
> 
> The combined effect of this patch series and his other patches
> that did not use these diagnostic control macros was to reduce 
> the number of W=2 warnings from 127,164 to 1,345!

Sorry but I don't see the point of actively adding macros to the code
just so that gcc is happy. There's a reason why a bunch of warnings are
disabled in the normal build and only enabled with the W= switch.

The W= things are supposed to be used when developing code and have the
compiler tell you about *possible* issues. That doesn't mean though that
we have to actively "fix" otherwise perfectly fine code.

Having the need to actively go in and add code so that gcc doesn't issue
obscure warnings is going too far, IMO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
