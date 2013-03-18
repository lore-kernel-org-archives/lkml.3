Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3CRSfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:35:40 -0400
Received: from elijah-5.iglou.com ([64.253.103.13]:49650 "EHLO eli.elilabs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab3CRSfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:35:39 -0400
X-Greylist: delayed 2006 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 14:35:38 EDT
Message-ID: <51475699.3030406@elilabs.com>
Date: Mon, 18 Mar 2013 14:02:01 -0400
From: Robert Brown <rj@elilabs.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121129 Thunderbird/10.0.11
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Myron Stowe <mstowe@redhat.com>, Myron Stowe <myron.stowe@redhat.com>,
        linux-hotplug@vger.kernel.org, linux-pci@vger.kernel.org,
        yuxiangl@marvell.com, yxlraid@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
References: <20130316213512.2974.17303.stgit@amt.stowe>  <20130316213519.2974.38954.stgit@amt.stowe>  <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>  <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>  <20130317053611.GC948@kroah.com> <1363527503.16793.75.camel@ul30vt.home>  <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>  <1363623880.24132.351.camel@bling.home> <20130318164126.GA20565@kroah.com>  <1363625463.24132.367.camel@bling.home> <87obeg39qp.fsf@nemi.mork.no> <1363629287.24132.380.camel@bling.home>
In-Reply-To: <1363629287.24132.380.camel@bling.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/13 13:54, Alex Williamson wrote:
> On Mon, 2013-03-18 at 18:20 +0100, Bjørn Mork wrote:
>> Alex Williamson <alex.williamson@redhat.com> writes:
>>
>>> At least for KVM the kernel fix is the addition of the vfio driver which
>>> gives us a non-sysfs way to do this.  If this problem was found a few
>>> years later and we were ready to make the switch I'd support just
>>> removing these resource files.  In the meantime we have userspace that
>>> depends on this interface, so I'm open to suggestions how to fix it.
>> I am puzzled by a couple of things in this discussion:
>>
>> 1) do you seriously mean that a userspace application (any, not just
>>    udevadm or qemu or whatever) should be able to read and write these
>>    registers while the device is owned by a driver?  How is that ever
>>    going to work?
> The expectation is that the user doesn't mess with the device through
> pci-sysfs while it's running.  This is really no different than config
> space or MMIO space in that respect.  You can use setpci to break your
> PCI card while it's used by the driver today.  The difference is that
> MMIO spaces side-step the issue by only allowing mmap and config space
> is known not to have read side-effects.
>
>> 2) is it really so that a device can be so fundamentally screwed up by
>>    reading some registers, that a later driver probe cannot properly
>>    reinitialize it?
> Never underestimate how broken hardware can be, though in this case
> reading a device register seems to be causing a system hang/reset.
The real problem is that PCI devices can be bus masters, which means
they can screw up *ANYTHING* (almost)!

