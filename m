Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaHFTuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:50:35 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:43988 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbaHFTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:50:33 -0400
MIME-Version: 1.0
In-Reply-To: <2f6ac51155f9d34791b274b5102d15a997ff8b99.1396384101.git.stefan@agner.ch>
References: <cover.1396384101.git.stefan@agner.ch>
	<2f6ac51155f9d34791b274b5102d15a997ff8b99.1396384101.git.stefan@agner.ch>
Date: Wed, 6 Aug 2014 12:50:31 -0700
X-Google-Sender-Auth: hmNGN6NQAnPoZg8OcyzYu2VFcX8
Message-ID: <CAD=FV=Va=V4xGqQM9kMFFdQDyYNWDEh_cXJW=b3iYGRrJiH9DQ@mail.gmail.com>
Subject: Re: [RFC 2/2] mmc: use SD/MMC host ID for block device name ID
From: Doug Anderson <dianders@chromium.org>
To: stefan@agner.ch, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

On Tue, Apr 1, 2014 at 1:35 PM,  <stefan@agner.ch> wrote:
> From: Stefan Agner <stefan@agner.ch>
>
> By using the SD/MMC host device ID as a starting point for block
> device numbering, one can reliably predict the first block device
> name (at least for the first controller). This is especially useful
> for SoCs with multiple SD/MMC host controller, where the controller
> with index 0 is connected to a eMMC device.
>
> Usually the first controller gets the first block device name ID,
> however this is not guaranteed. Also if the first controller is
> aliased as second controller and visa-versa (using device tree
> aliases), the block device name ID assignation is not ordered by
> the SD/MMC host device ID (since mmc_rescan is called in order of
> the memory mapped pheripherial addresses).
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/mmc/card/block.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

As Stephen points out, "mmcblk" IDs for SD cards are not actually
guaranteed.  Also UUID is a better API for things to use.

That being said, your patch helps me a lot when doing development.  As
you said, I'm guaranteed that if eMMC is no-removable and enumerated
at boot that it will be a predictable ID and I can use it in my
scripts.  Also this helps keep me from having to do lots of extra
thinking to figure out whether I happened to have an SD card plugged
in at boot or I didn't.

I'd love to see this land.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
