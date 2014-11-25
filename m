Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaKYI46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:56:58 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:44863 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaKYI44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:56:56 -0500
MIME-Version: 1.0
In-Reply-To: <715439136.113681416899252854.JavaMail.weblogic@epmlwas08c>
References: <715439136.113681416899252854.JavaMail.weblogic@epmlwas08c>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 25 Nov 2014 09:56:34 +0100
X-Google-Sender-Auth: hVTu70DF9WfEJM_bZdxKvCqeVYI
Message-ID: <CAAObsKDYuEhX_mJ-ae0w6+zVPx26QCotb6StGY5U1JBPttPa4A@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] PM / devfreq: tegra: add devfreq driver for Tegra
 Activity Monitor
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2014 at 08:07, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> The ACTMON block can monitor several counters, providing averaging and firing
>> interrupts based on watermarking configuration. This implementation monitors
>> the MCALL and MCCPU counters to choose an appropriate frequency for the
>> external memory clock.
>>
>> This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
>> Perttunen <mikko.perttunen@kapsi.fi>.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>
> How are you going to integrate other two patches?

I think they should go through the Tegra tree.

> May I just go ahead with this patch only?

Yes, I think that would be fine as the other patches aren't actual
build or runtime dependencies. This driver shouldn't cause problems
either if it's ran without the EMC and CPUFreq patches (though won't
be fully functional, of course).

Regards,

Tomeu

> Cheers,
> MyungJoo.
>
>>
>> ---
>>
>> v2:   * Use devfreq
>> ---
>>  drivers/devfreq/Kconfig         |  10 +
>>  drivers/devfreq/Makefile        |   1 +
>>  drivers/devfreq/tegra-devfreq.c | 718 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 729 insertions(+)
>>  create mode 100644 drivers/devfreq/tegra-devfreq.c
>>
