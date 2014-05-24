Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaEXMke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:40:34 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56398 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaEXMkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:40:32 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <7638065.14871400820762911.JavaMail.weblogic@epml08>
References: <7638065.14871400820762911.JavaMail.weblogic@epml08>
Date: Sat, 24 May 2014 21:40:31 +0900
X-Google-Sender-Auth: 1SHlLlp9bVIf53phrdnHMQmbfKM
Message-ID: <CAJ0PZbS_Xcu=OJuiy=xs7k_A1=ajp34KEdi4KGC3e-y8t3EUGw@mail.gmail.com>
Subject: Re: [PATCH] PM / devfreq: remove checks for CONFIG_EXYNOS_ASV
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 1:52 PM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> On Thu, May 22, 2014 at 5:37 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> Checks for CONFIG_EXYNOS_ASV were added in v3.3. But the related Kconfig
>> symbol has never been added to the tree. Remove these checks, as they
>> always evaluate to false.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>
> Thanks for pointing this out.
>
> ASV was supposed to be merged, but it appears it failed or never attempted.
>
> I will merge with the next batch (this week).
>
>
> Cheers,
> MyungJoo.

Uh.. ASV itself affects the power efficiency; thus, I'd like to keep
it alive, but not as the current form.

For 3.16, I'll correct the name following your report. (not going for
3.15RCx anyway)


Then, I'll let it merged into struct busfreq_data for later RCx.


Cheers,
MyungJoo.

>
>> ---
>> 0) Untested.
>>
>> 1) I do not really care much for this patch. Two years is not very long
>> for dead code to remain in the tree. There is, however, a trivial issue
>> that makes this patch stand out from the other patches in my current
>> sweep of the tree for Kconfig related problems.
>>
>> See, here the use of an unknown Kconfig macro hides an obvious typo: it
>> should either be "exynos_result_of_asv" or "exynos4_result_of_asv", but
>> not both. Ie, this almost certainly wouldn't have compiled even if the
>> Kconfig symbol EXYNOS_ASV would have been part of the tree.
>>
>> 2) So this makes me wonder whether there are any guidelines for using
>> Kconfig macros before the related Kconfig symbols are merged?
>>
>>  drivers/devfreq/Kconfig              |  3 +--
>>  drivers/devfreq/exynos/exynos4_bus.c | 13 -------------
>>  2 files changed, 1 insertion(+), 15 deletions(-)



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
