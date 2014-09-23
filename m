Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaIWSpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:45:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47345 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbaIWSpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:45:04 -0400
Date: Tue, 23 Sep 2014 20:44:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140923184456.GA16467@pd.tnic>
References: <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
 <20140923082209.GB22072@pd.tnic>
 <029E2CFB-C001-4E16-B1F7-A3FB193E3138@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <029E2CFB-C001-4E16-B1F7-A3FB193E3138@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 05:24:22PM +0000, Rustad, Mark D wrote:
> Yes, but I think there are a few cases where it could be helpful. When
> there is something exceptional that will throw a warning. In one of the
> patches that Jeff sent, I used the DIAG_CLANG_IGNORE macro to suppress
> the warning that is thrown for every entry of the syscall table when
> compiled with clang. The code is right and doing exactly what is wanted,
> so note the exception and make it shut up.

So we're doing some dancing around solely to shut up the compiler? Even
if the code is correct?!? Sorry, this is just ass backwards.

> I would generally be in favor of that over time, but I recognize that with
> the range of architectures and toolchains that need to be supported, that
> may be difficult.

Right.

> Generally there should be relatively few exceptions that need to be tagged.
> If there were 1000, that would be way too many. The full series of my
> patches had 90 instances. Some of the few that have been sent have been
> resolved in better ways, which we all agree is better. Suppose that 40
> can't be reasonably resolved in direct ways. Is that really costly? I'm
> trying to understand what your perception of the cost is.

If it were me, I'd say even one is too much. Because the very thing
of adding code just to shut up the compiler which generates otherwise
correct code is simply very very wrong in my book.

Bear in mind that even if initially you have a low number of macro
invocations, that number will grow because people will start using it in
other places too. And all of a sudden, the thing has spread like weed
and there's no removing it anymore. So we better not start in the first
place.

> Perhaps checkpatch would be a better gatekeeper for new code. OTOH,
> some of those nested externs have already been eliminated, so at
> least for now the warning is serving a purpose since it is scrubbing
> existing code.

Yep, eliminating would be optimal. If it is in checkpatch, it is much
easier to manage.

> I take it as a given that the kernel sometimes has special needs
> and needs to do special things. The macros make it possible to mark
> those special usages. I prefer adding the macros in a few places to
> eliminating a warning altogether unless the warning is always useless.

Please, no compiler-shutting-up code, see above.

> I'm sure we agree that we don't want to ever turn on -pedantic! :-)

Again, we should take compiler warnings with a grain of salt and judge
them only by the quality of the generated code. IMO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
