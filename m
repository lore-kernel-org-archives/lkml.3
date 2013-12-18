Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab3LRGRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:17:38 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:6061 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab3LRGRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:17:36 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z579ehz98dI9371Ic89bh542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz8275ch1de098h8275bh1de097hz2fh109h2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(13464003)(164054003)(189002)(199002)(24454002)(51704005)(377454003)(76786001)(85852003)(87266001)(76796001)(33646001)(83072002)(63696002)(76576001)(85306002)(53806001)(90146001)(31966008)(51856001)(54356001)(76482001)(56816005)(65816001)(80022001)(46102001)(47446002)(19580395003)(74662001)(83322001)(74502001)(19580405001)(66066001)(81816001)(77982001)(59766001)(74316001)(81686001)(74366001)(69226001)(56776001)(54316002)(79102001)(87936001)(2656002)(74876001)(74706001)(80976001)(47736001)(49866001)(81342001)(4396001)(81542001)(47976001)(50986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB527;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.12;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatxjain@gmail.com>
Subject: RE: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
 during removal
Thread-Topic: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
 during removal
Thread-Index: AQHO+2O+glESpPkjFkO6kKuv5WeLEZpZIsOAgAAgqXCAACXDAIAADsVg
Date: Wed, 18 Dec 2013 06:17:28 +0000
Message-ID: <0c18891f0a754978a3015c9b3b50df93@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52B0AEAD.6050604@gmail.com>	<20131218010207.GC15119@google.com>
	<41c1723da4454cdca6503418746a5ca7@DM2PR05MB671.namprd05.prod.outlook.com>
 <CAE9FiQVGQ8THfMBfEhaOnjbrdaRn+5CRoUoGZuVvRcZcAKqW_A@mail.gmail.com>
In-Reply-To: <CAE9FiQVGQ8THfMBfEhaOnjbrdaRn+5CRoUoGZuVvRcZcAKqW_A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.12]
x-forefront-prvs: 0064B3273C
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBI6IGJe007828


> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> 
> On Tue, Dec 17, 2013 at 7:20 PM, Rajat Jain <rajatjain@juniper.net>
> wrote:
> >
> > Actually I did not understand the original problem and the solution in
> > the first place (so I also do not understand how might disabling of
> > presence detect notification help). If you can give more details on
> > the original problem that shall be great. Here is what I understood
> from the commit log:
> >
> > The believe the HW looks like this:
> >
> > PCIe port <----> Repeater <----> Device.
> >
> > An in addition there is the presence detect pin that is connected
> > directly from The port to the device. Now, when the device is plugged
> > out, the pin indicates No presence. But are you saying the PCIe link
> from port to repeater is still up?
> 
> After the card is removed from the slot.
> 
> PCIe port try to retrain the link to repeater, like the link will keep
> up and down.

I still did not understand the why would the PCIe port try to do so. Are you
Saying the repeater keeps on flapping the link? Nevertheless, I assume it is
due to some repeater bug (that you mention below) that I do not need to
understand.

> 
> so the presence bit will keep report one card present and not present.
> that present bit should be OR of inband input and outband input.
> We check the outband input and it always report correctly.

Just a suggestion for a work around. I checked the manual of the PCIe switch
we use in our system (IDT 89HPES48H12G2), and it is possible at least in this
switch to control whether or not in-band is considered. An internal configuration
register says:

Presence Detect Control. This field controls the manner in which
presence of an adapter in a slot is reported to the hot-plug controller
associated with a downstream switch port.
0x0 - (both) Presence of an adapter in the slot is reported as the
logical â€œORâ€ of the receiver detect mechanism and the hotplug
presence detect input (PxPDN).
0x1 - (signal) Presence of an adapter in the slot is reported as the
state of the hot-plug presence detect input (PxPDN).
0x2 - (always) When selected, this mode always informs the hotplug
controller that an adapter is present.
0x3 - (never) When selected, this mode always informs the hotplug
controller that an adapter is not present.

May be some similar config may be present in the switch or the CPU that you use.

Just a random thought.

> 
> According to HW guys and Intel, that should be bug of repeater.

Well, in that case I doubt if the patch will solve the problem. I think
Most likely the "card present / not present" messages may be replaced
By "link-up / link-down" messages. But I'd appreciate your testing.

Thanks,

Rajat

> 
> Disable the link from pcie to repeater, likely to reset the repeater....
> 
> Thanks
> 
> Yinghai
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
