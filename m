Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaLEIZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:25:16 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:35217 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaLEIZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:25:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFo15y-ENW9M3bratoWQ_DL_mfT3FwQE4i+pscR0crmyBA@mail.gmail.com>
References: <CAPDyKFpX5nXR18pKdLrtDrPK60p1y2CEqq+--3z3jczRRmKrqA@mail.gmail.com>
	<1417434068-7344-1-git-send-email-amit.daniel@samsung.com>
	<CAPDyKFo15y-ENW9M3bratoWQ_DL_mfT3FwQE4i+pscR0crmyBA@mail.gmail.com>
Date: Fri, 5 Dec 2014 13:55:12 +0530
X-Google-Sender-Auth: y6z-dwN7pEcdH74Mcyz3g9MJIQk
Message-ID: <CADGdYn5tAV2QjJ1Q0vi-EoSzvaoaOnCzemR+=X3MqotY9T8d2Q@mail.gmail.com>
Subject: Re: [PATCH] PM/ Domains: Export of_genpd_get_from_provider function.
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 9:09 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 1 December 2014 at 12:41, Amit Daniel Kachhap
> <amit.daniel@samsung.com> wrote:
>> This function looks up a PM domain form the provider. This will be
>> useful to add parent/child domain relationship from the SoC specific
>> code. The caller of the function must make sure that PM domain provider
>> is already registered.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>> This patch may solve the same purpose which is done by earlier posts
>> 1) https://lkml.org/lkml/2014/11/24/319 - In this there were comments
>> for not using the PM domain name.
>>
>> 2) Ulf Hansson posted a patch
>> http://www.spinics.net/lists/linux-samsung-soc/msg39745.html which also solves
>> similar purpose but I feel this is slightly complex and involves changing
>> the genpd structure.
>>
>>
>>  drivers/base/power/domain.c |    3 ++-
>>  include/linux/pm_domain.h   |    8 ++++++++
>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
>> index d822753..5d7a2c1 100644
>> --- a/drivers/base/power/domain.c
>> +++ b/drivers/base/power/domain.c
>> @@ -2129,7 +2129,7 @@ EXPORT_SYMBOL_GPL(of_genpd_del_provider);
>>   * Returns a valid pointer to struct generic_pm_domain on success or ERR_PTR()
>>   * on failure.
>>   */
>> -static struct generic_pm_domain *of_genpd_get_from_provider(
>> +struct generic_pm_domain *of_genpd_get_from_provider(
>>                                         struct of_phandle_args *genpdspec)
>>  {
>>         struct generic_pm_domain *genpd = ERR_PTR(-ENOENT);
>> @@ -2149,6 +2149,7 @@ static struct generic_pm_domain *of_genpd_get_from_provider(
>>
>>         return genpd;
>>  }
>> +EXPORT_SYMBOL_GPL(of_genpd_get_from_provider);
>>
>>  /**
>>   * genpd_dev_pm_detach - Detach a device from its PM domain.
>> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
>> index 9690827..4954e24 100644
>> --- a/include/linux/pm_domain.h
>> +++ b/include/linux/pm_domain.h
>> @@ -282,6 +282,8 @@ typedef struct generic_pm_domain *(*genpd_xlate_t)(struct of_phandle_args *args,
>>  int __of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
>>                         void *data);
>>  void of_genpd_del_provider(struct device_node *np);
>> +struct generic_pm_domain *of_genpd_get_from_provider(
>> +                       struct of_phandle_args *genpdspec);
>>
>>  struct generic_pm_domain *__of_genpd_xlate_simple(
>>                                         struct of_phandle_args *genpdspec,
>> @@ -299,6 +301,12 @@ static inline int __of_genpd_add_provider(struct device_node *np,
>>  }
>>  static inline void of_genpd_del_provider(struct device_node *np) {}
>>
>> +static inline struct generic_pm_domain *of_genpd_get_from_provider(
>> +                       struct of_phandle_args *genpdspec)
>> +{
>> +       return NULL;
>> +}
>> +
>>  #define __of_genpd_xlate_simple                NULL
>>  #define __of_genpd_xlate_onecell       NULL
>>
>> --
>> 1.7.9.5
>>
>
> This seems like a good approach!
>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Thanks.
>
> Do, note that you will have to resend the patch to linux-pm list as
> well. Unless Rafael is happy to pick it up from here.
Sure. My fault.

Regards,
Amit
>
> Kind regards
> Uffe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
