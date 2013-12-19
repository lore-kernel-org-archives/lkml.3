Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3LSUWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:22:24 -0500
Received: from mail-bn1lp0156.outbound.protection.outlook.com ([207.46.163.156]:52699
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab3LSUWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:22:22 -0500
Message-ID: <1387484531.3140.134.camel@snotra.buserror.net>
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
From: Scott Wood <scottwood@freescale.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Kim Phillips <kim.phillips@linaro.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <R65777@freescale.com>, <B08248@freescale.com>,
        <christoffer.dall@linaro.org>, <alex.williamson@redhat.com>,
        <a.motakis@virtualopensystems.com>, <agraf@suse.de>,
        <B16395@freescale.com>
Date: Thu, 19 Dec 2013 14:22:11 -0600
In-Reply-To: <20131219010729.GC23055@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
	 <20131219010729.GC23055@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR04CA003.namprd04.prod.outlook.com (10.255.226.23) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 006546F32A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(377424004)(24454002)(51704005)(189002)(199002)(74876001)(74662001)(74502001)(81342001)(47446002)(62966002)(74706001)(50226001)(33646001)(50466002)(77156001)(76796001)(79102001)(81542001)(31966008)(65816001)(47736001)(4396001)(47976001)(81686001)(83322001)(63696002)(47776003)(81816001)(50986001)(46102001)(23676002)(56816005)(80976001)(85306002)(89996001)(51856001)(76482001)(90146001)(53806001)(42186004)(69226001)(83072002)(76786001)(74366001)(56776001)(49866001)(80022001)(85852003)(88136002)(87976001)(59766001)(87286001)(54316002)(77096001)(77982001)(87266001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 17:07 -0800, Greg Kroah-Hartman wrote:
> On Tue, Dec 03, 2013 at 12:34:46PM +0000, Kim Phillips wrote:
> > VFIO supports pass-through of devices to user space - for sake
> > of illustration, say a PCI e1000 device:
> > 
> > - the e1000 is first unbound from the PCI e1000 driver via sysfs
> > - the vfio-pci driver is told via new_id that it now handles e1000 devices
> > - the e1000 is explicitly bound to vfio-pci through sysfs
> > 
> > However, now we have two drivers in the system that both handle e1000
> > devices.  A hotplug event could then occur and it is ambiguous as to which
> > driver will claim the device.  The desired semantics is that vfio-pci is
> > only bound to devices by explicit request in sysfs.  This patch makes this
> > possible by introducing a sysfs_bind_only flag in struct device_driver.
> 
> Why deal with this at all and not just deal with the "bind" sysfs file
> instead?  That way no driver core logic needs to be changed at all, and
> your userspace tools know _exactly_ which device is being bound to the
> new device.
> 
> Don't mess with the "new_id" file for stuff like this, as you point out,
> it's "tricky"...

As discussed before, "bind" does not bypass the ID checks, and thus it
does not work without either "new_id" or a wildcard match.

Or are you proposing changing "bind" so that it does bypass the ID
checks?  Or perhaps a new "force_bind" file that does?

-Scott


