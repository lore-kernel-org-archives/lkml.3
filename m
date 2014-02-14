Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaBNJOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:14:14 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48404 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaBNJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:13:50 -0500
Date: Fri, 14 Feb 2014 09:13:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
Message-ID: <20140214091343.GE3403@lee--X1>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
 <20140213095817.GD32508@lee--X1>
 <20140213111530.2a2b4982@endymion.delvare>
 <CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
 <CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
 <20140213113313.GL32508@lee--X1>
 <CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
 <52FCEFEF.80707@roeck-us.net>
 <CAOMwXhPjHqAswA2MU22EuOWtN-86BQ9tCyKYjt1-SeLZGj6TQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhPjHqAswA2MU22EuOWtN-86BQ9tCyKYjt1-SeLZGj6TQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>>>>> -static int max6650_probe(struct i2c_client *client,
> >>>>>>>> -                    const struct i2c_device_id *id);
> >>>>>>>> -static int max6650_init_client(struct i2c_client *client);
> >>>>>>>> -static int max6650_remove(struct i2c_client *client);
> >>>>>>>> +static int max6650_probe(struct platform_device *pdev);
> >>>>>>>> +static int max6650_init_client(struct platform_device *pdev);
> >>>>>>>> +static int max6650_remove(struct platform_device *pdev);
> >>>>>>>>   static struct max6650_data *max6650_update_device(struct device
> >>>>>>>> *dev);
> >>>>>>>
> >>>>>>>
> >>>>>>> It would be good to remove these forward declarations in the future.
> >>>>>>>
> >>>>>>> If no one volunteers I'll happily do it.
> >>>>>>
> >>>>>>
> >>>>>> Guenter just did:
> >>>>>>
> >>>>>>
> >>>>>> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041224.html
> >>>>>>
> >>>>>> Any change to the max6650 driver should go on top of his patch series
> >>>>>> to avoid conflicts:
> >>>>>>
> >>>>>>
> >>>>>> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html
> >>>>>
> >>>>>
> >>>> As far as I can see, that patch set was not even tested, so how can it
> >>>> go in? I was told that any patch should be _runtime_ tested, too.
> >>>> Fwiw, I do not have time to test those personally, he would need to
> >>>> find someone else if that requirement really holds true.
> >>>>
> >>>> I would not really like to fix bugs appearing in that code to get my
> >>>> features in.
> >>>>
> >>>> Also, since my change has been around for 2-3 months now, I would
> >>>> really prefer not to be forced to rewrite it again from scratch.
> >>>> Surely, you can wait with those, more or less, cosmetic non-runtime
> >>>> tested changes?
> >>>>
> >>>> This would impose me a lot of additional work again, and I personally
> >>>> do not see the benefit of it. In my book at least, feature is over
> >>>> internal polishing.
> >>>
> >>>
> >>> Right, I've had enough. I'm removing your patch from the MFD tree.
> >>>
> >>> I've asked too many people to give you a second chance and asked you
> >>> privately to behave yourself and treat others with respect. So far I
> >>> haven't seen an ounce of self control or depomacy from you.
> >>>
> >>> This is how it's going to work from now on:
> >>>
> >>>   - You submit a patch
> >>>   - It gets reviewed                            <----\
> >>>   - You fix up the review comments as requested -----/
> >>>   - Non-compliance or arguments with the _experts_ results in:
> >>>      `$INTEREST > /dev/null || \
> >>>        grep "From: Laszio Papp" ~/.mail | xargs rm -rf`
> >>
> >>
> >> http://comments.gmane.org/gmane.linux.kernel/1645251
> >>
> >> Step 2 did not happen. I did not get any review for my change. I
> >> literally submitted that within a couple of hours after the request.
> >>
> >
> > If you had tested your patch on real or simulated hardware,
> > you might have noticed a crash whenever you accessed any
> > of the attributes. So you did not test your patch.
> >
> > Instead of trying to educate you how the conversion to the
> > new API works, I decided to help you out a bit and do
> > the conversion myself.
> 
> I am afraid that with this attitude and approach towards potential new
> contributors, you will put more and more work on you making it more
> difficult to get things done at large. "Educating" new people is a win
> in the long run, and this is a general practice out there before
> claiming that I am crazy (e.g. someone even told me in the kernel
> circles that is "rude").
> 
> I am surprised that mentoring new people is considered bad idea in
> here. Since there is no guarantee you would not do it next time if I
> tried to put effort into contributing, I feel more comfortable to skip
> this project for now, and work where I know this cannot happen.
> Currently, I do not feel inclusive in this project due to this
> approach.
> 
> I do not even claim that you would be this to me intentionally, but it
> has happened either way.

I agree that if Guenter was to go ahead and convert this driver to an
MFD one, then that would be rude conduct. However, the work undertaken
by him was 'add-on' work which you clearly weren't comfortable with. I
think he was genuinely doing you a favour rather than 'stealing your
thunder'. His work has paved the way for yours and should make your
work easier in the long run.

NB: Rebasing on top of different HEADs and other people's work is just
a fact of life in the kernel. If you find it difficult, stick
around. You'll get better at it with practice.

> > I did some cleanup before, since
> > that made the actual feature patch easier for me to implement,
> > and I did some more cleanup afterwards just because I like
> > cleaning up code.
> 
> IMO, it is not worth making the git history noisy with needless
> re-arranging like forward headers, but that is just my opinion. Please
> do not say, it is rude and not respectful. I definitely respect your
> opinion, I just do not agree with it, but that is fine, you are a
> maintainer so you get to decide, I guess. That being said, perhaps I
> missed something why such re-arranging outweighs the git history
> disadvantage.

=:-D

We have nearly half a million commits in the Mainline kernel since
v2.6.12. I don't think Git history is even a consideration here. Also,
we really don't like forward declarations in the kernel. Guenter's
clean-ups where good ones. We can't stop cleaning up and developing in
the fear that someone else is working on that same driver. We have
lots of people making changes to the same files all over the kernel.
Get good at `git rebase`ing and there is no issue, it's just another
day in the life of a Kernel Developer.

If you'd spend more time rebasing and coding as you do writing emails,
you'd have had this done by now. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
