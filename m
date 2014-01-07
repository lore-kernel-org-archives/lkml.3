Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaAGSUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:20:55 -0500
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:16191
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaAGSUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:20:46 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehz98dI9371I154dI542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh109h2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(51704005)(24454002)(199002)(54534003)(13464003)(189002)(164054003)(377454003)(81342001)(74502001)(80976001)(83072002)(59766001)(56776001)(47976001)(50986001)(81816001)(74366001)(63696002)(49866001)(81686001)(77982001)(87266001)(74662001)(69226001)(2656002)(47446002)(87936001)(79102001)(85306002)(81542001)(47736001)(90146001)(74876001)(4396001)(53806001)(54356001)(56816005)(51856001)(74706001)(80022001)(66066001)(31966008)(54316002)(85852003)(46102001)(76576001)(76482001)(74316001)(33646001)(76786001)(65816001)(76796001)(83322001)(19580395003)(19580405001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB528;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.12;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Bjorn Helgaas <bhelgaas@google.com>, Rajat Jain <rajatxjain@gmail.com>
CC: Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: RE: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
 during removal
Thread-Topic: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
 during removal
Thread-Index: AQHO+2O+glESpPkjFkO6kKuv5WeLEZp4gVEKgAEwLtA=
Date: Tue, 7 Jan 2014 18:20:36 +0000
Message-ID: <4b24688d857e432eb7ecf9095c95b742@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52B0AEAD.6050604@gmail.com> <20131218010207.GC15119@google.com>
 <CAA93t1qh2Wn2uPKUGvbqrOJxDfqAqTNFSqOryC36Wm=gnygUog@mail.gmail.com>
 <CAErSpo6A0=0Ph22vMZ1_eC1L7ndoi5S6162zRDYkMoPf53Fhcg@mail.gmail.com>
In-Reply-To: <CAErSpo6A0=0Ph22vMZ1_eC1L7ndoi5S6162zRDYkMoPf53Fhcg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.12]
x-forefront-prvs: 008421A8FF
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s07IL3fA020618

Hello Bjorn / Yinghai,

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Monday, January 06, 2014 4:04 PM
> To: Rajat Jain
> Cc: Rajat Jain; Kenji Kaneshige; Alex Williamson; Yijing Wang; linux-
> pci@vger.kernel.org; linux-kernel@vger.kernel.org; Yinghai Lu; Guenter
> Roeck; Rajat Jain; Yinghai Lu
> Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
> during removal
> 
> On Sun, Jan 5, 2014 at 10:53 AM, Rajat Jain <rajatxjain@gmail.com>
> wrote:
> > Hello Bjorn,
> >
> > Just checking on the fate of this patch set...
> >
> > On Tue, Dec 17, 2013 at 5:02 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> >> [+cc yinghai@kernel.org (seems to be Yinghai's preferred email]
> >>
> >> On Tue, Dec 17, 2013 at 12:06:05PM -0800, Rajat Jain wrote:
> >>> We need future link up events for hot-add, thus don't disable the
> >>> link permanently during device removal. Also, remove the static
> >>> functions that are now left unused.
> >>
> >> The changelog should mention that this reverts part of 2debd9289997
> ("PCI:
> >> pciehp: Disable/enable link during slot power off/on").
> >
> > Sure. Do you want me to submit another patch set (bumping up the
> > version) with this change log, or you'd want to add this change log
> > while merging?
> >
> >>
> >> Yinghai, can you tell us whether this is an issue on your systems?
> >
> > As Yinghai confirms further down this thread, his issue was confirmed
> > by Intel to be a bug in the repeater chip.
> > ----------------------------------
> > Yinghai writes:
> >> According to HW guys and Intel, that should be bug of repeater.
> >>
> > ---------------------------------
> >  I don't know about the details of his scenario, except that when the
> > adapter was disabled the repeater kept on flapping the link up & down
> > (and hence disabling the link solved the problem then). Yinghai
> > couldn't test, but I believe with this patch even if we disable
> > presence detect interrupt, the "adapter present / no present" messages
> > would (rightly) convert to "Link Up / Link Down" messages (since the
> > repeater keeps on flapping the link).
> >
> > Since it is a platform specific bug, I'm not sure what can be done to
> > remove those messages except may be reduce the verbosity? If you'd
> > like I could change all the INFO messages to DBG messages.
> 
> Even if it's a defect in a particular piece of hardware, I don't want to
> regress on that hardware, even if the regression is just extra messages
> that we didn't see before.
> 
> I think ideally we would add some sort of quirk for that hardware so it
> works just as well as it does today.  I think extra messages will lead
> to a bug reports from users.

Sure, I can do that. I think what the quirk would have to do is that for that particular platform, don't enable the link-state based hotplug. (Since link-state hotplug will not work if we disable the link permanently as we do today on card removal).

But the question is how to determine that the quirk has to be applied? I think the objective is to apply the quirk to the platforms that have a "PCIe repeater". Since this does not depend on a PCI device / vendor ID, and I think the PCIe repeater is probably not even visible to the pciehp or the PCI subsystem, how do I determine that the quirk has to be applied?

If (hw_has_pcie_repeater)
	Don't use link-state hotplug (and disable link permanently during card removal)
Else
	Use link-state hotplug (and don't disable the link permanently)
	

Yinghai: Since I do not have that hardware, I will need some help in testing the patch with the quirk. I was wondering if you'd still have that hardware around and would be able to help me with testing?

Thanks,

Rajat
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
