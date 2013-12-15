Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3LOX1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:27:15 -0500
Received: from [216.32.180.13] ([216.32.180.13]:11400 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752011Ab3LOX1O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:27:14 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz1432I4015I168aJzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2fh109h2a8h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(189002)(199002)(164054003)(57704003)(51704005)(83322001)(56816005)(90146001)(47446002)(74502001)(31966008)(74662001)(80976001)(47976001)(87936001)(53806001)(85306002)(56776001)(81342001)(76786001)(65816001)(83072002)(81542001)(50986001)(49866001)(47736001)(74876001)(74316001)(81816001)(81686001)(74706001)(69226001)(76576001)(74366001)(76482001)(76796001)(54356001)(63696002)(33646001)(2656002)(54316002)(85852003)(87266001)(79102001)(46102001)(77982001)(59766001)(80022001)(51856001)(66066001)(4396001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB527;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.12;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Guenter Roeck <linux@roeck-us.net>, Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>
Subject: RE: [PATCH v2 2/4] pciehp: Use link change notifications for
 hot-plug and removal
Thread-Topic: [PATCH v2 2/4] pciehp: Use link change notifications for
 hot-plug and removal
Thread-Index: AQHO+AZNeZYiFnTkJEGITKvOmmnWr5pScb8QgACea9yAAq1XoA==
Date: Sun, 15 Dec 2013 23:24:50 +0000
Message-ID: <241775f7fb71476aa84bbb19fde4602f@DM2PR05MB671.namprd05.prod.outlook.com>
References: <529E5C0E.80903@gmail.com> <20131212224407.GL4699@google.com>
 <CAE9FiQX8XXkwbhhuNhCF-pHdc_3or_dMEH-VN5NBSEV_eXE-Pg@mail.gmail.com>
 <CAErSpo5BsaLNrny3T1sYknz3wo4hN0SKJk0_u6eNyEd6qq5o=g@mail.gmail.com>
 <428d664592c2466c9e5e6b393df9d690@DM2PR05MB671.namprd05.prod.outlook.com>
 <CAErSpo5NjOCqkao03Ea=98gunVEaUUitq8mGLarpKW_DQoDF8g@mail.gmail.com>
 <CAE9FiQX-ZP0R-weuPoOJ6GkPxOLp5jk9thnjfPQ+Q5tCHugD4w@mail.gmail.com>
 <20131214033911.GA25115@roeck-us.net>
In-Reply-To: <20131214033911.GA25115@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.12]
x-forefront-prvs: 0061C35778
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >
> > >> Once again: the way I interpret this is:
> > >> * Always enable Link events.
> > >> * Disable presence events if attention button is present.
> > >
> > > That sounds like a good plan to me.
> >
> > How about Diag_Reset from MPT2SAS and others?
> > link could up and down
> >

I am assuming you are referring to 

static int
_base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)

Which as far as I could understand would cause link to go down and come up
 again without the kernel knowing anything about it?

Please see below since I think point made by Guenter includes this. 

> 
> Good question. Another question is how this would play together with AER
> functions, specifically link_reset and slot_reset.
> 
> In this context ... is it possible that the link_reset function from
> struct pci_error_handlers is never called, or am I missing something ?
>

Very good catch. That seems to be the case, at least as far as I can see.
In fact I think this may be uncovering a more serious problem 
with current code (with no link state events used for hotplug). 

A fatal error is discovered by AER
=> Calls do_recovery()
   => reset_link()
      => Which will  reset the link at downstream / root port.

[PS: There is a clear problem the link_reset() is never broadcasted to all
The drivers, but skimming over that for now] 

In general, I guess the question is when a link goes down and back up, whether
or not we want to treat it as a hot unplug followed by a hotplug. I think there
may be cases such as AER (or the one Yinghai mentions) where we don't want to
treat it as a hotplug (see note below). And there may be cases that we
definitely want to treat it as hotplug (need link events!). Situation gets more
complex since there may be pciehp slots downstream of a link getting reset. 

It seems to me that we are saying that a mechanism is needed so that a voluntary
Link flap is NOT treated like a hotplug temporarily?

I found these:

/**
 * pcie_port_device_suspend - suspend port services associated with a PCIe port
 * @dev: PCI Express port to handle
 */
int pcie_port_device_suspend(struct device *dev)
{
        return device_for_each_child(dev, NULL, suspend_iter);
}

/**
 * pcie_port_device_suspend - resume port services associated with a PCIe port
 * @dev: PCI Express port to handle
 */
int pcie_port_device_suspend(struct device *dev)
{
        return device_for_each_child(dev, NULL, suspend_iter);
}

May be either these can be used or enhancements can be provided to disable a specific
Service on a particular port. 

Thanks,

Rajat


Notes: 
* it may not OK, if the kernel thinks the device is accessible when it is really not.
  What if during this downtime, someone tries to access the device (say userspace)?
* How do we know after the link up, that the device is really the same. 
  If during this reset, the device changed its "character", say a different class?
  I think a rescan should be mandated after every such event.
 * Do we need to unload and reload the driver after the link reset, since it can be a different device?





