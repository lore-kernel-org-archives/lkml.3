Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaAESBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:01:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaAESBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:01:11 -0500
Date: Sun, 5 Jan 2014 10:01:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Loc Ho <lho@apm.com>
Cc: Ravi Patel <rapatel@apm.com>, Arnd Bergmann <arnd@arndb.de>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue
 Manager/Traffic Manager
Message-ID: <20140105180122.GB980@kroah.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com>
 <201312212111.40576.arnd@arndb.de>
 <CAPw-ZTnsu_EmOW3aZTVKAVjQsdi8qMy95y2ZcYxzgVrjGkirTA@mail.gmail.com>
 <1441245.xPZLG2iNZ6@wuerfel>
 <CAN1v_PtFz42crHW5=cUgw-fAnPn3rQht=o0t3nmjJRamYSLDMg@mail.gmail.com>
 <20140105033848.GA22595@kroah.com>
 <CAPw-ZT=noCwc+3o_762ewTcn2J3SjZ5u11V=Aa8RrZZf4DT5Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPw-ZT=noCwc+3o_762ewTcn2J3SjZ5u11V=Aa8RrZZf4DT5Yw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 09:39:08PM -0800, Loc Ho wrote:
> Hi,
> 
> >> >> >> This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
> >> >> >>  QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
> >> >> >>  Security Engine subsystems. All subsystems communicate with QMTM using
> >> >> >>  messages which include information about the work to be performed and
> >> >> >>  the location of associated data buffers.
> >> >> >
> >> >> > Please describe here what the purpose of the qmtm is, as this is not
> >> >> > entirely clear from the code.
> >> >> >
> >> >> > In particular, please describe how this differs from a dmaengine driver
> >> >> > and why it is not possible to extend the dma slave API to describe qmtm
> >> >> > as a dma engine.
> >> >> >
> >> >> [Loc Ho]
> >> >> If the QM driver implements the DMA API, what about the actual DMA
> >> >> engine driver which interfaces with this QM driver. We would have DMA
> >> >> client interfaces with the X-Gene DMA driver (not available yet) via
> >> >> DMA API which in turn interfaces with this QM driver via DMA API.
> >> >> Won't this be kind of awkward? Also, the QM only manage messages (or
> >> >> descriptors) which are 32-bytes or 64-bytes. It doesn't actually do
> >> >> any data transfer of various sizes.
> >> >
> >> > Please describe here what the purpose of the qmtm is, as this is not
> >> > entirely clear from the code or from your reply.
> >> >
> >> > Greg was guessing that it's a bus controller, my best guess is a DMA
> >> > engine. If it's something completely different, you have to let
> >> > us know what it is so we can do a proper review rather than guessing.
> >> >
> >> > Please provide a link to the data sheet if you are unable to explain.
> >>
> >> Here is URL to a text document explaining role of QMTM device with CPU, Ethernet
> >> subsystem.
> >>
> >> https://drive.google.com/file/d/0B28TgQZ3JLoRRGNnbjJoUGNHWW8/edit?usp=sharing
> >
> > There is nothing at this link :(
> 
> I tried click on the txt file link from web site
> http://www.spinics.net/lists/netdev/msg264628.html and don't see any
> problem with accessing the txt file.

Now it's working :)

Anyway, as this is a .txt file, why wasn't it just sent in email, and
added to the patch series as a documentation file?

thanks,

greg k-h
