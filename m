Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbaGPNFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:05:36 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:54938 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaGPNFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:05:34 -0400
MIME-Version: 1.0
In-Reply-To: <6436896.YqIi9fg7XW@wuerfel>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org>
	<5340858.B9CZUE8s0j@wuerfel>
	<CAJe_ZheAjhufEf3c72bwbvF11P070hxh0qZ9s5KDxwFUgH1ixg@mail.gmail.com>
	<6436896.YqIi9fg7XW@wuerfel>
Date: Wed, 16 Jul 2014 18:35:33 +0530
Message-ID: <CAJe_ZhfwhMBVhsOm4K69crX38rgrwYenQfySox7nGNVqQHreNQ@mail.gmail.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sudeep Holla <sudeep.holla@arm.com>,
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
        "s-anna@ti.com" <s-anna@ti.com>,
        "ashwin.chaugule@linaro.org" <ashwin.chaugule@linaro.org>,
        "bjorn@kryo.se" <bjorn@kryo.se>,
        "patches@linaro.org" <patches@linaro.org>,
        "Mollie.Wu@tw.fujitsu.com" <Mollie.Wu@tw.fujitsu.com>,
        "t.takinishi@jp.fujitsu.com" <t.takinishi@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 18:15, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 16 July 2014 18:07:04 Jassi Brar wrote:
>> On 16 July 2014 15:46, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Wednesday 16 July 2014 10:40:19 Sudeep Holla wrote:
>> >> > +
>> >> > +Required property:
>> >> > +- mbox: List of phandle and mailbox channel specifier.
>> >> > +
>> >> > +- mbox-names: List of identifier strings for each mailbox channel
>> >> > +               required by the client.
>> >> > +
>> >>
>> >> IMO the mailbox names are more associated with the controller channels/
>> >> mailbox rather than the clients using it. Does it make sense to move
>> >> this under controller. It also avoid each client replicating the names.
>> >
>> > I think it would be best to just make the mbox-names property optional,
>> > like we have for other subsystems.
>> >
>> A very similar subsystem - DMAEngine also has 'dma-names' as a
>> required property.
>>
>> If a client is assigned only 1 mbox in DT, we can do without
>> mbox-names. But I am not sure what to do if a client needs two or more
>> differently capable mboxes? Simply allocating in order of mbox request
>> doesn't seem very robust.
>
> Traditionally, these things (regs, interrupts, ...) are just accessed
> by index. The reason why dmaengine requires the name is that some machines
> can use multiple DMA engine devices attached to the same request line,
> so the dmaengine subsystem can pick any of them that has a matching
> name.
And also, I think, when a client needs 2 different dma channels, say
for RX and TX each. The api can't assign the first channel specified
in 'dmas' property to the first channel request that comes to it,
unless we assume client driver always requests dma channels in the
order written in its DT node.  And this is the main reason I see for
having mbox-names property.
  If we make mbox-names optional, do we assume client driver must
request mbox in the order specified in its DT node?

> If you specify multiple channels with the same name, you can no
> longer use the index to refer to multiple alternatives.
>
Identical entries in dma-names/mbox-names property means the channels
are equally capable and can be assigned in the 'first free found'
manner.

Thanks
Jassi
