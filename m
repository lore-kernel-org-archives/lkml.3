Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaHZRRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:17:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39590 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaHZRRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:17:49 -0400
Message-ID: <53FCC139.6020703@wwwdotorg.org>
Date: Tue, 26 Aug 2014 11:17:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: linux-pm@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        =?windows-1252?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v4 3/3] memory: tegra124-emc: Add EMC driver
References: <1409058728-13347-1-git-send-email-tomeu.vizoso@collabora.com> <1409058728-13347-4-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1409058728-13347-4-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 07:12 AM, Tomeu Vizoso wrote:
> Sets the EMC clock rate based on the bandwidth requirements registered by
> memory clients through the PM_QOS_MEMORY_BANDWIDTH class.
>
> Note: this is just an example and not a proper driver for a external memory
> controller. Its only purpose is to illustrate how such a driver would set the
> frequency of the external memory clock based on the bandwidth requirements of
> memory clients.

> diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c

> @@ -112,6 +117,11 @@ static void __init tegra_dt_init(void)
>   	parent = soc_device_to_device(soc_dev);
>
>   	/*
> +	 * HACK: register a platform device to probe the driver
> +	 */
> +	platform_device_register(&tegra_emc);

I don't think this is a hack, except for the bug: That should only 
happen on Tegra124 not on all Tegra SoCs.

Do you intend all 3 patches in this series to be merged? You'd mentioned 
you didn't when asked about this for a previous version. I'm not sure if 
that's changed?

To merge, I'd need Thierry's ack on patch 2, and Thierry's, Peter's, 
Mikko's, and/or Tuomas's on this patch.
