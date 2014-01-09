Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaAIU6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:58:54 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:49411 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbaAIU6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:58:42 -0500
MIME-Version: 1.0
In-Reply-To: <bfe1b6a0b2494c71be43fea45f413575@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52B0AEAD.6050604@gmail.com> <20131218010207.GC15119@google.com>
 <CAA93t1qh2Wn2uPKUGvbqrOJxDfqAqTNFSqOryC36Wm=gnygUog@mail.gmail.com>
 <CAErSpo6A0=0Ph22vMZ1_eC1L7ndoi5S6162zRDYkMoPf53Fhcg@mail.gmail.com>
 <4b24688d857e432eb7ecf9095c95b742@DM2PR05MB671.namprd05.prod.outlook.com> <bfe1b6a0b2494c71be43fea45f413575@DM2PR05MB671.namprd05.prod.outlook.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 9 Jan 2014 13:58:21 -0700
Message-ID: <CAErSpo4gGW2r4X7UuefwcYTX=c4irWc60w2UCT0e_U-uSaujow@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during removal
To: Rajat Jain <rajatjain@juniper.net>
Cc: Rajat Jain <rajatxjain@gmail.com>, Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 1:45 PM, Rajat Jain <rajatjain@juniper.net> wrote:
> Hi Bjorn,
>
>> -----Original Message-----
>> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
>> owner@vger.kernel.org] On Behalf Of Rajat Jain
>> Sent: Tuesday, January 07, 2014 10:21 AM
>> To: Bjorn Helgaas; Rajat Jain
>> Cc: Rajat Jain; Kenji Kaneshige; Alex Williamson; Yijing Wang; linux-
>> pci@vger.kernel.org; linux-kernel@vger.kernel.org; Yinghai Lu; Guenter
>> Roeck; Yinghai Lu
>> Subject: RE: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
>> during removal
>>
>> Hello Bjorn / Yinghai,
>>
>> > -----Original Message-----
>> > From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> > Sent: Monday, January 06, 2014 4:04 PM
>> > To: Rajat Jain
>> > Cc: Rajat Jain; Kenji Kaneshige; Alex Williamson; Yijing Wang; linux-
>> > pci@vger.kernel.org; linux-kernel@vger.kernel.org; Yinghai Lu; Guenter
>> > Roeck; Rajat Jain; Yinghai Lu
>> > Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link
>> > permanently, during removal
>> >
>> > On Sun, Jan 5, 2014 at 10:53 AM, Rajat Jain <rajatxjain@gmail.com>
>> > wrote:
>> > > Hello Bjorn,
>> > >
>> > > Just checking on the fate of this patch set...
>> > >
>> > > On Tue, Dec 17, 2013 at 5:02 PM, Bjorn Helgaas <bhelgaas@google.com>
>> > wrote:
>> > >> [+cc yinghai@kernel.org (seems to be Yinghai's preferred email]
>> > >>
>> > >> On Tue, Dec 17, 2013 at 12:06:05PM -0800, Rajat Jain wrote:
>> > >>> We need future link up events for hot-add, thus don't disable the
>> > >>> link permanently during device removal. Also, remove the static
>> > >>> functions that are now left unused.
>> > >>
>> > >> The changelog should mention that this reverts part of 2debd9289997
>> > ("PCI:
>> > >> pciehp: Disable/enable link during slot power off/on").
>> > >
>> > > Sure. Do you want me to submit another patch set (bumping up the
>> > > version) with this change log, or you'd want to add this change log
>> > > while merging?
>> > >
>> > >>
>> > >> Yinghai, can you tell us whether this is an issue on your systems?
>> > >
>> > > As Yinghai confirms further down this thread, his issue was
>> > > confirmed by Intel to be a bug in the repeater chip.
>> > > ----------------------------------
>> > > Yinghai writes:
>> > >> According to HW guys and Intel, that should be bug of repeater.
>> > >>
>> > > ---------------------------------
>> > >  I don't know about the details of his scenario, except that when
>> > > the adapter was disabled the repeater kept on flapping the link up &
>> > > down (and hence disabling the link solved the problem then). Yinghai
>> > > couldn't test, but I believe with this patch even if we disable
>> > > presence detect interrupt, the "adapter present / no present"
>> > > messages would (rightly) convert to "Link Up / Link Down" messages
>> > > (since the repeater keeps on flapping the link).
>> > >
>> > > Since it is a platform specific bug, I'm not sure what can be done
>> > > to remove those messages except may be reduce the verbosity? If
>> > > you'd like I could change all the INFO messages to DBG messages.
>> >
>> > Even if it's a defect in a particular piece of hardware, I don't want
>> > to regress on that hardware, even if the regression is just extra
>> > messages that we didn't see before.
>> >
>> > I think ideally we would add some sort of quirk for that hardware so
>> > it works just as well as it does today.  I think extra messages will
>> > lead to a bug reports from users.
>>
>> Sure, I can do that. I think what the quirk would have to do is that for
>> that particular platform, don't enable the link-state based hotplug.
>> (Since link-state hotplug will not work if we disable the link
>> permanently as we do today on card removal).
>>
>> But the question is how to determine that the quirk has to be applied? I
>> think the objective is to apply the quirk to the platforms that have a
>> "PCIe repeater". Since this does not depend on a PCI device / vendor ID,
>> and I think the PCIe repeater is probably not even visible to the pciehp
>> or the PCI subsystem, how do I determine that the quirk has to be
>> applied?
>
> Any ideas on how do I identify the platforms that may have this problem?

I sure don't know.  I suspect you're right that the PCIe repeater is
invisible to software, at least in terms of PCI config space.  Maybe
we could use DMI to identify platforms.  That's not a very good
solution because we have to come up with a list, but I can't think of
a better way.  Yinghai knows more about the platform and might have
better ideas.

Bjorn

>> If (hw_has_pcie_repeater)
>>       Don't use link-state hotplug (and disable link permanently during
>> card removal) Else
>>       Use link-state hotplug (and don't disable the link permanently)
>>
>>
>> Yinghai: Since I do not have that hardware, I will need some help in
>> testing the patch with the quirk. I was wondering if you'd still have
>> that hardware around and would be able to help me with testing?
>>
>> Thanks,
>>
>> Rajat
>>   {.n +       +%  lzwm  b 맲  r  zX   \ )   w*jg         ݢj/   z ޖ  2 ޙ
>> & )ߡ a       G   h   j:+v   w ٥
