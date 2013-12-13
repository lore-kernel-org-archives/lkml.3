Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3LMTE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:04:57 -0500
Received: from [216.32.180.31] ([216.32.180.31]:20276 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752827Ab3LMTEz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:04:55 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VPS6(z579ehz98dI9371Ic3f2I154dI1432I4015I1521Ic9f0szz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2fh109h2a8h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(54094003)(164054003)(189002)(199002)(24454002)(377454003)(501624003)(54534003)(51704005)(15975445006)(69226001)(33646001)(85852003)(83072002)(76796001)(87266001)(31966008)(19580405001)(19580395003)(76482001)(90146001)(63696002)(74706001)(76786001)(81686001)(79102001)(51856001)(56816005)(54316002)(81542001)(74662001)(80976001)(76576001)(85306002)(46102001)(83322001)(65816001)(53806001)(74502001)(54356001)(47446002)(56776001)(2656002)(74876001)(81342001)(15202345003)(74316001)(47976001)(74366001)(77982001)(81816001)(87936001)(59766001)(50986001)(80022001)(49866001)(4396001)(47736001)(66066001)(24736002)(516964004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB528;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.10;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: Rajat Jain <rajatjain.linux@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: RE: [PATCH v2 2/4] pciehp: Use link change notifications for
 hot-plug and removal
Thread-Topic: [PATCH v2 2/4] pciehp: Use link change notifications for
 hot-plug and removal
Thread-Index: AQHO+AZNeZYiFnTkJEGITKvOmmnWr5pScb8Q
Date: Fri, 13 Dec 2013 19:04:32 +0000
Message-ID: <428d664592c2466c9e5e6b393df9d690@DM2PR05MB671.namprd05.prod.outlook.com>
References: <529E5C0E.80903@gmail.com> <20131212224407.GL4699@google.com>
 <CAE9FiQX8XXkwbhhuNhCF-pHdc_3or_dMEH-VN5NBSEV_eXE-Pg@mail.gmail.com>
 <CAErSpo5BsaLNrny3T1sYknz3wo4hN0SKJk0_u6eNyEd6qq5o=g@mail.gmail.com>
In-Reply-To: <CAErSpo5BsaLNrny3T1sYknz3wo4hN0SKJk0_u6eNyEd6qq5o=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.10]
x-forefront-prvs: 00594E8DBA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

Firstly, thanks a lot for taking a look at my patch set.

> 
> On Thu, Dec 12, 2013 at 11:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Thu, Dec 12, 2013 at 2:44 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> 
> >>> * Define and use interrupt events for linkup / linkdown.
> >>
> >> This seems like a reasonable idea.
> >>
> >> In the ExpressCard Standard (Rel 2.0, Feb 2009), Section 6.3.1 and
> >> Figure
> >> 6-2 talk about a "Link Detect" or "Link Train Detected" interrupt
> >> being used to trigger the ACPI hotplug flow for a non-PCIe-aware OS.
> >> I'm not sure what interrupt this refers to.  The Slot Control Data
> >> Link Layer State Changed interrupt (which you're using) sounds
> >> similar, but my guess is that "Link Detect" is a generic term for
> >> chipset-specific functionality to generate an SMI for hotplug events.
> >>
> >> But then Section 6.3.1.1 suggests that a PCIe-aware OS would use
> >> "Presence Detect Changed" instead.  I don't know why a different
> >> mechanism would be suggested, although DLLSC was added after PCIe
> >> 1.0, so older hardware wouldn't have a PCIe-standard link detection
> mechanism.
> >>
> >> In any event, I think having the Link Status Data Link Layer Link
> >> Active bit set would certainly imply that a device is present, so it
> >> seems reasonable to use DLLLA in addition to Presence Detect State.
> >
> > Yes, if Attention attention is not there and Surprise removal is
> supported.
> 
> I'm not convinced that it's a good idea to make link state support
> conditional on the attention button and surprise removal bits.  That
> might cover Rajat's particular case, but I don't think there's a logical
> connection between link state and those bits, so making it conditional
> might just make the code more complicated and less general for no good
> reason.

Ok. 

> 
> >>> @@ -620,13 +610,10 @@ int pciehp_power_off_slot(struct slot * slot)
> >>>       u16 cmd_mask;
> >>>       int retval;
> >>>
> >>> -     /* Disable the link at first */
> >>> -     pciehp_link_disable(ctrl);
> >>> -     /* wait the link is down */
> >>> -     if (ctrl->link_active_reporting)
> >>> -             pcie_wait_link_not_active(ctrl);
> >>> -     else
> >>> -             msleep(1000);

I'll separate this out as a separate patch. 

> >>
> >> 2debd9289997 ("PCI: pciehp: Disable/enable link during slot power
> >> off/on") added this code that disables the link to fix problems.  So
> >> we need to make sure we don't reintroduce those problems by leaving
> the link enabled.
> >>
> >> One problem was spurious "card present/not present" messages.  I
> >> suspect that topology has an attention button, and I'm not sure it
> >> makes sense to enable the presence detect interrupt in that case.  As
> >> far as I can tell, if there's an attention button, the OS should not
> >> do anything on card insertion or removal; it should only do something
> >> when the attention button is pressed.  So maybe we can deal with the
> message issue that way.
> >
> > Agreed.

Ok. I'll disable the presence detect interrupt when attention button is present. Note that however, if the link comes up or goes down without the user pressing the attention button, the device will be added or removed. It may be a non-issue, because I think ultimately all the attention button press does during device addition, is to power on the slot to bring the Link up. In this case since the link is already Up, there really isn't anything else the SW would or could do on attention button press. 

Also, I think the device removal should _always_ be initiated (if not done already) whenever the Link goes down for any reason (irrespective of whether the attention button is implemented or not, or whether the surprise events are supported or not). I think this is logical as it makes no sense for the software to think the device is accessible when in reality it is not. In fact I think we should also remove the checks in pciehp_disable_slot() that ensure that the adapter should be populated and latch should be closed.


> >
> >>
> >> The changelog also hints that disabling the link might be needed to
> >> allow a repeater to be reset, but I don't know the details.  I don't
> >> remember any spec language that requires the link to be disabled on
> >> hotplug; maybe this is a platform-specific quirk.
> >
> > yes, that is workaround to to reset repeater in between.

I guess my question is what breaks if we don't disable the link on a hot-unplug? And if it is a platform specific problem, may be it should be dealt with in a platform specific way? I guess, it would become more clearer once I split out the patch, and you could just test NOT disabling the link while unplugging.

> 
> What does the "other OS" do about this repeater?  Did you verify that it
> disables the link when powering off the slot?  If we were smarter about
> presence detect, I wonder if that would be enough.
> 
> > Also we can get rid of annoying aer during power off slot.
> 
> I don't know the details of this issue.  It may be possible to avoid the
> AER in some way other than turning off the link.

Sorry, I could not understand what we are talking about here. I'd appreciate if you could elaborate if you see this as a problem related to the patch?

> 
> > Also at least other os will turn on link after turn on the power, as
> > hotplug is working if BIOS have link disabled when boot system without
> > card inserted.
> 
> If the link is disabled after turning on power, it certainly makes sense
> to me to enable the link.  I don't think Rajat changed the
> pciehp_power_on_slot() path, so this part should still work.

Yes, I think so.

> 
> > I suggest that link event handling will be enabled automatically when
> > attention button is not there and surprise removal is supported.
> > And when that enabled, should disable Present event handling.
> 
> I think it should be as simple as possible, i.e., if we have an
> attention button, ignore presence detect.  If we make it more
> complicated that necessary, we run the risk of enforcing assumptions
> that may not hold in the future.

Once again: the way I interpret this is:
* Always enable Link events.
* Disable presence events if attention button is present.


Thanks,

Rajat

> 
> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
> 


