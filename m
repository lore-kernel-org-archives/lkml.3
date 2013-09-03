Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab3ICNdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:33:04 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37467 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab3ICNdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:33:00 -0400
Message-ID: <5225E508.2060407@linaro.org>
Date: Tue, 03 Sep 2013 15:32:56 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Suresh.Srinivasan@arm.com, Amit Kucheria <amit.kucheria@linaro.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [Query-CPUIdle]: Not much activity in C0 state
References: <CAKohpo=OuYK7vhoG6a4REd-XuGMP63NTKhd8TWJmKo1R6rDp7g@mail.gmail.com>
In-Reply-To: <CAKohpo=OuYK7vhoG6a4REd-XuGMP63NTKhd8TWJmKo1R6rDp7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 12:23 PM, Viresh Kumar wrote:
> Hi Guys,
> 
> I was trying to run following on my thinkpad:
> 
> watch -n1 cat /sys/devices/system/cpu/cpu*/cpuidle/state*/usage
> 
> I can see lots of activities on State 1-4, but not much on state 0..
> I thought we should enter this state as soon as we come out to
> non-idle state.. And so this count must be changing quite rapidly.
> 
> Is this a bug?

Hi Viresh,

the menu governor tries always to stick to C1 (state1) as default state,
look at the menu_select function. The state0 (not C0 but 'poll') will
happen when the next timer event is less than 5us, this occurs rarely.
You can easily spot it by doing while $(true); usleep 2; done

The poll state is x86 specific where the cpu detects the 'rep nop'
instructions to do some power saving.

Hope that helps

  -- Daniel



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

