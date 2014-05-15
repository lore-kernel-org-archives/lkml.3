Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaEOIRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:17:41 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:48419 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbaEOIRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140515074203.GD5952@ulmo>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
	<1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
	<20140514221423.GC6215@mithrandir>
	<CAPdUM4NaLpN99JCJH3qMakSO3OG6ASjEuvvr_CnKv=gOiqfzMQ@mail.gmail.com>
	<20140515074203.GD5952@ulmo>
Date: Thu, 15 May 2014 13:47:33 +0530
X-Google-Sender-Auth: oWEcEZoAqEVkRbIAs0LhYlOJlK8
Message-ID: <CAPdUM4OXXMzMDNVym1ysMx7wifbO2QsSP5jk6cn3+F8Or3ng3w@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2014 13:12, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Thu, May 15, 2014 at 10:49:37AM +0530, Rahul Sharma wrote:
>> Hi Thierry,
>>
>> On 15 May 2014 03:44, Thierry Reding <thierry.reding@gmail.com> wrote:
>> > On Thu, May 15, 2014 at 12:47:21AM +0530, Rahul Sharma wrote:
> [...]
>> >> +#define HDMI_PHY     0
>> >> +#define DAC_PHY      1
>> >> +#define ADC_PHY      2
>> >> +#define PCIE_PHY     3
>> >> +#define SATA_PHY     4
>> >
>> > Perhaps these should be namespaced somehow to avoid potential conflicts
>> > with other PHY providers?
>>
>> How about XXX_SIMPLE_PHY?
>
> The indices are specific to the Exynos PHY device, so why not
> PHY_EXYNOS_SIMPLE_XXX (or any variation thereof)?

This looks ok. I will use that.

>
>> >> +#define PHY_NR       5
>> >
>> > I'm not sure that this belongs here either. It's not a value that will
>> > ever appear in a DT source file.
>>
>> I want it to grow along with new additions in the phy list else
>> catastrophic. This will look unrelated in driver.
>
> But this is in no way growing automatically as it is. Whoever adds a new
> type of PHY will need to manually increment this define. Furthermore the
> driver will need to be updated to cope with this anyway.

Not automatically. What I meant was If keeping it at end of the list, it is not
possible that somebody skip the updation of PHY_NR when adding a new phy
type.

If I leave a comment at the end of the list to update PHY_NR (after moving it
to driver), that also serves the purpose.

>
> I think this is even a reason to have this only in the driver. Otherwise
> you could have a situation where somebody upgrades the binding (and this
> file along with it) but not update the driver with the necessary support.
> But the driver will still pick up the PHY_NR change and will accept the
> new PHY type as valid, even though it has no code to handle it. If you
> have this in the driver, however, then as long as the driver has not yet
> been updated it will reject requests for the new PHY type. And that's
> exactly what it should be doing since it doesn't know how to handle it.

hmn...Ok.

Regards,
Rahul Sharma

>
> Thierry
