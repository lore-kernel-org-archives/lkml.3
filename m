Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab3BOCKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:10:23 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:36313 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab3BOCKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:10:08 -0500
Date: Thu, 14 Feb 2013 18:09:57 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <20130215011503.GA11914@redhat.com>
Message-ID: <alpine.LNX.2.00.1302141804400.3330@eggly.anvils>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils> <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils> <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013, Dave Jones wrote:
> On Wed, Feb 13, 2013 at 11:56:25AM -0800, Linus Torvalds wrote:
>  > On Wed, Feb 13, 2013 at 11:34 AM, Dave Jones <davej@redhat.com> wrote:
>  > >
>  > > My test was a loop of 100 suspend/resume cycles before calling something
>  > > 'good'. The 'bad' cases all failed within 10 cycles (usually 2-3).
>  > 
>  > Considering that you apparently already found one case where the BIOS
>  > crapped out due to effectively unrelated timing details (ie timing
>  > triggered a temperature issue that then triggered behavioral changes),
>  > I wonder if your more occasional problem might not be a sign of
>  > something similar.
>  > 
>  > But since you seem to be able to automate it well, maybe one thing to
>  > try is to change the timing a bit while testing. Maybe some failures
>  > were hidden by the timing just happening to work out.
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
> info might be getting spewed.  Perhaps when I reinstall, and switch to booting EFI
> I'll be able to use pstore, but on a bios-based boot, all hope seems lost.
> No netconsole, no usb-serial, even crippling i915's suspend routine doesn't help.
> 
> I'll just disable this option for now.

Which won't affect my case since I never enabled it.

Hugh
