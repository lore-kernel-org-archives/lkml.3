Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaGNOZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:25:34 -0400
Received: from sym2.noone.org ([178.63.92.236]:48106 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbaGNOZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:25:29 -0400
Date: Mon, 14 Jul 2014 16:25:25 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Kamil Debski <k.debski@samsung.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, t.figa@samsung.com,
        m.szyprowski@samsung.com, linux@roeck-us.net,
        linux-pwm@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: pwm-fan: Add pwm-fan driver
Message-ID: <20140714142525.GB7668@distanz.ch>
References: <1405345835-17089-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405345835-17089-1-git-send-email-k.debski@samsung.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-14 at 15:50:35 +0200, Kamil Debski <k.debski@samsung.com> wrote:
> The pwm-fan driver enables control of fans connected to PWM lines.
> This driver uses the PWM framework, so it is compatible with all
> PWM devices that provide drivers through the PWM framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
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
>   devm_hwmon_device_register_with_groups
> - changes suspend/resume to use pwm_disable/enable
> - removed unnecessary CONFIG_PM_SLEEP ifdefs

pwm_fan_suspend and pwm_fan_resume should still be enclosed in #ifdef
CONFIG_PM_SLEEP, otherwise you'll get 'defined but not used' compiler
warnings when building without CONFIG_PM being set.

Cheers
Tobias
