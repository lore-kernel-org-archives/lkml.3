Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaEOEBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:01:11 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35708 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaEOEBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <5373CBAD.2010505@gmail.com>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
	<1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
	<5373CBAD.2010505@gmail.com>
Date: Thu, 15 May 2014 09:31:07 +0530
X-Google-Sender-Auth: xXx3vbe6kYu--PxSmtI0q_FcRjM
Message-ID: <CAPdUM4MT0nZcLRtNcKRAeW4Q3n5z9n4BnzR-7uYMb1gqwEhWXA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, sunil joshi <joshi@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Tomasz,

On 15 May 2014 01:31, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Rahul, Tomasz,
[snip]
>> +     simplephys: simple-phys@10040000 {
>> +             compatible = "samsung,exynos5250-simple-phy";
>
> Missing reg property or unnecessary @unit-address suffix in node name.

I should have removed "@unit-address". I will change this.

>
>> +             samsung,pmu-syscon = <&pmu_system_controller>;
>> +             #phy-cells = <1>;
>> +     };
>
> In general, the idea is quite good, but I think this should rather bind
> to the main PMU node, since this is just a part of the PMU, not another
> device in the system. This also means that the PMU node itself should be
> the PHY provider.
>

Please correct me if I got you wrong. You want somthing like this:

pmu_system_controller: system-controller@10040000 {
         ...
          simple_phys: simple-phys {
                        compatible = "samsung,exynos5420-simple-phy";
                        ...
          };
};

Regards,
Rahul Sharma.

> Otherwise looks good.
>
> Best regards,
> Tomasz
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
