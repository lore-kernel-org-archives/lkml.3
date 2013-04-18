Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3DRTR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:17:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57412 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3DRTRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:17:24 -0400
Message-ID: <517046B8.6000900@ti.com>
Date: Fri, 19 Apr 2013 00:47:12 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCH 0/6] Serial Omap fixes and cleanups
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com> <87mwsv3dgk.fsf@linaro.org>
In-Reply-To: <87mwsv3dgk.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Thursday 18 April 2013 11:53 PM, Kevin Hilman wrote:
> Hi Sourav,
>
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> Hi,
>>
>> This patch series contains fixes and cleanups around the issue that
>> the console UART should not idled on suspend while using "no_console_suspend"
>> in bootargs.
>>
> The direction of the series is right, thanks for the updated approach.
> I had a comple minor comments on specific patches, but the ordering of
> the series needs a little tweaking.  It should be
>
> - core/driver changes [current 1-3/6 are ok]
> - remove usage from mach-omap2/serial.c (currently part of 4/6)
> - remove am33x DT usage (current 5/6 is ok)
> - remove entirely from omap_device (omap_device part of 4/6 and 6/6 should be combined)
>
Thanks a lot for your review and comments.
I have replied to your comments on the respective patches.
Will take care of the "ordering" which you mentioned above
in the next version.

Thanks
Sourav
> Kevin
>
>> The approach thought of is to modify the serial core/serial driver to bypass
>> runtime PM if the UART in contention is a console and we are using "no_console_suspend"
>> in our bootargs.
>>
>> While fixing the above issue, there are other cleanups also done as part of
>> this series which are no longer required. This cleanups mainly include getting
>> rid of using "omap_device_disable_idle_on_suspend" api for both dt and non dt case
>> as the serial driver will be self sufficient to handle the "no_idle_on_suspend" issue.
>> Serial was the only one making use of "omap_device_disable_idle_on_suspend"
>>
>> Test info (except drivers: serial: mpc52xx_uart: Remove "uart_console" defintion):
>> Omap4430sdp:
>> - Tested wakeup from UART after suspend for dt and non dt case.
>> Omap5430evm:
>> - Tested wakeup from UART after suspend for dt case.
>>
>>
>> There were discussions about how to handle "no_idle_on_suspend" issue and all the
>> discussions are as follows:
>> [v3]: https://lkml.org/lkml/2013/4/5/239
>> [v2]: https://lkml.org/lkml/2013/4/2/350
>> [v1]: https://lkml.org/lkml/2013/3/18/199
>>        https://lkml.org/lkml/2013/3/18/295
>> Due to the amount of change in approach and other cleanups coming around it, I am posting
>> this as a new series.
>>
>> This patches are based on 3.9-rc3 custom tree which has
>> Santosh Shilimkar serial patch[1]
>> [1]: http://permalink.gmane.org/gmane.linux.ports.arm.omap/95828
>>
>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Felipe Balbi<balbi@ti.com>
>> Cc: Rajendra nayak<rnayak@ti.com>
>>
>> Sourav Poddar (6):
>>    drivers: tty: serial: Move "uart_console" def to core header file.
>>    drivers: serial: mpc52xx_uart: Remove "uart_console" defintion
>>    driver: serial: omap: add prepare/complete callback for
>>      "no_console_suspend" case
>>    arm: mach-omap2: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check
>>    arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
>>    arm: mach-omap2: Remove "no_console_suspend"
>>
>>   arch/arm/boot/dts/am33xx.dtsi     |    1 -
>>   arch/arm/mach-omap2/omap_device.c |   10 +---------
>>   arch/arm/mach-omap2/serial.c      |    7 -------
>>   drivers/tty/serial/mpc52xx_uart.c |   10 ----------
>>   drivers/tty/serial/omap-serial.c  |   20 ++++++++++++++++++++
>>   drivers/tty/serial/serial_core.c  |    6 ------
>>   include/linux/serial_core.h       |    6 ++++++
>>   7 files changed, 27 insertions(+), 33 deletions(-)

