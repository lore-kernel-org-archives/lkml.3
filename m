Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBJXNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:13:01 -0500
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:45163
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752339AbaBJXM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:12:57 -0500
Message-ID: <1392073951.6733.383.camel@snotra.buserror.net>
Subject: Re: [RFC PATCH v4 06/10] VFIO_PLATFORM: Read and write support for
 the device fd
From: Scott Wood <scottwood@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Antonios Motakis <a.motakis@virtualopensystems.com>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <tech@virtualopensystems.com>, <a.rigo@virtualopensystems.com>,
        <B08248@freescale.com>, <kim.phillips@linaro.org>,
        <jan.kiszka@siemens.com>, <kvm@vger.kernel.org>,
        <R65777@freescale.com>, <B07421@freescale.com>,
        <christoffer.dall@linaro.org>, <agraf@suse.de>, <B16395@freescale.com>,
        <will.deacon@arm.com>
Date: Mon, 10 Feb 2014 17:12:31 -0600
In-Reply-To: <1392072326.15608.181.camel@ul30vt.home>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1391880580-471-7-git-send-email-a.motakis@virtualopensystems.com>
	 <1392072326.15608.181.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR05CA004.namprd05.prod.outlook.com (10.141.96.24) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0118CD8765
X-Forefront-Antispam-Report: =?utf-8?B?U0ZWOk5TUE07U0ZTOigxMDAwOTAwMSkoOTc5MDAyKSg2MDA5MDAxKSgyNDQ1?=
 =?utf-8?B?NDAwMikoMTY0MDU0MDAzKSg1MTcwNDAwNSkoMzc3NDI0MDA0KSgxODkwMDIp?=
 =?utf-8?B?KDE5OTAwMikoODE2ODYwMDEpKDY1ODE2MDAxKSg4MTgxNjAwMSkoODcyODYw?=
 =?utf-8?B?MDEpKDYzNjk2MDAyKSg4Nzk3NjAwMSkoODcyNjYwMDEpKDU2ODE2MDA1KSg4?=
 =?utf-8?B?OTk5NjAwMSkoNzcwOTYwMDEpKDkyNTY2MDAxKSg0Nzc3NjAwMykoOTI3MjYw?=
 =?utf-8?B?MDEpKDMxOTY2MDA4KSg3NzE1NjAwMSkoODU4NTIwMDMpKDgzMDcyMDAyKSg0?=
 =?utf-8?B?NzQ0NjAwMikoODAwMjIwMDEpKDc0NjYyMDAxKSg4NTMwNjAwMikoODgxMzYw?=
 =?utf-8?B?MDIpKDkzMTM2MDAxKSg3NDUwMjAwMSkoOTAxNDYwMDEpKDc2Nzk2MDAxKSg5?=
 =?utf-8?B?NTQxNjAwMSkoOTM5MTYwMDIpKDkzNTE2MDAyKSg5NDk0NjAwMSkoOTQzMTYw?=
 =?utf-8?B?MDIpKDgxNTQyMDAxKSg2Mjk2NjAwMikoNzQ3MDYwMDEpKDQ2MTAyMDAxKSg1?=
 =?utf-8?B?MzgwNjAwMSkoNDIxODYwMDQpKDc0ODc2MDAxKSg1NDMxNjAwMikoNTY3NzYw?=
 =?utf-8?B?MDEpKDc2NDgyMDAxKSg0Mzk2MDAxKSg0OTg2NjAwMSkoNTAyMjYwMDEpKDQ3?=
 =?utf-8?B?NzM2MDAxKSg0Nzk3NjAwMSkoNTA5ODYwMDEpKDUxODU2MDAxKSg4MTM0MjAw?=
 =?utf-8?B?MSkoMzM2NDYwMDEpKDIzNjc2MDAyKSg1MDQ2NjAwMikoODYzNjIwMDEpKDc0?=
 =?utf-8?B?MzY2MDAxKSg2OTIyNjAwMSkoNzY3ODYwMDEpKDgwOTc2MDAxKSg3OTEwMjAw?=
 =?utf-8?B?MSkoOTU2NjYwMDEpKDE5NTgwNDA1MDAxKSg1OTc2NjAwMSkoNzc5ODIwMDEp?=
 =?utf-8?B?KDE5NTgwMzk1MDAzKSg4MzMyMjAwMSkoMzgyNjAwMSkoMjE3ODczMDAxKSg5?=
 =?utf-8?B?NjkwMDMpKDk4OTAwMSkoOTk5MDAxKSgxMDA5MDAxKSgxMDE5MDAxKTtESVI6?=
 =?utf-8?B?T1VUO1NGUDoxMTAxO1NDTDoxO1NSVlI6RE0yUFIwM01CMzk4O0g6W0lQdjY6?=
 =?utf-8?B?MjYwMToyOjU4MDA6M2Y3OjEyYmY6NDhmZjpmZTg0OmM5YTBdO0NMSVA6MjYw?=
 =?utf-8?B?MToyOjU4MDA6M2Y3OjEyYmY6NDhmZjpmZTg0OmM5YTA7RlBSOkZDODVGMjRD?=
 =?utf-8?B?LjhGMjIxNzkxLjc4Qzc5RDhGLjgyRERGQTMxLjIwM0RDO0luZm9Ob1JlY29y?=
 =?utf-8?Q?dsMX:1;A:1;LANG:en;?=
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 15:45 -0700, Alex Williamson wrote:
> On Sat, 2014-02-08 at 18:29 +0100, Antonios Motakis wrote:
> > VFIO returns a file descriptor which we can use to manipulate the memory
> > regions of the device. Since some memory regions we cannot mmap due to
> > security concerns, we also allow to read and write to this file descriptor
> > directly.
> > 
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > Tested-by: Alvise Rigo <a.rigo@virtualopensystems.com>
> > ---
> >  drivers/vfio/platform/vfio_platform.c | 128 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 125 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> > index f7db5c0..ee96078 100644
> > --- a/drivers/vfio/platform/vfio_platform.c
> > +++ b/drivers/vfio/platform/vfio_platform.c
> > @@ -55,7 +55,8 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
> >  
> >  		region.addr = res->start;
> >  		region.size = resource_size(res);
> > -		region.flags = 0;
> > +		region.flags = VFIO_REGION_INFO_FLAG_READ
> > +				| VFIO_REGION_INFO_FLAG_WRITE;
> >  
> >  		vdev->region[i] = region;
> >  	}
> > @@ -150,13 +151,134 @@ static long vfio_platform_ioctl(void *device_data,
> >  static ssize_t vfio_platform_read(void *device_data, char __user *buf,
> >  			     size_t count, loff_t *ppos)
> >  {
> > -	return 0;
> > +	struct vfio_platform_device *vdev = device_data;
> > +	unsigned int *io;
> > +	int i;
> > +
> > +	for (i = 0; i < vdev->num_regions; i++) {
> > +		struct vfio_platform_region region = vdev->region[i];
> > +		unsigned int done = 0;
> > +		loff_t off;
> > +
> > +		if ((*ppos < region.addr)
> > +		     || (*ppos + count - 1) >= (region.addr + region.size))
> > +			continue;
> 
> Perhaps there's something to be said for vfio-pci's use of fixed offsets
> to have a direct offset to index lookup.
> 
> > +
> > +		io = ioremap_nocache(region.addr, region.size);
> 
> This must incur some overhead per access.

There's mmap() if you want fast...  Given the limited ioremap space on
32-bit, I can see not wanting to map everything that the user has open
all the time -- but in that case, wouldn't it be better to just map one
page here rather than the whole region?

> > +
> > +		off = *ppos - region.addr;
> > +
> > +		while (count) {
> > +			size_t filled;
> > +
> > +			if (count >= 4 && !(off % 4)) {
> > +				u32 val;
> > +
> > +				val = ioread32(io + off);
> > +				if (copy_to_user(buf, &val, 4))
> > +					goto err;
> 
> For vfio-pci we've decided that these interfaces are always little
> endian, have you considered whether it makes sense to do something
> similar here?  Thanks,

ioread32() is little endian -- but since read() puts its result in the
caller's memory buffer (rather than a register return), I think it makes
more sense to preserve byte-invariance -- similar to the conclusion of
the recent KVM MMIO API clarification discussion.  Then the VFIO user
would use the same type of access (byte swapped or not) to access the
read() buffer that they would have used to access the register directly.

Forcing little endian is a better fit for PCI (which is inherently
little endian) than for platform devices which can be either endianness.

-Scott


