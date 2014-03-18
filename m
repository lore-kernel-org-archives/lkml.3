Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaCRMS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:18:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33712 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaCRMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:18:53 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-fd-532839aa6ebf
Message-id: <532839A5.8020505@samsung.com>
Date: Tue, 18 Mar 2014 13:18:45 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 4/8] devfreq: exynos4: Fix bug of resource leak and code
 clean on probe()
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-5-git-send-email-cw00.choi@samsung.com>
 <53234132.8080202@samsung.com> <532682A8.2030300@samsung.com>
In-reply-to: <532682A8.2030300@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xK7qrLDWCDY7d5rbo6PnNYnH9y3NW
	i/lHzrFanHu1ktHibNMbdouFbUtYLC7vmsNm8bn3CKPFjPP7mCyWXr/IZHG7cQWbxZsfZ5ks
	Jkxfy2LxeMVbdotXB9tYHPg91sxbw+ixcvkXNo/Fe14yefxcvp3do2/LKkaP4ze2M3l83iTn
	sXFuaABHFJdNSmpOZllqkb5dAlfG7BtXmAouqVTMW/eOpYHxpkwXIyeHhICJxN3le5ghbDGJ
	C/fWs3UxcnEICSxllDiy/x0ThPOZUWJh8y3GLkYODl4BLYm2tVIgJouAqkTPEk6QXjYBNYnP
	DY/YQGx+oIo1TddZQGxRgQiJuRM3g8V5BQQlfky+BxYXEdCQmPn3CiOIzSzwlUni5jwmEFtY
	IFHi2O5pLBBrDzJK/G2eAtbMKaAt0fVpDVSDtcTKSdugbHmJzWveMk9gFJyFZMcsJGWzkJQt
	YGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESaV93MC49ZnWIUYCDUYmH9yWberAQa2JZ
	cWXuIUYJDmYlEd79OhrBQrwpiZVVqUX58UWlOanFhxiZODilGhgnJTKZsn5cGGq+1lItZMPa
	WannNtsZF2uWdR6Smxix84cnF7vayt8PJ169//3Aj55ZbcyCYlLCHQsZ7pl9PPl252r5kPkK
	OnP2z7xXLaLgerWk/0XNikx15WeLVjVlM9munPR97St+weeO36Zt4b6+0yLzROPNks3HFOyn
	f/0dZpPKkr1wJ2OYEktxRqKhFnNRcSIAMD0R9pICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.03.2014 06:05, Chanwoo Choi wrote:
> Hi Tomasz,
>
> On 03/15/2014 02:49 AM, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 13.03.2014 09:17, Chanwoo Choi wrote:
>>> This patch fix bug about resource leak when happening probe fail and code clean
>>> to add debug message.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> ---
>>>    drivers/devfreq/exynos/exynos4_bus.c | 32 ++++++++++++++++++++++++++------
>>>    1 file changed, 26 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
>>> index a2a3a47..152a3e9 100644
>>> --- a/drivers/devfreq/exynos/exynos4_bus.c
>>> +++ b/drivers/devfreq/exynos/exynos4_bus.c
>>> @@ -1152,8 +1152,11 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>>            dev_err(dev, "Cannot determine the device id %d\n", data->type);
>>>            err = -EINVAL;
>>>        }
>>> -    if (err)
>>> +    if (err) {
>>> +        dev_err(dev, "Cannot initialize busfreq table %d\n",
>>> +                 data->type);
>>>            return err;
>>> +    }
>>>
>>>        rcu_read_lock();
>>>        opp = dev_pm_opp_find_freq_floor(dev,
>>> @@ -1176,7 +1179,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>>        if (IS_ERR(data->devfreq)) {
>>>            dev_err(dev, "Failed to add devfreq device\n");
>>>            err = PTR_ERR(data->devfreq);
>>> -        goto err_opp;
>>> +        goto err_devfreq;
>>>        }
>>>
>>>        /*
>>> @@ -1185,18 +1188,35 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>>         */
>>>        busfreq_mon_reset(data);
>>>
>>> -    devfreq_register_opp_notifier(dev, data->devfreq);
>>> +    /* Register opp_notifier for Exynos4 busfreq */
>>> +    err = devfreq_register_opp_notifier(dev, data->devfreq);
>>> +    if (err < 0) {
>>> +        dev_err(dev, "Failed to register opp notifier\n");
>>> +        goto err_notifier_opp;
>>> +    }
>>>
>>> +    /* Register pm_notifier for Exynos4 busfreq */
>>>        err = register_pm_notifier(&data->pm_notifier);
>>>        if (err) {
>>>            dev_err(dev, "Failed to setup pm notifier\n");
>>> -        devfreq_remove_device(data->devfreq);
>>> -        return err;
>>> +        goto err_notifier_pm;
>>>        }
>>>
>>>        return 0;
>>>
>>> -err_opp:
>>> +err_notifier_pm:
>>> +    devfreq_unregister_opp_notifier(dev, data->devfreq);
>>> +err_notifier_opp:
>>> +    /*
>>> +     * The devfreq_remove_device() would execute finally devfreq->profile
>>> +     * ->exit(). To avoid duplicate resource free operation, return directly
>>> +     * before executing resource free below 'err_devfreq' goto statement.
>>> +     */
>>
>> I'm not quite sure about this. I believe that in this case devfreq->profile->exit() would be exynos4_bus_exit() and all it does is devfreq_unregister_opp_notifier(dev, data->devfreq), so all remaining resources (regulators, clocks, etc.) would get leaked.
>
> This patch execute following sequence to probe exynos4_busfreq.c:
>
> 1. Parse dt node to get resource(regulator/clock/memory address).
> 2. Enable regulator/clock and map memory.
> 3. Add devfreq device using devfreq_add_device().
>     The devfreq_add_device() return devfreq instance(data->devfreq).
> 4. Register opp_notifier using devfreq instance(data->devfreq) which is created in sequence #3.
>
> Case 1,
> If an error happens in sequence #3 for registering devfreq_add_device(),
>
> this case can't execute devfreq->profile->exit() to free resource
> because this case has failed to register devfreq->profile to devfreq_list.
>
> So, must goto 'err_devfreq' statement to free resource(regulator/clock/memory).
>
>
> Case 2,
> If an error happens in sequence #4 for registering opp_notifier,
>
> In contrast
> this case can execute devfreq->profile->exit() to free resource.
> But, After executed devfreq->profile->exit(),
> should not execute 'err_devfreq' statement to free resource.
> In case, will operate twice of resource.
>
> If my explanation is wrong, please reply your comment.
>

OK, it will work indeed, however the code is barely readable with this.

For consistency (and readability), resources acquired in platform 
driver's .probe() should be freed in .remove() and error path of 
.probe() should not rely on external code to do the clean-up.

So, as I proposed in my previous reply:

>>
>> I believe the correct thing to do would be to remove the .exit() callback from exynos4_devfreq_profile struct and handle all the clean-up here in error path.
>>

Best regards,
Tomasz
