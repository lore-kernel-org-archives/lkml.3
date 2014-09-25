Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaIYI1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:27:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49776 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaIYI1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:27:08 -0400
Date: Thu, 25 Sep 2014 10:27:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140925082701.GC22317@nazgul.tnic>
References: <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
 <20140923082209.GB22072@pd.tnic>
 <029E2CFB-C001-4E16-B1F7-A3FB193E3138@intel.com>
 <20140923184456.GA16467@pd.tnic>
 <E460C326-08DC-4E38-8E3B-9050F9E03A17@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E460C326-08DC-4E38-8E3B-9050F9E03A17@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:43:17PM +0000, Rustad, Mark D wrote:
> Well, please consider the specifics. The entire syscall table is initialized
> with a constant pattern to be sure that every item is initialized. Then each
> syscall is initialized into its proper place. The compiler is complaining that
> entries are being initialized twice.
> 
> Most of the time, that is not done, and so it may catch a patch foulup or
> something. In this particular case, it is normal and intended. There is
> nothing wrong, so there is no reason to throw a warning for every single
> entry in the table. Which is what happens with clang today.
> 
> So the code is correct, but in general the warning can reveal certain issues.
> Just not in this particular usage. This happens to be a warning specific to
> clang at the moment.

Well, I read this as clang is wrong. It looks like the compiler is
unable to understand a perfectly valid usage so it throws a warning. If
we go and fix it in the kernel, we'll be wagging the dog, so to speak.
Which is a no-no obviously.

> That is why it would be more than reasonable for checkpatch to warn on the
> macro introductions. It is certainly a more significant thing than a
> line > 80 characters.

No sorry - I don't agree here. So now you're proposing of adding the
macros *and* checkpatch to warn about them. That's a really wrong thing
to do on so many levels.

...

> Most of the time, it is new instances of warnings that are most likely to
> reveal a problem. Hiding them in a flood of "normal" warnings prevents
> them from ever being seen. And that is a shame.

Sorry, I can only suggest grepping here and also using what Geert
suggested. There's simply no justification IMO to add code to the kernel
for solely silencing warnings.

-- 
Regards/Gruss,
    Boris.
--
