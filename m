Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968206Ab3HIQse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:48:34 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:42831 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968185Ab3HIQsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:48:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DZ=aJsOvTyrKL=57_jGMGQX8k3mDamgXqnF-9Ou2fpAg@mail.gmail.com>
References: <1375825071-20922-1-git-send-email-dianders@chromium.org>
	<1376066000-5495-1-git-send-email-dianders@chromium.org>
	<1376066000-5495-3-git-send-email-dianders@chromium.org>
	<CAOMZO5DZ=aJsOvTyrKL=57_jGMGQX8k3mDamgXqnF-9Ou2fpAg@mail.gmail.com>
Date: Fri, 9 Aug 2013 09:48:29 -0700
X-Google-Sender-Auth: CCzIhafVGH0RfNhacxfqJEFyg3I
Message-ID: <CAD=FV=WxCpqX+23i_Q4_swKWqieNdcZ_sa0bxrcpUnr4vA+pGA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mmc: dw_mmc: Add exynos resume_noirq callback to
 clear WAKEUP_INT
From: Doug Anderson <dianders@chromium.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Chris Ball <cjb@laptop.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio,

Thanks for your review.

On Fri, Aug 9, 2013 at 9:41 AM, Fabio Estevam <festevam@gmail.com> wrote:
> On Fri, Aug 9, 2013 at 1:33 PM, Doug Anderson <dianders@chromium.org> wrote:
>
>> +#else
>> +#define dw_mci_exynos_suspend          NULL
>> +#define dw_mci_exynos_resume           NULL
>> +#define dw_mci_exynos_resume_noirq     NULL
>> +#endif /* CONFIG_PM_SLEEP */
>
> You could avoid this else block if you use 'static SIMPLE_DEV_PM_OPS' below.
>
>> +
>>  static void dw_mci_exynos_prepare_command(struct dw_mci *host, u32 *cmdr)
>>  {
>>         /*
>> @@ -187,13 +234,20 @@ static int dw_mci_exynos_probe(struct platform_device *pdev)
>>         return dw_mci_pltfm_register(pdev, drv_data);
>>  }
>>
>> +const struct dev_pm_ops dw_mci_exynos_pmops = {
>> +       SET_SYSTEM_SLEEP_PM_OPS(dw_mci_exynos_suspend, dw_mci_exynos_resume)
>> +       .resume_noirq = dw_mci_exynos_resume_noirq,
>> +       .thaw_noirq = dw_mci_exynos_resume_noirq,
>> +       .restore_noirq = dw_mci_exynos_resume_noirq,
>> +};
>
> static SIMPLE_DEV_PM_OPS(dw_mci_exynos_pmops, dw_mci_exynos_suspend,
>  dw_mci_exynos_resume ) ;

The big problem is that SIMPLE_DEV_PM_OPS() doesn't take a "_noirq"
parameters.  Do you know of one that does?

-Doug
