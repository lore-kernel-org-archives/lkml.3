Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaGQHeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:34:08 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:62629 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaGQHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <53C6A3CB.5060005@ti.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org>
	<5461658.P0nNPHkj0L@wuerfel>
	<CAJe_Zhdtzhv=1QfhCAu6G_nq0VqW9v6TvgHSJe9VmgJQwo0U3Q@mail.gmail.com>
	<5214160.a78RDYzY5T@wuerfel>
	<CAJe_Zhf8oH-MPg6HtFDoT6_LZxJzy3ff85-GsWcENQftNiJMxw@mail.gmail.com>
	<53C6A3CB.5060005@ti.com>
Date: Thu, 17 Jul 2014 12:55:41 +0530
Message-ID: <CAJe_Zhdj_AyTi+b28k4etF3+eqObdfwSv5FhBZv+YyD6CTfmMA@mail.gmail.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <sudeep.holla@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "courtney.cavin@sonymobile.com" <courtney.cavin@sonymobile.com>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "slapdau@yahoo.com.au" <slapdau@yahoo.com.au>,
        "lftan.linux@gmail.com" <lftan.linux@gmail.com>,
        "loic.pallardy@st.com" <loic.pallardy@st.com>,
        "ashwin.chaugule@linaro.org" <ashwin.chaugule@linaro.org>,
        "bjorn@kryo.se" <bjorn@kryo.se>,
        "patches@linaro.org" <patches@linaro.org>,
        "Mollie.Wu@tw.fujitsu.com" <Mollie.Wu@tw.fujitsu.com>,
        "t.takinishi@jp.fujitsu.com" <t.takinishi@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 21:39, Suman Anna <s-anna@ti.com> wrote:
> Hi,
>
> On 07/16/2014 09:18 AM, Jassi Brar wrote:
>> On 16 July 2014 19:38, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Wednesday 16 July 2014 18:42:22 Jassi Brar wrote:
>>>> On 16 July 2014 18:39, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> On Wednesday 16 July 2014 18:35:33 Jassi Brar wrote:
>>>>>> On 16 July 2014 18:15, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>>>> On Wednesday 16 July 2014 18:07:04 Jassi Brar wrote:
>>>>>>>> On 16 July 2014 15:46, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>>>>>> On Wednesday 16 July 2014 10:40:19 Sudeep Holla wrote:
>>>>>>>>>>> +
>>>>>>>>>>> +Required property:
>>>>>>>>>>> +- mbox: List of phandle and mailbox channel specifier.
>>>>>>>>>>> +
>>>>>>>>>>> +- mbox-names: List of identifier strings for each mailbox channel
>>>>>>>>>>> +               required by the client.
>>>>>>>>>>> +
>>>>>>>>>>
>>>>>>>>>> IMO the mailbox names are more associated with the controller channels/
>>>>>>>>>> mailbox rather than the clients using it. Does it make sense to move
>>>>>>>>>> this under controller. It also avoid each client replicating the names.
>>>>>>>>>
>>>>>>>>> I think it would be best to just make the mbox-names property optional,
>>>>>>>>> like we have for other subsystems.
>>>>>>>>>
>>>>>>>> A very similar subsystem - DMAEngine also has 'dma-names' as a
>>>>>>>> required property.
>>>>>>>>
>>>>>>>> If a client is assigned only 1 mbox in DT, we can do without
>>>>>>>> mbox-names. But I am not sure what to do if a client needs two or more
>>>>>>>> differently capable mboxes? Simply allocating in order of mbox request
>>>>>>>> doesn't seem very robust.
>>>>>>>
>>>>>>> Traditionally, these things (regs, interrupts, ...) are just accessed
>>>>>>> by index. The reason why dmaengine requires the name is that some machines
>>>>>>> can use multiple DMA engine devices attached to the same request line,
>>>>>>> so the dmaengine subsystem can pick any of them that has a matching
>>>>>>> name.
>>>>>> And also, I think, when a client needs 2 different dma channels, say
>>>>>> for RX and TX each. The api can't assign the first channel specified
>>>>>> in 'dmas' property to the first channel request that comes to it,
>>>>>> unless we assume client driver always requests dma channels in the
>>>>>> order written in its DT node.  And this is the main reason I see for
>>>>>> having mbox-names property.
>>>>>
>>>>> Most subsystems require passing an explicit index in this case.
>>>>>
>>>>>>   If we make mbox-names optional, do we assume client driver must
>>>>>> request mbox in the order specified in its DT node?
>>>>>
>>>>> Correct.
>>>>>
>>>> OK. So how about we drop mbox-names altogether and expect client
>>>> driver to simply provide an index of the mbox needed?
>>>
>>> That would be fine with me, but I think a lot of people like
>>> the idea of identifying things by name, and are used to that
>>> from the other subsystems.
>>>
>>> Maybe you can leave the mbox-names property defined as 'optional'
>>> in the generic mbox binding but remove the code in Linux? That way
>>> we can always put it back at a later point without changing the
>>> binding in an incompatible way.
>
> I like this too, especially given that the framework uses this only to
> retrieve the index. The mbox_client structure currently requires the
> chan_name to be filled in, which means both the client driver and the
> framework end up having to parse the property.
>
Yeah let us discourage the use of mbox-names.

> While we are at this, how about we change the property name from "mbox"
> to a plural-form "mboxes" to be inline with gpios, dmas etc.
>
OK, will change mbox to mboxes.

-jassi
