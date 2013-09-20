Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab3ITTKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:10:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58743 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3ITTKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:10:39 -0400
Message-ID: <523C9D8B.2000701@ti.com>
Date: Fri, 20 Sep 2013 14:10:03 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <balbi@ti.com>, Olof Johansson <olof@lixom.net>
CC: Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ARM: OMAP3630: Add generic machine descriptor
References: <1379693332-10585-1-git-send-email-nm@ti.com> <CAOesGMj6G7LeYUJsGpZHxKOjiNrk+1U55QFqcQyTb6_Co+n4zQ@mail.gmail.com> <20130920162329.GC18721@radagast> <CAOesGMiru=RUHS4XKLL=DC+hxtAJqtcjgd5hPbaccnAfEZ3y0g@mail.gmail.com> <20130920174228.GK18721@radagast>
In-Reply-To: <20130920174228.GK18721@radagast>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 12:42 PM, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Sep 20, 2013 at 10:16:48AM -0700, Olof Johansson wrote:
>>> On Fri, Sep 20, 2013 at 09:19:02AM -0700, Olof Johansson wrote:
>>>> On Fri, Sep 20, 2013 at 9:08 AM, Nishanth Menon <nm@ti.com> wrote:
>>>>> An alternative approach may be to (for all SoCs):
>>>>> 1. define every SoC entry - ti,omap3430 ti,omap3630...
>>>>> 2. have a generic omap3_init which uses "if (of_machine_is_compatible("ti,omap3630"))"
>>>>> to invoke the appropriate omap3xxx_init_early.
>>>>
>>>> Yes, this would be better, but you can do add a DT_MACHINE as in this
>>>> patch but have ti,omap3630 as the dt_compat table. Then there's no
>>>> need to add runtime checks.
>>>
>>> I was going to reply that adding of_machine_is_compatible("ti,omap3630")
>>> would help in some situations, but guess it's already tainted ;-)
>>
>> Oh, if it's just a few checks, then by all means go down that route. I
>> didn't look at the code to see how much it would be.
>>
>> But if a new DT_MACHINE is added, then it should definitely be based
>> on ti,omap3630 instead of listing all the boards.
This was more in the direction I was hoping to go.

> 
> the idea was to CPU compatible property to conditionally enable known
> erratas workarounds. In some cases, Revision register can't be trusted,
> so instead of creating per-errata DT properties (since that'd be
> describing the SW, in a way), I thought of using
> of_machine_is_compatible() checks, but that assumes CPU compatible is
> "correct".
I think the quirk handling is part of what Tony is attempting, and the
definition of these might help, I think..


-- 
Regards,
Nishanth Menon
