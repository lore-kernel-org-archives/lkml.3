Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbaHVRx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:53:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44699 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaHVRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:53:25 -0400
Message-ID: <53F7838F.8060906@collabora.co.uk>
Date: Fri, 22 Aug 2014 19:53:19 +0200
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
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk> <1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk> <CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com> <53F73472.8010609@collabora.co.uk> <20140822144531.GV24407@sirena.org.uk>
In-Reply-To: <20140822144531.GV24407@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 08/22/2014 04:45 PM, Mark Brown wrote:
> On Fri, Aug 22, 2014 at 02:15:46PM +0200, Javier Martinez Canillas wrote:
> 
>> Mark, any opinions on how this should be solved will be highly appreciated.
> 
> If someone could tell me what "this" is that'd help...
> 

Sorry for not being clear on that regard. By "this" I meant the problem
reported by Yuvaraj.

The regulators operating mode is read from the hardware registers on probe
as you suggested but that means that if the regulator is disabled and the
machine rebooted (warm reset) the opmode reported by the hardware is
MAX77802_OPMODE_OFF.

The problem is that one of these regulators is used as the vqmmc-supply
(VCCQ/VDD_IO) so the mmc host controller driver disables it on
MMC_POWER_OFF. Now AFAIK (Yuvaraj can correct me what I got wrong) this
shouldn't be an issue since on card detection, the vqmmc supply should be
enabled again but on Exynos the built-in card detect line is on the same
power rail as vqmmc. That means that disabling the regulator prevents card
insertions to be detected.

This does not happen on the downstream Chrome OS kernel because the
max77802 regulator driver has some ad-hoc DT bindings were you can define
the operating mode to be set on probe. For this particular regulator is
MAX77802_OPMODE_STANDBY.

Yuvaraj solution was to set the operating mode to MAX77802_OPMODE_NORMAL
on probe() which was what I did on a previous version of the driver but
you explained to me that it was not safe to do that.

That's why I'm asking for suggestions.

Thanks a lot and best regards,
Javier

