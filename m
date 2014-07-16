Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbaGPMqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:46:04 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58745 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaGPMqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:46:00 -0400
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
Date: Wed, 16 Jul 2014 14:45:43 +0200
Message-ID: <6436896.YqIi9fg7XW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJe_ZheAjhufEf3c72bwbvF11P070hxh0qZ9s5KDxwFUgH1ixg@mail.gmail.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <5340858.B9CZUE8s0j@wuerfel> <CAJe_ZheAjhufEf3c72bwbvF11P070hxh0qZ9s5KDxwFUgH1ixg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9LcJQFPA4zn7kdcjdZGsoZIH6T3FDb67khtl8eCvsGk
 QVOz5o72b90+qAln18jBTjwZJ9JfTMTFBFGLD9dgJeS0bqRvf9
 hRigRucoIErDxFn/HocWbI0g6dVc5cdmeE2n1reYNTUrc4f9sZ
 1rIGMjR2WQi4sbkTs0Y/HywkW5aSYQq/RfWVuKNK4qPoQfHHNq
 N4QnmDiagpKD4a1Dqp4Qon7J9oN8Xm5uzFT2k98WBbJ4kNVOas
 5kmPp0jEWtColWcBKXk063ck/3JZAqvAJvUnpbjbr0/x/9ZXc/
 1NgCUk/gxP1cQ2/Eu/Kd2HzO9JMbXK0W2i4mvnYryhB/Y+CfLz
 R9ygT+QNABFmlCi+oUO0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 18:07:04 Jassi Brar wrote:
> On 16 July 2014 15:46, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 16 July 2014 10:40:19 Sudeep Holla wrote:
> >> > +
> >> > +Required property:
> >> > +- mbox: List of phandle and mailbox channel specifier.
> >> > +
> >> > +- mbox-names: List of identifier strings for each mailbox channel
> >> > +               required by the client.
> >> > +
> >>
> >> IMO the mailbox names are more associated with the controller channels/
> >> mailbox rather than the clients using it. Does it make sense to move
> >> this under controller. It also avoid each client replicating the names.
> >
> > I think it would be best to just make the mbox-names property optional,
> > like we have for other subsystems.
> >
> A very similar subsystem - DMAEngine also has 'dma-names' as a
> required property.
> 
> If a client is assigned only 1 mbox in DT, we can do without
> mbox-names. But I am not sure what to do if a client needs two or more
> differently capable mboxes? Simply allocating in order of mbox request
> doesn't seem very robust.

Traditionally, these things (regs, interrupts, ...) are just accessed
by index. The reason why dmaengine requires the name is that some machines
can use multiple DMA engine devices attached to the same request line,
so the dmaengine subsystem can pick any of them that has a matching
name. If you specify multiple channels with the same name, you can no
longer use the index to refer to multiple alternatives.

	Arnd
