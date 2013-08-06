Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3HFWbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:31:24 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:39062 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3HFWbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:31:22 -0400
X-AuditID: cbfec37d-b7f036d000004805-5d-5201793998b2
From: Shuah Khan <shuah.kh@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-topic: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-index: Ac6SyFcWUhE6FBeWT/iSf5cAZjp8ng==
Date: Tue, 06 Aug 2013 22:31:19 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6175A7D0@sisaex02sj>
References: <Pine.LNX.4.44L0.1308061719440.930-100000@iolanthe.rowland.org>
 <B8EFE96D1287C24090BAD9D858E15E6175A68C@sisaex02sj>
 <16202005.zAo69g0VlB@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9hP13LSsYgg51tBhaXd81hs7h76iib
	Rf/CXiaLCb8vsDmweMy++4PR49HiFkaPFau/s3t83iQXwBLFZZOSmpNZllqkb5fAlbHt7WL2
	grOCFc8vz2RpYJzL18XIwSEhYCLxq1+li5ETyBSTuHBvPVsXIxeHkMAyRonutlusEE4vk8TJ
	vrfMEM58Ronvf86wgrSwCahLfH69gx3EFhFQldjy5D87SBGzwHpGienTfjKDJIQFHCVOLvvN
	ClHkJPHw4GmoBj2Jx7OmsICcwQLU/PqqGUiYV8BeomFuBzvEshVAc3bOZgRJMALd9/3UGiYQ
	m1lAXKK59SYLxN0CEkv2nGeGsEUlXj7+xwrxmqLE9tVWEOVaEut3Hodq1ZZ48u4CK8QuQYkf
	k++xTGAUm4Vk6iwkLbOQtMxC0rKAkWUVo1hpcXJBcVJ6aoWJXnFibnFpXrpecn7uJkZIpNXu
	YLz/1eYQowAHoxIP7wUJxiAh1sSy4srcQ4wSHMxKIrw+ICHelMTKqtSi/Pii0pzU4kOMTByc
	Ug2MRW2vJn1YOC9DbkmnozH/4TT17H3PpbW27z9vbGw53UZ5QUCi45v7nDc3O9gIXVgmx5J7
	7KyCxv7tyT+5v5ZskBcwi9+1rNxB+NEUjRivy/89SkM+Wbgsjsu7u3rCW7GXyf8uH9uaYSyj
	zjlx/8Z9SxZwxcVfV/B71yO5cVL7j5vV2sKWj1zPKbEUZyQaajEXFScCAPa8SHSSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 04:28 PM, Rafael J. Wysocki wrote:
> On Tuesday, August 06, 2013 09:38:36 PM Shuah Khan wrote:
>> On 08/06/2013 03:22 PM, Alan Stern wrote:
>>> On Tue, 6 Aug 2013, Shuah Khan wrote:
>>>
>>>> With the dev_pm_ops model, drivers have to provide interfaces for each
>>>> one of these states.
>>>
>>> No, they don't.  They can leave out interfaces if they want.
>>
>> Yes. Agreed. There is no need to provide each and every interface. Only
>> the ones driver wishes to handle.
>>
>>>
>>>>    In this case, there will be a conflict since
>>>> pm_op() treats this state as freeze where as the driver wants to do
>>>> treat it as a suspend/hibernate. In the case of legacy pm_ops, state is
>>>> passed in as a parameter and driver could take special action if need
>>>> be, based on the state, however in dev_pm_ops model, state is not passed
>>>> in. Instead it is handled with state specific pm_ops interfaces.
>>>>
>>>> For example, if this driver were to be converted to dev_pm_ops, it would
>>>> require a freeze interface which will call sl811h_bus_suspend(). Once
>>>> that is done, PM_EVENT_PRETHAW will be mapped to freeze() ops and
>>>> sl811h_bus_suspend() will be called instead of port_power(sl811, 0);
>>>>
>>>> What I am getting at is, there is no provision to handle the special
>>>> case for PM_EVENT_PRETHAW like in the case of this driver when using
>>>> dev_pm_ops.
>>>
>>> Okay.  So what?
>>>
>>
>> I am exploring to see if there is a deficiency in dev_pm_ops
>> infrastructure that needs addressing.
>
> No, there isn't.  We determined a few years ago that "freeze" could always be
> used instead of "prethaw".  Moreover, there actually is a "thaw" after that
> stage if the image restoration fails, so please just use "freeze" here.  Or
> just skip it if it is not really needed.
>

Thanks Rafael!

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
