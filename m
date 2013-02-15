Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab3BOCKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:10:08 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47534 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BOCKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:10:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130215011503.GA11914@redhat.com>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Feb 2013 18:09:44 -0800
X-Google-Sender-Auth: hOoxFOxieW0PX7Os943fhIUdmTc
Message-ID: <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 5:15 PM, Dave Jones <davej@redhat.com> wrote:
>
> Given I never saw this on a Fedora kernel, just my self-built ones, I eventually
> gave up on bisecting code, and switched to bisecting config options.
> I should have started this way, as I figured it out within an hour.
>
> 3.7 merge window is when I started seeing this, and here's what got introduced
> during that time..
>
> commit e3ebfb96f396731ca2d0b108785d5da31b53ab00
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Mon Jul 2 14:42:01 2012 -0700
>
>     rcu: Add PROVE_RCU_DELAY to provoke difficult races
>
> 'difficult' is an understatement.  This explains why some of those 'good'
> bisects survived 100 suspends on one day, and failed the next.
>
> Unfortunatly, I don't think there's any sane way to retrieve whatever debug
> info might be getting spewed.

Hmm. I have to say, that's a particularly unhelpful config option. It
may make races much easier to hit, but when you do hit them, what's
the symptoms of said race?

Paul? Apparently you end up with a dead machine at least during resume
and no oops. Which isn't very helpful. Maybe there is possibly some
BUG_ON() in the RCU code somewhere?

So Paul, if you know what the common symptoms of the bug that that
debug option helps trigger are, is there some way to make them less
lethal and still print out useful information?

                   Linus
