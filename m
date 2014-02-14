Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaBNKRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:17:33 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40247 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNKRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:17:31 -0500
Date: Fri, 14 Feb 2014 10:17:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
Message-ID: <20140214101725.GC9462@lee--X1>
References: <20140213095817.GD32508@lee--X1>
 <20140213111530.2a2b4982@endymion.delvare>
 <CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
 <CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
 <20140213113313.GL32508@lee--X1>
 <CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
 <20140213124002.GA3403@lee--X1>
 <CAOMwXhPwppZ6Ne4TjR9Ys+ttST2r85j1GsLdxfq67svZSuVHFg@mail.gmail.com>
 <20140214090217.GD3403@lee--X1>
 <CAOMwXhNyF7L5mCnsL+nxcfYAJ9vjHmoSOenO8bkPikaNfJU86Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhNyF7L5mCnsL+nxcfYAJ9vjHmoSOenO8bkPikaNfJU86Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Laszlo Papp wrote:

> On Fri, Feb 14, 2014 at 9:02 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >> >> http://comments.gmane.org/gmane.linux.kernel/1645251
> >> >>
> >> >> Step 2 did not happen. I did not get any review for my change. I
> >> >> literally submitted that within a couple of hours after the request.
> >> >>
> >> >> Could you please tell me what was wrong with that change, and why I
> >> >> did not get any respect not to "xargs rm -rf" my work in that area? I
> >> >> believe I was ignored instead of improving the change, and someone
> >> >> else tried to address the same thing. There was no argument in that
> >> >> thread. It was a technical change. I personally do not feel happy
> >> >> about it.
> >> >
> >> > Let's start again.
> >> >
> >> > Rebase your work on top of the HWMON tree on kernel.org and resubmit
> >> > the entire set. If rebasing takes you more than 20 mins, you're
> >> > probably doing it wrong.
> >>
> >> I tried, but I could not manage it within 20 minutes, so I guess I am
> >> doing something wrong. Can you please provide some pointers how not to
> >> do it wrong? Perhaps, I am not aware of some tricks.
> >
> > One question, are you still working on this stuff or not? I'm confused
> > by the disparity in your messages. I'm going to guess that you're in
> > for now.
> >
> > Do:
> >   `git rebase -i <base> --onto <newbase>`
> > Where:
> >   <base> is the SHA1 of the first patch below your changes in `git log`
> >   <new_base> is Guenter's staging tree on kernel.org
> >
> > Ensure you're rebasing all of your patches (and patches that aren't
> > yours) when your $EDITOR pops up. If they are wrong, delete all the
> > lines in the file and the rebase will be aborted. If they're correct
> > save and close your $EDITOR.
> >
> > You'll receive conflicts. You can see the state of the conflicts using
> > `git status` Open the file, find the conflict markers and make a choice
> > from the HEAD section or the section from your patch. Sometimes
> > you'll need to manually merge the two, if there are changes from both
> > refs that you want to keep. Once you're happy `git commit -a` and `git
> > rebase --continue`. Each conflict should not take you long, but if it
> > does, keep at it, as it's good practice. After a time of doing it,
> > you'll be able to fix merge conflicts in no time at all.
> 
> Right, that is what I have been following myself for a couple of
> years.

> Why it took me more time because I had to go through his
> changes and to understand all in details to make reasonably good
> decisions what to keep and what to drop at the conflicts.

Correct, that's what will improve with time.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
