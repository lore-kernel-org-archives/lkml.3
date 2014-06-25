Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaFYDJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:09:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57086 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaFYDJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:09:45 -0400
Message-ID: <53AA3D71.5010000@gmail.com>
Date: Wed, 25 Jun 2014 08:39:37 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@google.com>, Tushar Behera <tushar.b@samsung.com>
CC: Kevin Hilman <khilman@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        ML Devicetree <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        ML Arch-Arm <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss
 always enabled
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>	<1402464739-19044-2-git-send-email-tushar.b@samsung.com>	<7ha99jjspt.fsf@paris.lan>	<CAC5m3Bwj1HEWSQd7rx6Zn5vbUPKFqeT_X0PL3mAxRw0FNkK=QQ@mail.gmail.com> <CAD=FV=VP4-+B6oV8Skb3rxxPRbOWmzu=6PJbWbxCU=86ZvRuYQ@mail.gmail.com>
In-Reply-To: <CAD=FV=VP4-+B6oV8Skb3rxxPRbOWmzu=6PJbWbxCU=86ZvRuYQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 04:29 AM, Doug Anderson wrote:
> Tushar,
> 
> On Thu, Jun 12, 2014 at 12:40 AM, Tushar Behera <tushar.b@samsung.com> wrote:
>> On Wed, Jun 11, 2014 at 10:20 PM, Kevin Hilman <khilman@linaro.org> wrote:
>>> Tushar Behera <tushar.b@samsung.com> writes:
>>>
>>>> When the output clock of AUDSS mux is disabled, we are getting kernel
>>>> oops while doing a clk_get() on other clocks provided by AUDSS.
>>>>
>>>> Though user manual doesn't specify this dependency, we came across
>>>> this issue while disabling the parent of AUDSS mux clocks.
>>>>
>>>> Keeping the parents of AUDSS mux always enabled fixes this issue.
>>>
>>> While this patch works (and fixes the boot problem for me), it seems
>>> like it's papering over the real problem.
>>>
>>
>> Thanks for testing.
>>
>>> Seems like the right fix is actually modelling the clocks properly so
>>> that enabling a child clock ensures that the parent is also enabled.
>>>
>>
>> Patch 2/3 was to ensure we have proper clock tree defined for
>> Exynos5420. While testing with audio disabled, that patch alone fixed
>> the issue. But when audio was enabled (and hence I2S0 was trying to
>> access the clocks), we got some kernel oops during late booting, hence
>> I came up this solution.
>>
>> The solution might be a little half-baked because of the urgency to
>> push the fix, but will try to dig more into the issue on Monday when I
>> resume office.
> 
> Which Monday were you referring to?  ;)
> 

Sorry that I couldn't get deeper into this issue. Thanks for reminding
though.

> ...but in all seriousness do you have an official status update on
> this patch?  It seems as if it's not needed and all you need is
> <https://patchwork.kernel.org/patch/4333581/>, but it would be nice to
> get an official confirmation.

I have tested various scenarios with only patch 2/3, which seems to be
sufficient for the time being. I have not encountered the older issue
till now. I was thinking of testing a bit further, but given that you
have already asked for, we can go ahead with only patch 2/3 right now.

In case any further issue comes up, I will post patch 1/3 as per the
review comments that I have got.

> 
> Thanks!
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Tushar Behera
