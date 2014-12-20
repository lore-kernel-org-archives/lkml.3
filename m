Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaLTTBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 14:01:07 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:53315 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaLTTBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 14:01:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Kevin Hilman <khilman@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Heiko Stuebner <heiko@sntech.de>,
        Joerg Roedel <joro@8bytes.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
Date: Sat, 20 Dec 2014 21:01:06 +0200
Message-ID: <3922440.p7KFeqxHrO@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <8712967.RZO6JKCTcJ@vostro.rjw.lan>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org> <1649547.QECLmuJenN@avalon> <8712967.RZO6JKCTcJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Friday 19 December 2014 03:27:35 Rafael J. Wysocki wrote:
> On Thursday, December 18, 2014 11:28:58 PM Laurent Pinchart wrote:
> > Hi Kevin,
> 
> [cut]
> 
>>>>> It would be better to be able to reference count the DMA engine from
>>>>> the bus master IMO and arguably you can use the runtime PM framework
>>>>> for that. Namely, give bus masters someting like
>>>>> 
>>>>> 	pm_runtime_get_my_DMA_engine(bus_master_device)
>>>>> 	pm_runtime_put_my_DMA_engine(bus_master_device)
>>>>> 
>>>>> and let them call these as they see fit.
>>>> 
>>>> Please note that we're not talking about DMA engines here, but about
>>>> IOMMUs. DMA is involved through the DMA mapping API which hides the
>>>> IOMMU completely from the bus master drivers, not the DMA engine API.
>>>> 
>>>> Exposing the IOMMU is something we want to avoid, but DMA mapping
>>>> start/stop operations could certainly be implemented.
>>> 
>>> The problem with that is it only solves the IOMMU problem.  We have a
>>> more generic PM dependency problem of which this IOMMU example is only a
>>> subset, so I think we need a more generic solution.
>> 
>> I agree that a more generic solution is needed at least to support ACPI
>> _DEP, but that might not be optimal in the IOMMU use case as explained
>> above.
>
> Well, since we need it anyway, why don't we implement it and then figure out
> if anything more specific needs to be done for the IOMMU case?

Patches are welcome ;-)

-- 
Regards,

Laurent Pinchart

