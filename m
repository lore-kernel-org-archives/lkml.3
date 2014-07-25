Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaGYPIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:08:31 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:64269 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaGYPI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <08fe01cfa7c9$341cc700$9c565500$@samsung.com>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-2-git-send-email-afaerber@suse.de>
	<08fe01cfa7c9$341cc700$9c565500$@samsung.com>
Date: Fri, 25 Jul 2014 08:08:27 -0700
X-Google-Sender-Auth: pK5xi1BXf5dpBEGpsbIWYop0QvE
Message-ID: <CAD=FV=VUkU7HWjwCKO=WOrKosUtmv3YE_8pxc5uoQg0cHr-AKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: dts: exynos5250: max77686 is Snow only
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 24, 2014 at 10:28 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Andreas Färber wrote:
>>
>> Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
>> Spring does not need it, it uses an s5m8767 instead.
>>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>
> Hi Andreas,
>
> I think this should be reviewed by chrome guys.
>
>
> Doug, can you have a look this series for exynos5250-chromebook?
> I'm not sure exynos5250-cros-common is still useful for exynos5250-spring...

Sorry, I've been on vacation and am now playing catchup.

Right.  The current suggestion is to rework to just duplicate things
and don't use exynos5250-cros-common.  I would structure the series
as:

1. Fold the current exynos5250-cros-common directly into the snow
device tree file.

2. If desired, cleanup the snow device tree file.

3. Create the spring device tree file based on snow.  There will be
duplication, but so be it.  Please try to minimize diffs between the
snow ad spring device tree files.

4. If possible, identify "fragments" like "cros-ec-keyboard.dtsi" and
factor them out of both spring and snow device tree files.


You could certainly reorder some of the above steps if you wish (you
could split out fragments before creating the spring device tree, for
instance).


Please make sure to CC Javier (now on CC) since he's helping with
Chromebook upstreaming and he may have a lower latency in responding
than I do.

-Doug
