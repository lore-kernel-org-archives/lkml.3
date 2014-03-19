Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbaCSJBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:01:19 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59229 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbaCSJBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:01:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140319175927.a3feadcacbffe80eca1d3421@samsung.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
	<CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
	<20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com>
	<532862ED.8040809@samsung.com>
	<20140319175927.a3feadcacbffe80eca1d3421@samsung.com>
Date: Wed, 19 Mar 2014 14:31:14 +0530
Message-ID: <CAK9yfHxxo2eFh38gPZkpYf1ueBWySWqPzgLV_tSSykzHhNzN8g@mail.gmail.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 14:29, Cho KyongHo <pullip.cho@samsung.com> wrote:
> On Tue, 18 Mar 2014 16:14:53 +0100, Tomasz Figa wrote:
>> On 18.03.2014 12:09, Cho KyongHo wrote:
>> > On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
>> >> Hi KyongHo,
>> >>
>> >> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
>> >>> This patch uses managed device helper functions in the probe().
>> >>>
>> >>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>> >>> ---
>> >> [snip]
>> >>
>> >>> +       data->clk = devm_clk_get(dev, "sysmmu");
>> >>> +       if (IS_ERR(data->clk)) {
>> >>> +               dev_info(dev, "No gate clock found!\n");
>> >>> +               data->clk = NULL;
>> >>> +       }
>> >>
>> >> Why aren't you returning from here upon error?
>> >
>> > It is for the case of a System MMU which does not need clock gating.
>> >
>>
>> Are there really such cases?
>>
>
> Yes.
> Especially in the case of initial stage of new SoC development.
>
> I have experianced some software workaround for H/W restriction
> needs prevention of clock gating for some devices.

So aren't these basically some exceptions/hacks rather than the usual way
of functioning of the device?

-- 
With warm regards,
Sachin
