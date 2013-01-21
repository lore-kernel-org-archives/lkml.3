Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3AUNi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:38:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3AUNi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:38:56 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=247Zj1P6LJsA:10 a=5PTCx8dfAAAA:8 a=FXmwvOYqAAAA:8 a=VwQbUJbxAAAA:8 a=APyfCkKfvD8oLf_qK-UA:9 a=PUjeQqilurYA:10 a=jyh3A23puWoA:10 a=QmGog7O91dkA:10 a=1JvJEtVdGvUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358775534.21576.8.camel@gandalf.local.home>
Subject: Re: IPsec AH use of ahash
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: David Dillow <dave@thedillows.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 21 Jan 2013 08:38:54 -0500
In-Reply-To: <207592188.94267.1358763627877.JavaMail.root@elliptictech.com>
References: <207592188.94267.1358763627877.JavaMail.root@elliptictech.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 05:20 -0500, Tom St Denis wrote:
> 
> ----- Original Message -----
> > From: "David Dillow" <dave@thedillows.org>
> > To: "Tom St Denis" <tstdenis@elliptictech.com>
> > Cc: "Borislav Petkov" <bp@alien8.de>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, "Steven Rostedt"
> > <rostedt@goodmis.org>
> > Sent: Monday, 21 January, 2013 4:18:01 AM
> > Subject: Re: IPsec AH use of ahash
> > 
> > On Sun, 2013-01-20 at 19:40 -0500, Tom St Denis wrote:
> > > The problem is for me to add the ()'s is a no brainer.
> > 
> > It was more than just the ()'s. You completely botched the
> > indentation
> > in the parts of code you didn't copy from xcbc.c, among other issues.
> 
> Leaving coding indentation aside [I assume you mean the use of braces because my tab stops should match given the patchset for the other files was minimal] that's not really a good use of time here.

But it's a good use of David Miller's time?

$ git log v3.6..v3.7 |grep 'Signed-off-by: David.*Miller' | wc -l
679

$ git log v3.6..v3.7 |grep 'Author: David.*Miller' | wc -l
136

David handled 679 patches, where 136 of them were his. This is between
3.6 and 3.7 which is a 3 month period. He handled 543 patches that were
not his. Imagine if he had to fix up coding styles for every one of
those patches. That would make any sane man quit their job.

I'm curious, how many patches do you handle for your OSS projects over a
3 month period?

>  
> > > For me to re-write complete statements for coding style reasons
> > > means
> > > I have to actually go out and test it again.
> > 
> > Well, for some of the code you submitted, that would be the first
> > testing it got, even compile testing AFAICT. I don't doubt that you
> > tested against your hardware, but it is obvious that you didn't run
> > the
> > algorithm tests you added, or even tried to compile them. You were
> > missing a semicolon after your test data, and you were also missing a
> > "\x" in there, so your test data was wrong.
> 
> The missing semi-colon is in fact missing and for that I apologize.  This btw is the first legitimate gripe with the code thus far.

I've also found that those that have poor coding styles also have more
of these "legitimate" problems too. Which is another reason not to
accept patches with coding style issues.

> 
> Though I must say this code has "compiled" in 3.6, 3.6.7, 3.7, and 3.8 without error so it's not surprising it wasn't caught.  After having consulted the "documentation" I never really did figure out how to get testmgr to run so I took a bit of leap of faith there that everything was fine.  Not really an excuse but it is at least an observable hole in the build documentation.

Did you try different configs? Before submitting my code, I run under 8
different configs. SMP, non-SMP, PREEMPT, non PREEMPT, etc. also I run a
few random configs before submitting.

> 
> I couldn't spot the missing \x but I don't doubt you.  That format for vector data is so backwards that it's easy to make that mistake.  After having worked on crypto code for 10+ years I've never seen anyone use that format and I've seen stupid formats before (NIST CAVP anyone?).
> 
> Again all valid critiques of the code and valid reasons to do a re-spin.  I apologize for the oversight there.  Having "used the source" I found the build symbol required to activate the test manager so I should be good to go now.

Until you can play by the rules, don't bother playing. Feel free to dump
code on LKML. Maybe someone that knows how to play the game will take
it. But leave your gripes to your managers. No one here, but you, thinks
there's a problem with the frame work.

> 
> > I know this, because I just spent the five minutes required to fix up
> > the checkpatch warnings to prove to myself that you could have done
> > it
> > faster than sending one considered message to the list about how much
> > we
> > suck. Of course, that assumes you are trying to have a discussion
> > instead of trolling; it's much easier to spew bile than to think
> > before
> > you post.
> 
> This wasn't about how you all suck.  Quite the contrary it was about how good people are missing perspective.  You all started this by harping on the coding style "problems" but as a new developer to the kernel (well at least a new submitter...) I used the source as a guide so that I wouldn't deviate from what I perceived as the norm.  I was legitimately frustrated because performing a re-spin solely to work past coding style problems is not something a business case could be made for.  I'd like to contribute properly but at the same time you can't throw red flags on the play each time someone plays the game like you do.

> At least the testmgr errors are something I can work on whenever without setting up a lab so likely that'll be something I can tackle today actually.

While you're at it. You could spend an extra 5 minutes cleaning up the
coding style ;-)

-- Steve


