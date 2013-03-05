Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3CEUPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:15:18 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:53377 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756105Ab3CEUPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:15:12 -0500
Message-ID: <51365247.5030005@semaphore.gr>
Date: Tue, 05 Mar 2013 22:15:03 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] cpufreq: conservative: Fix sampling_down_factor
 functionality
References: <51351CC3.4010301@semaphore.gr> <CAOh2x=m0KLbjGKvLvTH7-yQb4SU5-v=-r4Ba3LSZz=NvfvO6mg@mail.gmail.com> <51358117.9060902@semaphore.gr> <CAKohpokvqe8860J=XO_GXqxpNtrt9XEuUeqCeR=A4PpSaAsHYg@mail.gmail.com>
In-Reply-To: <CAKohpokvqe8860J=XO_GXqxpNtrt9XEuUeqCeR=A4PpSaAsHYg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 09:34 AM, Viresh Kumar wrote:
> On 5 March 2013 13:22, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> I misread it here when i looked at this mail for the first time. :)
> I strongly believe that we need a full stop (.) before "Every sampling_rate",
> otherwise it looks like we check for down_factor while increasing freq :)

I agree. I will do that.

> Even now we aren't checking this 80% thing, right? And so in your patch we can
> actually fix the patch too with the right logic of code.. And
> documentation too :)

In my opinion the logic was initially correct. It was broken in the same 
commit that broke also sampling_down_factor.

Now we check if load < (cs_tuners.down_threshold - 10) to decrease freq.
Down threshold is 20, so we actually check the 80% idle.

I think the subtraction of 10 from down_threshold is wrong. It seems 
similar with ondemand but there is no logic for this in conservative.
User can simply select the down_threshold and the load will be compared 
with user's value. No need to alter user's selection.

I will prepare a patchset for these changes.

Regards,
Stratos
