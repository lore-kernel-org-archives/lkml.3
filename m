Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKYQAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:00:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:56284 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaKYQA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:00:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,456,1413270000"; 
   d="scan'208";a="637856076"
Message-ID: <5474A78C.7030805@linux.intel.com>
Date: Tue, 25 Nov 2014 08:00:12 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, Ben Zhang <benzh@chromium.org>
CC: alsa-devel <alsa-devel@alsa-project.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <CACxGe6stjCvaQZkh=hFcF-56v5qJVar11jRZz0PRSd2wz6EUyA@mail.gmail.com>
In-Reply-To: <CACxGe6stjCvaQZkh=hFcF-56v5qJVar11jRZz0PRSd2wz6EUyA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/25/14 04:11, Grant Likely wrote:
> On Sat, Nov 15, 2014 at 6:56 AM, Ben Zhang <benzh@chromium.org> wrote:
>> The rt5677 codec driver looks for ACPI device ID "RT5677CE",
>> which is specified in coreboot. This patch allows platform
>> data to be obtained via ACPI
>>
>> Signed-off-by: Ben Zhang <benzh@chromium.org>
> 
> This looks like an ideal time to talk about shared DT and ACPI driver
> bindings. This driver /already/ has a firmware binding. It is
> documented in the kernel under
> Documentation/bindings/sound/rt5677.txt. We now have a standard method
> for sharing bindings between DT and ACPI in the _DSD method[1].
> Support for DSD is in linux-next and getting merged into v3.19. This
> is exactly the case that _DSD should be used for passing additional
> data to the driver, and it should use the existing binding.
> 
> [1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> For a long time we've had the rule on DT that new bindings must be
> documented before we merge a patch. That rule I think has been a good
> one, even if it is a little chaoitc. I think when it comes to ACPI
> drivers that we should be requiring the same: Document the binding,
> either in the kernel as a DT binding, or point to somewhere else that
> has the binding documented.
> 
> Also, since this patch is targeted at v3.19 or later, the
> device-properties API should be used. Don't create something custom.

Right. The ACPI/UEFI forum is managing the creation of new DSD bindings
and ensuring they are documented online. I believe this is the... 3rd so
far? So we're still optimizing the process. But yes, please, send the
schema itself for review and let's get this documented and migrated over
to _DSD.

-- 
Darren Hart
Intel Open Source Technology Center
