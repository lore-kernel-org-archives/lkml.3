Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbaGONVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:21:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59440 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731AbaGONVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:21:01 -0400
Message-ID: <53C52A73.8010307@gmail.com>
Date: Tue, 15 Jul 2014 18:49:47 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
CC: t.figa@samsung.com, m.szyprowski@samsung.com, linux@roeck-us.net,
        tklauser@distanz.ch, linux-pwm@vger.kernel.org
Subject: Re: [PATCH v3] hwmon: pwm-fan: Add pwm-fan driver
References: <1405425092-553-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1405425092-553-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 05:21 PM, Kamil Debski wrote:
> The pwm-fan driver enables control of fans connected to PWM lines.
> This driver uses the PWM framework, so it is compatible with all
> PWM devices that provide drivers through the PWM framework.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
> Changes since v2:
> - add CONFIG_PM_SLEEP around pwm_fan_suspend and pwm_fan_resume
> Changes since v1:
> - added documentation to Documentation/hwmon
> - fix checkpatch errors
> 	- added extra description to Kconfig
> 	- removed whitespace errors
> - include files rearranged to be in alphabetical order
> - remove unused sysfs entry pwm1_enable
> - changed the behavior of the set_pwm function
> 	- when 0 PWM value is set pwm_disable is run
> 	- pwm_config return value is checked for errors
> - use of ATTRIBUTE_GROUPS was added
> - removed "Not enouch memory" error message
> - fixed probe return value in case of devm_of_pwm_get error
> - changed hwmon_device_register_with_groups to
>    devm_hwmon_device_register_with_groups
> - changes suspend/resume to use pwm_disable/enable
> - removed unnecessary CONFIG_PM_SLEEP ifdefs
> ---
>   .../devicetree/bindings/hwmon/pwm-fan.txt          |   12 ++
>   Documentation/hwmon/pwm-fan                        |   17 ++
>   drivers/hwmon/Kconfig                              |   11 ++
>   drivers/hwmon/Makefile                             |    1 +
>   drivers/hwmon/pwm-fan.c                            |  201 ++++++++++++++++++++
>   5 files changed, 242 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/hwmon/pwm-fan.txt
>   create mode 100644 Documentation/hwmon/pwm-fan
>   create mode 100644 drivers/hwmon/pwm-fan.c
>
> diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> new file mode 100644
> index 0000000..f534607
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> @@ -0,0 +1,12 @@
> +Bindings for a fan connected to the PWM lines
> +
> +Required properties:
> +- compatible: "pwm-fan"
> +- pwms: the PWM that is used to control the PWM fan
>
It would be more readable if it like this...
Required properties:
- compatible		: should be "pwm-fan"
- pwms			: The PWM that is used to control the PWM fan




-- 
Regards,
Varka Bhadram.

