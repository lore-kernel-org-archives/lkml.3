Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3CEOVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:21:19 -0500
Received: from exprod6og119.obsmtp.com ([64.18.1.234]:57367 "EHLO
	exprod6og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3CEOVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:21:16 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 09:21:11 EST
Message-ID: <5135FF50.4020001@verisign.com>
Date: Tue, 05 Mar 2013 09:21:04 -0500
From: David C Niemi <dniemi@verisign.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>
CC: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] cpufreq: conservative: Fix sampling_down_factor
 functionality
References: <51351CC3.4010301@semaphore.gr> <CAOh2x=m0KLbjGKvLvTH7-yQb4SU5-v=-r4Ba3LSZz=NvfvO6mg@mail.gmail.com> <51358117.9060902@semaphore.gr> <5135FD01.8060306@verisign.com>
In-Reply-To: <5135FD01.8060306@verisign.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 14:21:03.0725 (UTC) FILETIME=[AB2D11D0:01CE19AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I should clarify -- I wrote the sampling_down_factor in the *ondemand* governor.  I chose the name of the parameter based on the vaguely similar parameter in the conservative governor, but the documentation that was referenced (about it only applying at top speed and the comment about skipping evaluation opportunities when it is active) was written by me in reference to the ondemand governor.  It could be that someone backported some of the ondemand sampling_down_factor's behavior to the conservative governor.

I'd like to ask -- what is the intended use of the conservative governor these days as differentiated from the ondemand governor?  At one time it seemed more oriented towards power savings, but the ondemand governor had picked up most or all of its power-saving features.

DCN

On 03/05/13 09:11, David C Niemi wrote:
> I am the author of sampling_down_factor.  I only intended it to have an effect if you are already attempting to achieve maximum performance (e.g. at the top available clock speed for the current infrastructure).  This is special because there is no possibility of going any faster so the only speed change you can think about is slowing down, which is typically much less urgent than speeding up.  So I did not see sampling_down_factor as being relevant at intermediate frequencies, though perhaps there could be something interesting but opposite to do at the minimum-power state too.
>
> In the applications this was originally intended for you were likely to either be idle and trying to save power (but be ready to ramp up quickly), or at max speed, and rarely in between.  sampling_down_factor made a dramatic improvement in performance, to the point there was no longer any reason to use the "performance" governor.
>
> I suspect the rationale for sampling_down_factor would apply to non-frequency-based governor/driver combos as well, like the p-state driver, though in that case you are not necessarily changing a literal clock speed and you also have additional opportunities like turbo/boost states to consider.  But in some applications, you may not want to use boost states that cannot be sustained when all cores are active, so there is more user/operator intent that must be communicated to the governor.
>
> DCN

