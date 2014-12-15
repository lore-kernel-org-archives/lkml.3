Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaLOOxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:53:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26832 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaLOOxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:53:11 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-97-548ef5d313e2
Content-transfer-encoding: 8BIT
Message-id: <1418655186.20866.5.camel@AMDC1943>
Subject: Re: [RFC PATCHv3 1/7] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Date: Mon, 15 Dec 2014 15:53:06 +0100
In-reply-to: <1418372852-12454-2-git-send-email-cw00.choi@samsung.com>
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
 <1418372852-12454-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xK7qXv/aFGNz6amHxeM1iJouNM9az
	Wlz/8pzVYv6Rc6wWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+JovbjSvYLB6veMtu
	sWrXH0YHXo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DK+PhiNVvB
	d/GKB/viGhh3C3cxcnJICJhIrH90kBnCFpO4cG89WxcjF4eQwFJGiQ/NC1hBErwCghI/Jt9j
	6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6z4wSPWu/Q9XrS3R+mcgEYgsLlEuc+zwXLM4mYCyx
	efkSNhBbREBDYubfK4wgzcwC15kkei4eBGtgEVCV6Fu/BqyBU8BN4vat71AbGhkl5ty6xQ5y
	hYSAskRjv9sERoFZSO6bhXDfLCT3LWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREh1f
	djAuPmZ1iFGAg1GJhzdhb2+IEGtiWXFl7iFGCQ5mJRHeWe/6QoR4UxIrq1KL8uOLSnNSiw8x
	MnFwSjUwuugZFTwLr1BhuPuoJeTOukjN3NPP9n2d0sFTPj/QTCVD8J0kp6dtQ222ciVDUyvH
	/6MG30K/eVZmbprcVqfs88RQqfV27eKkboEY3z73Fa29LCFq0x8VS7zkD35U1rh7S9WvhRcU
	OI6fi8qcfeujwqO8S+qcp7UuFm9ekv3Ib4/A64jPz04psRRnJBpqMRcVJwIAoEGosGwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-12-12 at 17:27 +0900, Chanwoo Choi wrote:
> This patch add new devfreq_event class for devfreq_event device which provide
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
> 
> - devfreq_event class (new)
>  : Provide measured raw data to devfreq device for governor
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

[...]

> +/**
> + * devfreq_event_get_event() - Get event and total_event from devfreq-event dev.
> + * @edev	: the devfreq-event device
> + *
> + * Note that this function get the calculated event data from devfreq-event dev
> + * after stoping the progress of whole sequence of devfreq-event dev. Return
> + * current event data and total_event should be stored in second parameter
> + * (total_event).
> + */
> +u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
> +{

I think this function should return int (0 for success, negative
otherwise) and store the "event" under pointer passed as argument.
Why? Because:
1. error conditions are indicated with 'return 0' but should be 'return
-EINVAL'
2. Exynos-ppmu driver returns -EINVAL.
Checking for error conditions is in such case more complex than it
should.


Best regards,
Krzysztof


