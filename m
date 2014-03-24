Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaCXKPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:15:37 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:60261 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaCXKPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:15:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140324110032.7aeae15e@amdc2363>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
	<1393928852-22725-1-git-send-email-l.majewski@samsung.com>
	<CAKohpok1zBsX7n70r=geCOaP-9ONx2QdaUMK6cJeqhFrO1PkUg@mail.gmail.com>
	<20140324110032.7aeae15e@amdc2363>
Date: Mon, 24 Mar 2014 15:45:34 +0530
Message-ID: <CAKohpo=6F_d3WF6TuNODDhhig5oDjC2dhAjqXp4E+c6VJyCiFw@mail.gmail.com>
Subject: Re: [RFC v3 0/5] cpufreq:LAB: Support for LAB governor.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Linaro lists in cc as there are few people here working on power/thermal
stuff.]

On 24 March 2014 15:30, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> On 4 March 2014 15:57, Lukasz Majewski <l.majewski@samsung.com> wrote:

> I think, that "LAB" name is with us for some time, so it would be a
> pity to discard it.

It doesn't matter with Mainline how you do naming initially for your code :)
We need to pick the right name now, and the decision should be made
now (after discussions obviously) :)

>> What about making it as simple as:
>> - changing the ondemand governor only instead of adding a new governor
>
> My goal is to not touch the ondemand code. It has matured, so I would
> like to leave it as it is.

Because the boost feature is already part of CPUFreq core, I think its
better if we enhance current governors to use it. So, I would like to
make this part of existing governors. Not only ondemand but maybe
conservative as well..

Also, I feel we maynot necessarily move this piece of code into cpufreq.
All you are doing is thermal management here :)

If we are sure we will not burn out our SoC (When many cores are idle),
run at max freq (if there is enough load of course :))..

And if there are chances that we might burn our chip (when very few
cores are idle), don't run on boost frequencies..

This is actually a 'cooling' device :)

Think of it this way: CPUFreq will provide a range of frequency which
SoC's can use. And then based on some conditions we may or may not
want to run on these frequencies.

@Zhang/Eduardo: Can we have your inputs here as well ?

This may look hard but we need to design things in the best possible
way for managing things better in future. Lets see what others have
to say on this.
