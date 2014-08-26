Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbaHZJIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:08:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46692 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaHZJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:08:13 -0400
Message-ID: <53FC4E77.2090205@collabora.co.uk>
Date: Tue, 26 Aug 2014 11:08:07 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>
CC: Yuvaraj Cd <yuvaraj.lkml@gmail.com>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC regulators
References: <CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com> <53F73472.8010609@collabora.co.uk> <20140822144531.GV24407@sirena.org.uk> <53F7838F.8060906@collabora.co.uk> <20140822183054.GY24407@sirena.org.uk> <53F7BDD8.7060500@collabora.co.uk> <CAD=FV=WC0h7fYm2QFqu3Zka7CsU4BtG-oyPpJav+ygC+gmCR+A@mail.gmail.com> <CA+NduCCT-KQ=gh7QWkBE4qkA2YOJ8KCVqbkC6Tkmb1aPvCsGFQ@mail.gmail.com> <53FAFCBC.2050407@collabora.co.uk> <CAD=FV=V4TSKsbjj3dXCdSzVrh3sxH-FkpFEbEo+JA1bN9R-XWA@mail.gmail.com> <20140826071721.GV17528@sirena.org.uk>
In-Reply-To: <20140826071721.GV17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 08/26/2014 09:17 AM, Mark Brown wrote:
> On Mon, Aug 25, 2014 at 08:40:40AM -0700, Doug Anderson wrote:
>> > Can you please test the following change [0] so I can post as a proper
>> > patch? Doug, Mark do you think that forcing the regulator to opmode normal
>> > when enabling is the right solution here?
> 
>> IMHO that makes sense.
> 
> No, this doesn't make any obvious sense to me at all.  Picking normal as
> a default if the hardware reads back off due to overlapping
> impelementation or something *might* make sense but not overwriting the
> hardware state without explicit permission from the machine integration
> is a key goal for the regulator API.
> 

Just to be sure I understood you correctly, what might makes sense to you
then is to set the opmode to normal as default on probe only if off is
read back from the hardware register but leaving the enable function as it
is now using the opmode set on probe?

That seems like a safer solution indeed since enable won't overwrite other
values different from off read from the hardware register, I'll prepare a
patch.

Thanks a lot for your help and best regards,
Javier
