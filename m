Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902Ab3EBVvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:51:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:56903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3EBVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:51:09 -0400
Message-ID: <5182DFA3.3040707@infradead.org>
Date: Thu, 02 May 2013 14:50:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Simon Wood <simon@mungewell.org>
CC: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-steelseries fix led class build issue
References: <51816271.3040400@infradead.org> <1367476041-25760-1-git-send-email-simon@mungewell.org>
In-Reply-To: <1367476041-25760-1-git-send-email-simon@mungewell.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/13 23:27, Simon Wood wrote:
> Fixes 'undefined reference' issue when hid-steelseries is built in,
> but led-class is a module.
> --
> drivers/built-in.o: In function `steelseries_srws1_remove':
> hid-steelseries.c:(.text+0x3b97a1): undefined reference to `led_classdev_unregister'
> drivers/built-in.o: In function `steelseries_srws1_probe':
> hid-steelseries.c:(.text+0x3b9c51): undefined reference to `led_classdev_register'
> hid-steelseries.c:(.text+0x3b9ce5): undefined reference to `led_classdev_register'
> hid-steelseries.c:(.text+0x3b9d4b): undefined reference to `led_classdev_unregister'
> --
> 
> Patch allows LED control when led-class is built in, or both hid-steelseries
> _and_ led-class are both modules.

OK, that builds.  Thanks.

Missing lines:  your Signed-off-by:
and
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  drivers/hid/hid-steelseries.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-steelseries.c b/drivers/hid/hid-steelseries.c
> index 2ed995c..dbd5e2e 100644
> --- a/drivers/hid/hid-steelseries.c
> +++ b/drivers/hid/hid-steelseries.c
> @@ -19,7 +19,8 @@
>  #include "usbhid/usbhid.h"
>  #include "hid-ids.h"
>  
> -#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> +#if defined(CONFIG_LEDS_CLASS) || \
> +    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_HID_STEELSERIES_MODULE))
>  #define SRWS1_NUMBER_LEDS 15
>  struct steelseries_srws1_data {
>  	__u16 led_state;
> @@ -108,7 +109,8 @@ static __u8 steelseries_srws1_rdesc_fixed[] = {
>  0xC0                /*  End Collection                      */
>  };
>  
> -#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> +#if defined(CONFIG_LEDS_CLASS) || \
> +    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_HID_STEELSERIES_MODULE))
>  static void steelseries_srws1_set_leds(struct hid_device *hdev, __u16 leds)
>  {
>  	struct list_head *report_list = &hdev->report_enum[HID_OUTPUT_REPORT].report_list;
> @@ -371,7 +373,8 @@ MODULE_DEVICE_TABLE(hid, steelseries_srws1_devices);
>  static struct hid_driver steelseries_srws1_driver = {
>  	.name = "steelseries_srws1",
>  	.id_table = steelseries_srws1_devices,
> -#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> +#if defined(CONFIG_LEDS_CLASS) || \
> +    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_HID_STEELSERIES_MODULE))
>  	.probe = steelseries_srws1_probe,
>  	.remove = steelseries_srws1_remove,
>  #endif
> 


-- 
~Randy
