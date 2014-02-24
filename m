Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaBXJAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:00:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36986 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaBXJAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:00:04 -0500
Message-ID: <d7272b91c74148c56de5f1c27dc7b7c7.squirrel@www.codeaurora.org>
In-Reply-To: <CAKohpok2rbepUS_7quZ0AThPckvVnAZybVpsV0ctiDWZmxTdRw@mail.gmail.com>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
    <530AF7E4.5080806@linux.vnet.ibm.com>
    <CAKohpok-8_JV8hRDiWnRLYqEqyvD60cyn5Hs1HcZTSEPZjLvOQ@mail.gmail.com>
    <a7536f7b5a03fe287aaf1974db74ba64.squirrel@www.codeaurora.org>
    <CAKohpomRqboKjHRF8ev9erJ6MdRWcsX2jO7A=g47gMmewm_ZiQ@mail.gmail.com>
    <b59f4a49af4ebd12c2d61e58dfb27a39.squirrel@www.codeaurora.org>
    <CAKohpok2rbepUS_7quZ0AThPckvVnAZybVpsV0ctiDWZmxTdRw@mail.gmail.com>
Date: Mon, 24 Feb 2014 09:00:03 -0000
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
From: skannan@codeaurora.org
To: "Viresh Kumar" <viresh.kumar@linaro.org>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
User-Agent: SquirrelMail/1.4.22-3.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Viresh Kumar wrote:
> On 24 February 2014 14:17,  <skannan@codeaurora.org> wrote:
>> Sorry, not sure I understand what you mean.
>>
>> I agree, wording in my commit text might be unclear. I'll fix it after
>> we
>> agree on the code fix. In the MSM case, each CPU has it's own policy.
>>
>> I'm assuming your original complaint was about my confusing wording.
>> Maybe
>> that's not what you were pointing out?
>
> In your case each CPU has a separate policy structure as they have
> separately
> controllable clocks. But you also said that CPU0 is setting CPU1's
> governor to
> NULL. I don't see that happening. Each CPU sets its own governor to NULL
> on
> init().

When I said "CPU0 is setting CPU1's governor to NULL", I meant
thread/context running in CPU0 is setting CPU1's governor as part of
CPU1's ONLINE notifier.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

