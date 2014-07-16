Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbaGPNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:09:27 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49468 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934107AbaGPNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:09:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jassi Brar <jaswinder.singh@linaro.org>
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
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
Date: Wed, 16 Jul 2014 15:09:11 +0200
Message-ID: <5461658.P0nNPHkj0L@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJe_ZhfwhMBVhsOm4K69crX38rgrwYenQfySox7nGNVqQHreNQ@mail.gmail.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <6436896.YqIi9fg7XW@wuerfel> <CAJe_ZhfwhMBVhsOm4K69crX38rgrwYenQfySox7nGNVqQHreNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VbcyEkSf4cofeXyBWyBaNeUbWzqIVCW+37+PmYfXOTe
 bHKafjD9QDhJpktOsrF+TJ6Kqh5TOj/o5BkQjvoTa1iPs/1Fdw
 MWPXWsj32XvZQQDKnuabxNYMezSbJ8gRlhZGbyd9JKj0mL9gir
 vOc6NWnyf6gGtiqgpgYGxM7PAqib0vathDtJtaaqGT6i9vdgYL
 Wra9wXoNepvRPW1sr8Qlzsgczqs865FHeosHlUtCBGB1tbzR1m
 qkawjEI4FHO4ZwgXLViUEYjG+IVB3c9kfrl+1bdgIbUDbufnlV
 ZNBNl55TbJ67S62i++Al/KPMiCTHqd1pfVoRsHgJRj31zs6tta
 7v02iE7Ic2sB1A8Koevk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 18:35:33 Jassi Brar wrote:
> On 16 July 2014 18:15, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 16 July 2014 18:07:04 Jassi Brar wrote:
> >> On 16 July 2014 15:46, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Wednesday 16 July 2014 10:40:19 Sudeep Holla wrote:
> >> >> > +
> >> >> > +Required property:
> >> >> > +- mbox: List of phandle and mailbox channel specifier.
> >> >> > +
> >> >> > +- mbox-names: List of identifier strings for each mailbox channel
> >> >> > +               required by the client.
> >> >> > +
> >> >>
> >> >> IMO the mailbox names are more associated with the controller channels/
> >> >> mailbox rather than the clients using it. Does it make sense to move
> >> >> this under controller. It also avoid each client replicating the names.
> >> >
> >> > I think it would be best to just make the mbox-names property optional,
> >> > like we have for other subsystems.
> >> >
> >> A very similar subsystem - DMAEngine also has 'dma-names' as a
> >> required property.
> >>
> >> If a client is assigned only 1 mbox in DT, we can do without
> >> mbox-names. But I am not sure what to do if a client needs two or more
> >> differently capable mboxes? Simply allocating in order of mbox request
> >> doesn't seem very robust.
> >
> > Traditionally, these things (regs, interrupts, ...) are just accessed
> > by index. The reason why dmaengine requires the name is that some machines
> > can use multiple DMA engine devices attached to the same request line,
> > so the dmaengine subsystem can pick any of them that has a matching
> > name.
> And also, I think, when a client needs 2 different dma channels, say
> for RX and TX each. The api can't assign the first channel specified
> in 'dmas' property to the first channel request that comes to it,
> unless we assume client driver always requests dma channels in the
> order written in its DT node.  And this is the main reason I see for
> having mbox-names property.

Most subsystems require passing an explicit index in this case.

>   If we make mbox-names optional, do we assume client driver must
> request mbox in the order specified in its DT node?

Correct.

	Arnd
