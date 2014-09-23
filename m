Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaIWIWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:22:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43402 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaIWIWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:22:16 -0400
Date: Tue, 23 Sep 2014 10:22:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140923082209.GB22072@pd.tnic>
References: <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:50:54PM +0000, Rustad, Mark D wrote:
> On Sep 22, 2014, at 1:33 PM, Borislav Petkov <bp@alien8.de> wrote:
> 
> > Btw, out of curiosity, what is your use case for staring at those W=2
> > warnings?
> 
> I know no one cares about out-of-tree drivers, but I have a hack that

Yah :-)

> allows building out-of-tree drivers without getting warnings from the
> kernel includes. We do an automated compile of every patch with W=12
> and expect clean compiles.
> 
> It would be nice to compile drivers in-tree and have a similar expectation.
> I guess a similar hack could be developed, but since we are contributing
> upstream, I would rather uncover any potential issues that may exist, even
> if they aren't in the driver. The hack would tend to cover up such issues.
> This is definitely NOT about covering up things that could be problems!

Yeah, as I said in the other mail to Jeff, I think there are a couple of
things to be pointed out:

* Fixing those is a good idea if the fixes are clean - I think we all
agree by now that adding code just to shut up gcc is not nice.

* Then, even if all those warnings were fixed one fine day, the people
who fix them would be fighting windmills because every new patch which
adds new places causing those warnings would simply go in because the
warnings are not visible in default builds.

So the question IMO turns into: are there some warnings which we should
promote to default builds so that they get taken care of eventually...

> Well, I have W=1 in my environment, so I don't even have to ask for it, I
> just get it.

I think this was the initial use case we had in mind for W= - use it
during development in order to have the compiler do extra checks to your
code. And it has caught a couple of issues, FWIW.

> W=12 is just insane, or I would use that all the time. I think it
> would be nice for new code, or at least new drivers, to compile clean
> with W=12, but that isn't possible when the kernel includes throw so
> many warnings.

Right, see above.

> Nested-externs, for example, can catch people gratuitously providing a
> function prototype that could become a hazard, but some use of that may
> be justified. The macros provide a way to specifically allow certain
> instances while generally discouraging it. Of course if you never use
> W=2 you may never catch those gratuitous declarations.

Sure, but the cost for fixing that is what bothers me. For that
particular case, it probably would even be cleaner to add a
nested-extern check to checkpatch instead of cluttering the code with
those macros.

> Hopefully the discussion is somewhat useful.

Well, it has become already, as you can see. :-D

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
