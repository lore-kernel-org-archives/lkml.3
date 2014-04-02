Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbaDBNC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:02:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51665 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbaDBNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:02:26 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-1c-533c0a5fe222
Message-id: <533C0A57.50102@samsung.com>
Date: Wed, 02 Apr 2014 15:02:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <20140331200620.GA13881@kroah.com> <533ABCEC.8040701@codethink.co.uk>
 <20140402080102.GK2931@tbergstrom-lnx.Nvidia.com>
In-reply-to: <20140402080102.GK2931@tbergstrom-lnx.Nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xa7rxXDbBBp1rxCwe3Gplsph/5Byr
	Rf+bhawWB/7sYLRoXryezeJs0xt2i86JS9gtNj2+xmpxedccNovbl3kt1h65y26x9PpFJoun
	Ey6yWUxaO5XRonXvEXaLv9s3sVjMmPySzWL9jNcsDkIea+atYfRoae5h87jc18vk8ezlZCaP
	2R0zWT02repk87hzbQ+bx/65a9g9Ni+p9+htfsfm0f/XwKNvyypGj8+b5AJ4o7hsUlJzMstS
	i/TtErgy3h/ay1Swm6/i3O2LLA2Mu7m7GDk5JARMJB7vv88KYYtJXLi3nq2LkYtDSGApo8Tn
	wwtYIJxPjBLfOq+CVfEKaEjsmvSJHcRmEVCV6PkzGcxmEzCU6D3axwhiiwpESNxrPAxVLyjx
	Y/I9oEEcHCICBhKz36qDzGQWWMIuMf8zxBxhgWiJMw0bmSGW/WeU2Pf9KgtIglPATuLFojls
	IDazgI7E/tZpULa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvX
	S87P3cQIidAvOxgXH7M6xCjAwajEwytxySpYiDWxrLgy9xCjBAezkgjvpE/WwUK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYmVecsE2ff9usonS719OjzHN/zGqyqOhNP8zNfcSn/zbTZ8Yy3SmF
	daKy61Yvu+ZyJlL2t+e0u3uaWRKLvNb/37Gzeo2AaNsWzYwpS+eli14Pv7FvwU3WA7+PSBpv
	rel7HNArquRRM1Vzr750uVDQcZmK0JidpXEbbCImvPQStfF1lk3Yca9biaU4I9FQi7moOBEA
	rZBq5q4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/14 10:01, Peter De Schrijver wrote:
> On Tue, Apr 01, 2014 at 03:19:40PM +0200, Ben Dooks wrote:
>> On 31/03/14 21:06, Greg KH wrote:
>>> On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
>>>> This function adds a helper function to configure clock parents and rates
>>>> as specified in clock-parents, clock-rates DT properties for a consumer
>>>> device and a call to it before driver is bound to a device.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>
>> [snip]
>>
>>> I don't understand why you need the driver core to initialize this one
>>> type of thing?  That should be in a driver, or in a class, or at worse
>>> case, the platform code.
>>>
>>> What makes clocks so "unique" here?
>>
>> I suppose the issue here is that a lot of drivers currently use
>> clocks and a number of systems have badly setup default clock trees
>> at start time.
>>
>> Mark Brown and others have argued that the management of clocks which
>> is common to all devices should not live in the driver.
> 
> Exactly, this data should be part of the clock provider DT nodes, not
> of the device nodes. 

Why not in the device nodes, when often this data is closely related
to a device ? I'd prefer to keep the ability to also specify it at
the consumer nodes. IMHO the DT binding would be more explicit and
less error prone this way. E.g. clock-rates may refer directly to the
consumer clocks, so why we should be specifying it for all devices in
a single DT node ?

Also I'm not sure if a fact that something shouldn't be handled in
a device driver necessarily means that related data shouldn't be put
in the device node.

It would be nice to hear more opinions, it seems now there is
roughly same number of proponents and opponents of each option.

--
Thanks,
Sylwester
