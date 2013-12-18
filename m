Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3LREGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 23:06:43 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:55546
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab3LREGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 23:06:40 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehz98dI9371I154dI1443I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2fh109h2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(377454003)(51874003)(189002)(24454002)(199002)(51704005)(54534003)(13464003)(46102001)(83072002)(74662001)(31966008)(51856001)(47446002)(74502001)(74876001)(85852003)(53806001)(81542001)(56816005)(69226001)(50986001)(47976001)(47736001)(49866001)(4396001)(2656002)(33646001)(87936001)(81816001)(63696002)(87266001)(85306002)(74316001)(76482001)(77982001)(79102001)(59766001)(81686001)(54316002)(76786001)(65816001)(76796001)(76576001)(80976001)(66066001)(80022001)(83322001)(19580405001)(81342001)(74366001)(56776001)(54356001)(74706001)(19580395003)(90146001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB669;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.12;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Guenter Roeck <linux@roeck-us.net>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Y@jasper.es" <Y@jasper.es>
Subject: RE: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
 during removal
Thread-Topic: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
 during removal
Thread-Index: AQHO+2O+glESpPkjFkO6kKuv5WeLEZpZIsOAgAAgqXCAAAt5AIAABqxw
Date: Wed, 18 Dec 2013 04:06:07 +0000
Message-ID: <7324b9d8069446db85352ccad59c87ae@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52B0AEAD.6050604@gmail.com> <20131218010207.GC15119@google.com>
 <41c1723da4454cdca6503418746a5ca7@DM2PR05MB671.namprd05.prod.outlook.com>
 <20131218034004.GA22858@roeck-us.net>
In-Reply-To: <20131218034004.GA22858@roeck-us.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBI46nPC007330



> -----Original Message-----
> From: Guenter Roeck [mailto:groeck7@gmail.com] On Behalf Of Guenter
> Roeck
> Sent: Tuesday, December 17, 2013 7:40 PM
> To: Rajat Jain
> Cc: Bjorn Helgaas; Rajat Jain; Kenji Kaneshige; Alex Williamson; Yijing
> Wang; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
> Y@jasper.es
> Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
> during removal
> 
> On Wed, Dec 18, 2013 at 03:20:58AM +0000, Rajat Jain wrote:
> >
> >
> > > -----Original Message-----
> > > From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> > >
> > > [+cc yinghai@kernel.org (seems to be Yinghai's preferred email]
> > >
> > > On Tue, Dec 17, 2013 at 12:06:05PM -0800, Rajat Jain wrote:
> > > > We need future link up events for hot-add, thus don't disable the
> > > > link permanently during device removal. Also, remove the static
> > > > functions that are now left unused.
> > >
> > > The changelog should mention that this reverts part of 2debd9289997
> > > ("PCI:
> > > pciehp: Disable/enable link during slot power off/on").
> >
> > Sure, I'll add that.
> >
> > >
> > > Yinghai, can you tell us whether this is an issue on your systems?
> > >
> >
> > Thanks in advance Yinghai.
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
> >
> > Part of log:
> > ====================================
> >     ...
> >     It turns out the root complex is continually trying to train the
> link to
> >     the repeater because the repeater has not been reset.
> >
> >     This patch will disable the link at removal time to allow the
> repeater
> >     to be reset properly.
> >     ...
> > ====================================
> >
> > 1) I did not understand why would port try to retrain to the link in
> > either cases - Whether the link to the repeater is up or not?
> >
> > 2) When no link is seen, is THAT what causes repeater to go down and
> > hence solve the Problem?
> >
> > 3) I'd expect you'd continuously get "adapter not present" messages if
> > some how The driver was trying to add the device. But I did not
> > understand where did "adapter present" messages came from?
> >
> > Sorry, but I guess I am totally confused now. I'll probably go to
> > sleep :-)
> >
> 
> What, that early ? :-)

I was up until 3 AM last night. "git" (or the ignorance of it) keeps me busy I guess :-)

> 
> I think we may have a similar setup on some of our boards. Maybe we can
> reproduce the situation (after we understand what exactly it is and how
> to trigger it).
> 
> Related to this patch set, I learned today that our Space product uses
> mpt2sas.
> Just in case we need one for testing reset functionality.
> 
> Guenter
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
