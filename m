Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaKYOaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:30:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:17512 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaKYOaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:30:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,455,1413270000"; 
   d="scan'208";a="643238681"
Message-ID: <1416925686.7260.28.camel@loki>
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
From: Liam Girdwood <liam.r.girdwood@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Ben Zhang <benzh@chromium.org>, Oder Chiou <oder_chiou@realtek.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Anatol Pomozov <anatol@google.com>,
        Bard Liao <bardliao@realtek.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com
Date: Tue, 25 Nov 2014 14:28:06 +0000
In-Reply-To: <CACxGe6stjCvaQZkh=hFcF-56v5qJVar11jRZz0PRSd2wz6EUyA@mail.gmail.com>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
	 <CACxGe6stjCvaQZkh=hFcF-56v5qJVar11jRZz0PRSd2wz6EUyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 12:11 +0000, Grant Likely wrote:
> On Sat, Nov 15, 2014 at 6:56 AM, Ben Zhang <benzh@chromium.org> wrote:
> > The rt5677 codec driver looks for ACPI device ID "RT5677CE",
> > which is specified in coreboot. This patch allows platform
> > data to be obtained via ACPI
> >
> > Signed-off-by: Ben Zhang <benzh@chromium.org>
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
> 

My sentiments exactly, there would be little point having bespoke device
properties for every single device. Btw, we also need to align here with
Windows too !

Liam


