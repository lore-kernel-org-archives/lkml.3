Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3HHRED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:04:03 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9681 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3HHRD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:03:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Aug 2013 10:03:58 -0700
Message-ID: <5203D2BE.1010807@nvidia.com>
Date: Thu, 8 Aug 2013 22:47:50 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH V4] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
References: <1375871392-871-1-git-send-email-ldewangan@nvidia.com> <20130807163804.GL28558@e106331-lin.cambridge.arm.com> <520295F3.2020401@nvidia.com> <20130808093340.GG14648@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130808093340.GG14648@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 August 2013 03:03 PM, Mark Rutland wrote:
> On Wed, Aug 07, 2013 at 07:46:11PM +0100, Laxman Dewangan wrote:
>>> What happens if we charge at the wrong current?
>> Not much sure but I think it can create battery damage.
> If we charge a battery supporting >100mA at a current <100mA, will that
> cause damage? Or only if we charge above it's supported current?

Over-current charging can only damage. Lower charging current will not 
damage, just will take more time to charge.

>
> If the latter's true, it might make sense to invert the condition and
> describe that the battery may be charged at a higher current, with the
> default being <100mA. That way a missing property in the dt will only
> result in sub-optimal charging rather than battery damage.
>
Ok, fine with this. In this case property will be 
"ti,backup-battery-charge-high-current".


