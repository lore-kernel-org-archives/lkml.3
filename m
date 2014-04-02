Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbaDBKSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:18:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42214 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbaDBKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:18:48 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-53-533be4055326
Message-id: <533BE3FD.8070902@samsung.com>
Date: Wed, 02 Apr 2014 12:18:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <20140331200620.GA13881@kroah.com> <533ABCEC.8040701@codethink.co.uk>
 <533ACBD0.8030209@samsung.com> <20140401163744.GE3842@kroah.com>
In-reply-to: <20140401163744.GE3842@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xa7qsT6yDDdasEbF4cKuVyWL+kXOs
	Fv1vFrJaHPizg9GiefF6NouzTW/YLTonLmG32PT4GqvF5V1z2CxuX+a1WHvkLrvF0usXmSye
	TrjIZtG69wi7xd/tm1gsZkx+yWaxfsZrFgdBjzXz1jB6tDT3sHlc7utl8nj2cjKTx+yOmawe
	m1Z1snncubaHzWP/3DXsHpuX1Hv0/zXw6NuyitHj8ya5AJ4oLpuU1JzMstQifbsEroyuqWdZ
	Cq5LVlw8/ZapgXGqSBcjJ4eEgInEt2MbWCBsMYkL99azdTFycQgJLGWUaN6wnxXC+cQosfX7
	byaQKl4BLYm55/8ygtgsAqoSD/o3s4LYbAKGEr1H+8DiogIREvcaD7NC1AtK/Jh8D2yDiICG
	xMujt1hAhjILbGeW+Pj+KViDsEC0xJmGjcwQ2/qYJHYe38oOkuAU0JPYO3MVG4jNLKAjsb91
	GpQtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQuLx
	yw7GxcesDjEKcDAq8fBKXLIKFmJNLCuuzD3EKMHBrCTCK/TYOliINyWxsiq1KD++qDQntfgQ
	IxMHp1QDY40/q77kt8lsSqZhdkEpt+59sft7SGXZt7DkwnsmdyYxbBR6aJ37rOr70w37Wq8U
	/2q9PunEy68dD7QEmKOSF4sd+HNh7SbjYi0hvn2rtSJUJtTyq4SmLbqqs+RM98XfXbc/qalV
	9Fw4lBhxjHvl9v0Hznem7jK89jhZYPaemf9bLnN1GKz/HaTEUpyRaKjFXFScCABV6fm+pQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/14 18:37, Greg KH wrote:
> On Tue, Apr 01, 2014 at 04:23:12PM +0200, Sylwester Nawrocki wrote:
>> On 01/04/14 15:19, Ben Dooks wrote:
>>> On 31/03/14 21:06, Greg KH wrote:
>>>>> On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
>> [...]
>>>>> I don't understand why you need the driver core to initialize this one
>>>>> type of thing?  That should be in a driver, or in a class, or at worse
>>>>> case, the platform code.
>>>>>
>>>>> What makes clocks so "unique" here?
>>
>> The reason I put it in the driver core was mainly to avoid having many
>> drivers doing same call to this initialization function.
>> I was considering moving it to the bus code, still there are several
>> buses for which it would need to be repeated.
> 
> "several" is how many?  2?  3?  10?

It would be mostly the platform and amba bus, but this clock defaults
could be useful also for i2c, spi. In general it's about not probable
devices which may be specified in devicetree.

> Please fix it "correctly" and don't put it in the driver core just
> because it seems easier that way.
> 
>> Maybe really_probe() is not a best place to put this, nonetheless
>> the requirements I could list were:
>>
>>  1. not involving individual drivers,
> 
> Why not?

I'd say because this thing can be often considered a platform detail
which would be better opaque to drivers. It's at the border of a device
and its integration within a platform.

>>  2. have such an initialization call done for all devices, irrespective
>>     of Linux bus or class type,
> 
> Why?  Do _all_ devices that Linux supports have this issue to be
> resolved?

Sorry, certainly not all devices. I think it's only related to the
non-probable devices which can be specified in DT.

>>  3. Handle errors properly, e.g. defer driver probing if a clock for
>>    a device is not yet available.
> 
> Then do it in the bus that controls that device, as it knows to defer
> probing at that point in time.

All right, that would also work. I suspect doing it for platform and
amba bus might be sufficient in the beginning.

>> One advantage I could see from making the call from within a device
>> driver is that a device could keep using the common DT bindings and
>> replace the common initialization function with a private one, if
>> there is a need for some quirks handled for a device. With approach
>> as in this patch it's difficult to override the default behaviour.
>> However then there is a question whether we strive for the clocks
>> management to be possibly kept away from device drivers.
>>
>>> I suppose the issue here is that a lot of drivers currently use
>>> clocks and a number of systems have badly setup default clock trees
>>> at start time.
>>>
>>> Mark Brown and others have argued that the management of clocks which
>>> is common to all devices should not live in the driver.
>>
>> True, motivation behind this patch series was also replacing custom
>> code in multiple drivers doing similar clock rate or parent setting
>> by a common code, using standardized DT binding.
> 
> Then put it in the bus that controls these broken devices / platforms.

OK, I'm going to put it in the bus code.

-- 
Thanks,
Sylwester
