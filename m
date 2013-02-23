Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab3BWAlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:41:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41795 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab3BWAls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:41:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, Dave Jones <davej@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, tianyu.lan@intel.com,
        Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Date: Sat, 23 Feb 2013 01:48:27 +0100
Message-ID: <1451742.5dFcotgqBW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFxcqczXZf7zxJ0xjDsnLMbS8uu9Jp5BDOdnR5tqf==nrA@mail.gmail.com>
References: <20130222085954.GA4352@redhat.com> <9798783.W2ijE8Yd31@vostro.rjw.lan> <CA+55aFxcqczXZf7zxJ0xjDsnLMbS8uu9Jp5BDOdnR5tqf==nrA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 04:30:25 PM Linus Torvalds wrote:
> On Fri, Feb 22, 2013 at 4:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > It won't revert, there's more stuff on top of it.  And it is a fix, so
> > reverting it is not really a good idea anyway.
> 
> Rafael, please don't *ever* write that crap again.
> 
> We revert stuff whether it "fixed" something else or not. The rule is
> "NO REGRESSIONS". It doesn't matter one whit if something "fixes"
> something else or not - if it breaks an old case, it gets reverted.
> 
> Seriously. Why do I even have to mention this? Why do I have to
> explain this to somebody pretty much *every* f*cking merge window?

Well, sorry.  I shouldn't have said that.

The problem is, though, that even if bisection turns up something, it doesn't
automatically mean that this particular commit is the one that caused the
problem to happen in the first place.

And in this particular case bisection turns up a commit that enables something
that didn't work on that particular machine for some time.  It used to work,
then it stopped working and that commit made it work again.  And the fact that
it made it work again caused something different to trigger the result of which
is the observed breakage.

I'm obviously going to fix it, because it is a serious problem, but the commit
in question is not the root cause of it in my opinion (as I wrote to Fabio in
another message).

> This is not a new rule.
> 
> And btw, the *reason* for that rule becoming such a hard rule was
> pretty much exactly suspend/resume and ACPI. Exactly because we used
> to have those infinite "let's fix one thing and break another" dances.
> So you should be well acquainted with the rule, and I'm surprised to
> hear that kind of utter garbage from you in particular.
> 
> There is no excuse for regressions, and "it is a fix" is actually the
> _least_ valid of all reasons.
> 
> A commit that causes a regression is - by definition - not a "fix". So
> please don't *ever* say something that stupid again.
> 
> Things that used to work are simply a million times more important
> than things that historically didn't work.
> 
> So this had better get fixed asap, and I need to feel like people are
> working on it. Otherwise we start reverting.
> 
> And no amount "but it's a fix" matters one whit. In fact, it just
> makes me feel like I need to start reverting early, because the
> maintainer doesn't seem to understand how serious a regression is.

OK, OK.

Please let me understand what the problem is first.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
