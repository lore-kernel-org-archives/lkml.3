Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaLIKEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:04:23 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45617 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbaLIKEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:04:20 -0500
Date: Tue, 9 Dec 2014 10:04:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 04/19] mfd: max77693: adjust
 max77693_led_platform_data
Message-ID: <20141209100413.GW3951@x1>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-5-git-send-email-j.anaszewski@samsung.com>
 <20141209085047.GR3951@x1>
 <5486BC44.7010602@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5486BC44.7010602@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2014, Jacek Anaszewski wrote:

> On 12/09/2014 09:50 AM, Lee Jones wrote:
> >On Wed, 03 Dec 2014, Jacek Anaszewski wrote:
> >
> >>Add "label" array for Device Tree strings with the name of a LED device
> >>and make flash_timeout a two element array, for caching the sub-led
> >>related flash timeout. Added is also an array for caching pointers to the
> >>sub-nodes representing sub-leds.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Chanwoo Choi <cw00.choi@samsung.com>
> >>Cc: Lee Jones <lee.jones@linaro.org>
> >>---
> >>  include/linux/mfd/max77693.h |    4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> >>index f0b6585..c80ee99 100644
> >>--- a/include/linux/mfd/max77693.h
> >>+++ b/include/linux/mfd/max77693.h
> >>@@ -88,16 +88,18 @@ enum max77693_led_boost_mode {
> >>  };
> >>
> >>  struct max77693_led_platform_data {
> >>+	const char *label[2];
> >>  	u32 fleds[2];
> >>  	u32 iout_torch[2];for_each_available_child_of_node
> >>  	u32 iout_flash[2];
> >>  	u32 trigger[2];
> >>  	u32 trigger_type[2];
> >>+	u32 flash_timeout[2];
> >>  	u32 num_leds;
> >>  	u32 boost_mode;
> >>-	u32 flash_timeout;
> >>  	u32 boost_vout;
> >>  	u32 low_vsys;
> >>+	struct device_node *sub_nodes[2];
> >
> >I haven't seen anyone do this before.  Why can't you use the provided
> >OF functions to traverse through your tree?
> 
> I use for_each_available_child_of_node when parsing DT node, but I
> need to cache the pointer to sub-node to be able to use it later
> when it needs to be passed to V4L2 sub-device which is then
> asynchronously matched by the phandle to sub-node.
> 
> If it is not well seen to cache it in the platform data then
> I will find different way to accomplish this.

I haven't seen the end-driver for this, but why can't you use that
device's of_node pointer?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
