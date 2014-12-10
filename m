Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaLJKHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:07:34 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41212 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaLJKHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:07:30 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a3-54881b60c9d9
Message-id: <1418206046.16644.26.camel@AMDC1943>
Subject: Re: [RFC PATCHv2 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Date: Wed, 10 Dec 2014 11:07:26 +0100
In-reply-to: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xq7oJ0h0hBnPahS0er1nMZLFxxnpW
	i+tfnrNazD9yjtWid8FVNouzTW/YLTY9vsZqcXnXHDaLz71HGC1mnN/HZHG7cQWbxeMVb9kt
	Vu36w+jA67Fz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZHRPyC54Z
	V/w+s4C5gfGzZhcjJ4eEgInEtr1/GSFsMYkL99azdTFycQgJLGWUaOv9zwrhfGaU+Ld/LxNI
	Fa+AgcSOhitACQ4OYYEMic53HiBhNgFjic3Ll7CB2CICGhIz/14BG8oscJ1J4s4NT5ByFgFV
	ic17kkHCnAJuEk27G1lAbCEBV4kPJ1rZIcrVJSbNW8QMUi4hoCzR2O8GsVRQ4sfkeywQJfIS
	m9e8ZZ7AKDALSccsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESGV93MC49
	ZnWIUYCDUYmHd4diW4gQa2JZcWXuIUYJDmYlEd43kh0hQrwpiZVVqUX58UWlOanFhxiZODil
	Ghgv6msnbmC4WPtIJWfrngJn8dPuSpMLJnQFypx6/LOYpbFg7rQ3257LaTlt5rrPWJWWGNS/
	b5Kfich5JdOYw9fcpLf+rZp+2GHPPS9hdhm7sGldDbtnX0jZ8SUw+kaY1lVjLs+DUyf89n26
	Z9H+Gb93zPB2ubQneS5jmrnCxsNLfh1Lspg/+fU+JZbijERDLeai4kQAS6LNO2oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-12-09 at 23:12 +0900, Chanwoo Choi wrote:
> This patchset add new devfreq_event class to provide raw data to determine
> current utilization of device  which is used for devfreq governor.
> 
> [Description of devfreq-event class]
> This patchset add new devfreq_event class for devfreq_event device which provide
> raw data (e.g., memory bus utilization/GPU utilization). This raw data from
> devfreq_event data would be used for the governor of devfreq subsystem.
> - devfreq_event device : Provide raw data for governor of existing devfreq device
> - devfreq device       : Monitor device state and change frequency/voltage of device
>                          using the raw data from devfreq_event device
> 
> The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
> for Non-CPU Devices. The devfreq device would dertermine current device state
> using various governor (e.g., ondemand, performance, powersave). After completed
> determination of system state, devfreq device would change the frequency/voltage
> of devfreq device according to the result of governor.
> 
> But, devfreq governor must need basic data which indicates current device state.
> Existing devfreq subsystem only consider devfreq device which check current system
> state and determine proper system state using basic data. There is no subsystem
> for device providing basic data to devfreq device.
> 
> The devfreq subsystem must need devfreq_event device(data-provider device) for
> existing devfreq device. So, this patch add new devfreq_event class for
> devfreq_event device which read various basic data(e.g, memory bus utilization,
> GPU utilization) and provide measured data to existing devfreq device through
> standard APIs of devfreq_event class.
> 
> The following description explains the feature of two kind of devfreq class:
> - devfreq class (existing)
>  : devfreq consumer device use raw data from devfreq_event device for
>    determining proper current system state and change voltage/frequency
>    dynamically using various governors.
> - devfreq_event class (new)
>  : Provide measured raw data to devfreq device for governor
> 
> Also, the devfreq-event device would support various type event as following:
>  : DEVFREQ_EVENT_TYPE_RAW_DATA
>  : DEVFREQ_EVENT_TYPE_UTILIZATION
>  : DEVFREQ_EVENT_TYPE_BANDWIDTH
>  : DEVFREQ_EVENT_TYPE_LATENCY
> 
> [For example]
> If board dts includes PPMU_DMC0/DMC1/CPU event node,
> would show following sysfs entry. Also devfreq driver(e.g., exynos4_bus.c)
> can get the instance of devfreq-event device by using provided API and then
> get raw data which reflect the current state of device.
> 

Hi,

Overall I like the idea. I understand that now devfreq devices (like
exynos devfreq) should bind themselves to buses, not to PPMU. It makes
sense to me because bus clock and bus voltage are properties of bus, not
monitoring unit.

I see that this is still a RFC so it would be hard to base current
devfreq work on top of it.

One more general comment: you're adding a some API which is not used by
current devfreq_event user (exynos). For example the exclusive flag or
event types. I think it will be simpler to stick to the basic approach
(reduced API). If some other user emerges then new API will be added.

Best regards,
Krzysztof


> -sh-3.2# pwd
> /sys/class/devfreq_event
> -sh-3.2# ls -al
> total 0
> drwxr-xr-x  2 root root 0 Jan  7 11:10 .
> drwxr-xr-x 37 root root 0 Jan  7 11:10 ..
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.0 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.0
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.1 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.1
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.2 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.2
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.3 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.3
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.4 -> ../../devices/soc/106b0000.ppmu_dmc1/devfreq_event/event.4
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.5 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.5
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.6 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.6
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.7 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.7
> lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.8 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.8
> 
> Changes from v1:
> - Code clean
> - Add the description of devfreq-event structure
> - Add 'is_enabled' function to devfreq_event_ops structure
> - Add 'enable_count' field to devfreq_event_dev structure
> - Check whether devfreq-event device is enabled or not
>   during calling devfreq_event API
> - Define the type of devfreq-event device as following
>   : DEVFREQ_EVENT_TYPE_RAW_DATA
>   : DEVFREQ_EVENT_TYPE_UTILIZATION
>   : DEVFREQ_EVENT_TYPE_BANDWIDTH
>   : DEVFREQ_EVENT_TYPE_LATENCY
> - Add the exclusive feature of devfreq-event device.
>   If devfreq-event device is used on only on devfreq driver,
>   should used 'devfreq_enable_event_dev_exclusive()' function
> - Add new patch6 for test on Exynos3250-based Rinato board
> 
> Chanwoo Choi (7):
>   devfreq: event: Add new devfreq_event class to provide basic data for devfreq governor
>   devfreq: event: Add the list of supported devfreq-event type
>   devfreq: event: Add the exclusive flag for devfreq-event device
>   devfreq: event: Add exynos-ppmu devfreq event driver
>   ARM: dts: Add PPMU dt node for Exynos3250
>   ARM: dts: Add PPMU dt node for Exynos4 SoC
>   ARM: dts: exynos: Add PPMU dt node to Exynos3250-based Rinato board
> 
>  arch/arm/boot/dts/exynos3250-rinato.dts |  55 +++++
>  arch/arm/boot/dts/exynos3250.dtsi       |  66 ++++++
>  arch/arm/boot/dts/exynos4.dtsi          |  96 ++++++++
>  arch/arm/boot/dts/exynos4210.dtsi       |   8 +
>  drivers/devfreq/Kconfig                 |  11 +
>  drivers/devfreq/Makefile                |   5 +-
>  drivers/devfreq/devfreq-event.c         | 363 ++++++++++++++++++++++++++++
>  drivers/devfreq/event/Makefile          |   2 +
>  drivers/devfreq/event/exynos-ppmu.c     | 409 ++++++++++++++++++++++++++++++++
>  include/linux/devfreq.h                 | 178 ++++++++++++++
>  10 files changed, 1192 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/devfreq/devfreq-event.c
>  create mode 100644 drivers/devfreq/event/Makefile
>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c
> 

