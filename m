Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaIVSk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:40:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45032 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbaIVSky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:40:54 -0400
Date: Mon, 22 Sep 2014 20:40:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140922184049.GB4709@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 05:06:27PM +0000, Rustad, Mark D wrote:
> The problem is that the kernel include files throw so many warnings
> that it really discourages anyone from ever going through them, even
> for a single driver. The warnings are far more valuable and usable
> when known acceptable usages are silenced.

You can always do one file only, for example:

make W=2 arch/x86/kernel/msr.o > w.log 2>&1

> Well, the whole series of patches that I made definitely went too far
> - only the first 5 out of about 30 have been posted, but if we can
> make some progress on generating fewer warnings out of the include
> files, I think it would be helpful.

Helpful for what? Those are W=2 warnings which are disabled in the
default build.

> Already the patches that use them have triggered some activity that
> has resulted in resolving warnings without use of the macros, and I
> see that as much better than simply using the macros.
>
> The macros can serve a useful purpose, but they should not be widely
> used. When to use them is definitely a judgement call. If the macros
> are accepted, it may be worth adding a checkpatch.pl warning for
> adding a DIAG_*IGNORE macro.

Right, so add the macros and tell people *not* to use them. That won't
fly.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
