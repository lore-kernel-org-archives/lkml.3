Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaA0H1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:27:41 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63431 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaA0H1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:27:39 -0500
MIME-Version: 1.0
In-Reply-To: <CALT56yODeNZLH5bDHN2N0awFA0EyPH77wDyAv+4Qkgr6mu_u0Q@mail.gmail.com>
References: <1390720540-13350-1-git-send-email-badarkhe.manish@gmail.com>
	<52E50C24.8030305@gmail.com>
	<CAKDJKT5TvkgUN2Ee-2NignzxY1F54SHEiNL2i6c+hMjnLHOg5g@mail.gmail.com>
	<20140126214542.GC18840@core.coreip.homeip.net>
	<52E582D0.9070501@gmail.com>
	<CALT56yPJjLZ_UHgH1koKPbTLBR=5QzSFMMXfqYxspw30_fpKNQ@mail.gmail.com>
	<20140126231452.GE18840@core.coreip.homeip.net>
	<CALT56yODeNZLH5bDHN2N0awFA0EyPH77wDyAv+4Qkgr6mu_u0Q@mail.gmail.com>
Date: Mon, 27 Jan 2014 12:57:38 +0530
Message-ID: <CAKDJKT7=4+N7G2TQJKj9xm4Ftn53jqThHoUUOyVr+hZv3Us1kg@mail.gmail.com>
Subject: Re: [PATCH] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for review.

On Mon, Jan 27, 2014 at 5:16 AM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> On Mon, Jan 27, 2014 at 3:14 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> On Mon, Jan 27, 2014 at 02:31:59AM +0400, Dmitry Eremin-Solenikov wrote:
>>> On Mon, Jan 27, 2014 at 1:49 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>> > On 26.01.2014 22:45, Dmitry Torokhov wrote:
>>> >>
>>> >> On Sun, Jan 26, 2014 at 07:31:50PM +0530, Manish Badarkhe wrote:
>>> >>>
>>> >>> Hi Tomasz,
>>> >>>
>>> >>> Thank you for your review comments.
>>> >>>
>>> >>> On Sun, Jan 26, 2014 at 6:52 PM, Tomasz Figa <tomasz.figa@gmail.com>
>>> >>> wrote:
>>> >>>>
>>> >>>>
>>> >>>> Hi Manish,
>>> >>>>
>>> >>>>
>>> >>>> On 26.01.2014 08:15, Manish Badarkhe wrote:
>>> >>>>>
>>> >>>>>
>>> >>>>> Instead of "#if define CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
>>> >>>>> option for DT code to avoid if-deffery in code.
>>> >>>>>
>>> >>>>> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
>>> >>>>> ---
>>> >>>>> :100644 100644 b4513f2... d353fbc... M  drivers/power/max8925_power.c
>>> >>>>>    drivers/power/max8925_power.c |   14 +++++---------
>>> >>>>>    1 file changed, 5 insertions(+), 9 deletions(-)
>>> >>>>>
>>> >>>>> diff --git a/drivers/power/max8925_power.c
>>> >>>>> b/drivers/power/max8925_power.c
>>> >>>>> index b4513f2..d353fbc 100644
>>> >>>>> --- a/drivers/power/max8925_power.c
>>> >>>>> +++ b/drivers/power/max8925_power.c
>>> >>>>> @@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct
>>> >>>>> max8925_power_info *info)
>>> >>>>>          return 0;
>>> >>>>>    }
>>> >>>>>
>>> >>>>> -#ifdef CONFIG_OF
>>> >>>>>    static struct max8925_power_pdata *
>>> >>>>>    max8925_power_dt_init(struct platform_device *pdev)
>>> >>>>>    {
>>> >>>>> @@ -468,13 +467,6 @@ max8925_power_dt_init(struct platform_device
>>> >>>>> *pdev)
>>> >>>>>
>>> >>>>>          return pdata;
>>> >>>>>    }
>>> >>>>> -#else
>>> >>>>> -static struct max8925_power_pdata *
>>> >>>>> -max8925_power_dt_init(struct platform_device *pdev)
>>> >>>>> -{
>>> >>>>> -       return pdev->dev.platform_data;
>>> >>>>> -}
>>> >>>>> -#endif
>>> >>>>>
>>> >>>>>    static int max8925_power_probe(struct platform_device *pdev)
>>> >>>>>    {
>>> >>>>> @@ -483,7 +475,11 @@ static int max8925_power_probe(struct
>>> >>>>> platform_device *pdev)
>>> >>>>>          struct max8925_power_info *info;
>>> >>>>>          int ret;
>>> >>>>>
>>> >>>>> -       pdata = max8925_power_dt_init(pdev);
>>> >>>>> +       if (IS_ENABLED(CONFIG_OF))
>>> >>>>> +               pdata = max8925_power_dt_init(pdev);
>>> >>>>> +       else
>>> >>>>> +               pdata = pdev->dev.platform_data;
>>> >>>>> +
>>> >>>>
>>> >>>>
>>> >>>>
>>> >>>> This does not look much better than before this patch. Instead of
>>> >>>> "if-deffery" outside function bodies you are adding "iffery" (if there is
>>> >>>> such a word) inside a function.
>>> >>>> What about adding
>>> >>>>
>>> >>>>          if (!IS_ENABLED(CONFIG_OF))
>>> >>>>                  return pdev->dev.platform_data;
>>> >>>>
>>> >>>> on top of max8925_power_dt_init() instead or maybe also renaming this
>>> >>>> function to max8925_get_pdata()?
>>> >>>
>>> >>>
>>> >>> Okay, I will rename function "max8925_power_dt_init()" to
>>> >>> "max8925_get_pdata()".
>>> >>> As you suggested, in the body of this function  will add a logic to
>>> >>> retrieve  data in case
>>> >>> of DT and non-DT platforms.
>>> >>
>>> >>
>>> >> Should we not always favor platform-supplied data regardless of
>>> >> CONFIG_OF state and fall back to DT (firmware) supplied data if platform
>>> >> data is absent? This way one can tweak kernel behavior without needing
>>> >> to change firmware.
>>> >
>>> >
>>> > I guess we should, but apparently this was not the original behavior before
>>> > this patch, so I'm not sure if we should be squashing such semantic change
>>> > with this simple refactor.
>>>
>>> Hmm. Judging from the code, max8925_power_dt_init() function follows exactly
>>> opposite strategy - it uses platform_data if of_node is not populated/available.
>>> So (if dt_init will compile with CONFIG_OF disabled) one can always
>>> use _dt_init()
>>> function to retrieve pdata.
>>
>> Right, and I question whether this is good behavior or if it should be
>> corrected.
>
> I'd say, correct it.

Okay, I will update code as per Dmitry's feedback.

Regards
Manish Badarkhe
