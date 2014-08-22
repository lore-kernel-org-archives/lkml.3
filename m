Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaHVWCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:02:11 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44797 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHVWCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:02:09 -0400
Message-ID: <53F7BDD8.7060500@collabora.co.uk>
Date: Sat, 23 Aug 2014 00:02:00 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Yuvaraj Cd <yuvaraj.lkml@gmail.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC regulators
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk> <1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk> <CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com> <53F73472.8010609@collabora.co.uk> <20140822144531.GV24407@sirena.org.uk> <53F7838F.8060906@collabora.co.uk> <20140822183054.GY24407@sirena.org.uk>
In-Reply-To: <20140822183054.GY24407@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 08/22/2014 08:30 PM, Mark Brown wrote:
> 
>> The problem is that one of these regulators is used as the vqmmc-supply
>> (VCCQ/VDD_IO) so the mmc host controller driver disables it on
>> MMC_POWER_OFF. Now AFAIK (Yuvaraj can correct me what I got wrong) this
>> shouldn't be an issue since on card detection, the vqmmc supply should be
>> enabled again but on Exynos the built-in card detect line is on the same
>> power rail as vqmmc. That means that disabling the regulator prevents card
>> insertions to be detected.
> 
> If the MMC host controller needs a supply enabling in order to do card
> detection and it's supposed to be doing card detection I'd expect it to
> be enabling that supply.  Why is it not doing that?
> 

Good question. I'm not that familiar with the dw_mmc host controller nor
its driver implementation so I'll let Yuvaraj or Doug to answer that.

Best regards,
Javier
