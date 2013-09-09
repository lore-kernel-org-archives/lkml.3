Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3IIGPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:15:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17420 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3IIGPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:15:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 08 Sep 2013 23:12:38 -0700
Message-ID: <522D67B2.4030406@nvidia.com>
Date: Mon, 9 Sep 2013 14:16:18 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: "khali@linux-fr.org" <khali@linux-fr.org>
CC: Wei Ni <wni@nvidia.com>, "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] Lm90 Enhancements
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1375856306-14415-1-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jean
Do you have any more suggestions on this series?

Thanks.
Wei.

On 08/07/2013 02:18 PM, Wei Ni wrote:
> This patch set enhance the lm90 driver,
> it make the driver more readable and easier to use thermal framework.
> 
> This series is v4, previous version patches:
> [RFC]: http://thread.gmane.org/gmane.linux.power-management.general/31056
> [v1]: http://thread.gmane.org/gmane.linux.ports.tegra/11710/
> [v2]: http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg465555.html
> [v3]: http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg466772.html
> 
> Changes from v3:
> 1. remove the patch "hwmon: (lm90) split set&show temp as common codes",
> and sent it as a separated one.
> 2. fix the bug of second read on STATUS register.
> 3. fix some code style issue according to Jean's comments.
> 
> Changes from v2:
> 1. update the defines for status bit, and go into a separate patch.
> 2. introduce the new lm90_is_tripped() for lm90_irq_thread and lm90_alert.
> 
> Changes from v1:
> 1. change the string "irq" to "IRQ"
> 2. add macro defines for the alarm status
> 3. consider the shared IRQ.
> 
> Changes from RFC:
> 1. change _show_temp() to read_temp(), _set_temp() to write_temp().
> 2. simply return value for the read_temp(), not use pointer.
> 3. use devm_request_threaded_irq() to request irq and set flag IRQF_ONESHOT.
> 
> Wei Ni (3):
>   hwmon: (lm90) Define status bits
>   hwmon: (lm90) add support to handle IRQ
>   hwmon: (lm90) use enums for the indexes of temp8 and temp11
> 
>  drivers/hwmon/lm90.c |  252 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 163 insertions(+), 89 deletions(-)
> 

