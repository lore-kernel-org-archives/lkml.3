Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaLRBBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:01:09 -0500
Received: from mail-by2on0120.outbound.protection.outlook.com ([207.46.100.120]:58843
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaLRBBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:01:08 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Add device and vendor ID to vmbus
 devices
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Add device and vendor ID to
 vmbus devices
Thread-Index: AQHQGkJD3ht/52TqOEWFS+5csP4NhJyUe2qAgAACXBA=
Date: Thu, 18 Dec 2014 00:46:36 +0000
Message-ID: <BY2PR0301MB0711665F8B00EC1967171731A06A0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418856744-16359-1-git-send-email-kys@microsoft.com>
 <20141218001711.GA6944@kroah.com>
In-Reply-To: <20141218001711.GA6944@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::2]
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-forefront-prvs: 042957ACD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377454003)(24454002)(13464003)(51704005)(199003)(21056001)(76176999)(19580405001)(86362001)(92566001)(86612001)(62966003)(77156002)(4396001)(54206007)(19580395003)(54356999)(74316001)(87936001)(122556002)(2656002)(64706001)(20776003)(76576001)(50986999)(33656002)(46102003)(68736005)(99396003)(101416001)(97736003)(107046002)(102836002)(105586002)(31966008)(54606007)(106356001)(120916001)(110136001)(99286002)(40100003)(106116001)(2950100001)(2900100001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, December 17, 2014 4:17 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add device and vendor ID to
> vmbus devices
> 
> On Wed, Dec 17, 2014 at 02:52:24PM -0800, K. Y. Srinivasan wrote:
> > Add vendor and device ID attributes to vmbus devices. This would allow
> > us to support vmbus based devices that can support guest RDMA.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/vmbus_drv.c |   20 ++++++++++++++++++++
> >  include/linux/hyperv.h |    2 ++
> >  2 files changed, 22 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c index
> > 4d6b269..215aac9 100644
> > --- a/drivers/hv/vmbus_drv.c
> > +++ b/drivers/hv/vmbus_drv.c
> > @@ -385,6 +385,24 @@ static ssize_t in_write_bytes_avail_show(struct
> > device *dev,  }  static DEVICE_ATTR_RO(in_write_bytes_avail);
> >
> > +static ssize_t vendor_show(struct device *dev,
> > +			   struct device_attribute *dev_atttr,
> > +			   char *buf)
> > +{
> > +	struct hv_device *hv_dev = device_to_hv_device(dev);
> > +	return sprintf(buf, "0x%x\n", hv_dev->vendor_id); } static
> > +DEVICE_ATTR_RO(vendor);
> > +
> > +static ssize_t device_show(struct device *dev,
> > +			   struct device_attribute *dev_atttr,
> > +			   char *buf)
> > +{
> > +	struct hv_device *hv_dev = device_to_hv_device(dev);
> > +	return sprintf(buf, "0x%x\n", hv_dev->device_id); } static
> > +DEVICE_ATTR_RO(device);
> > +
> >  /* Set up per device attributes in /sys/bus/vmbus/devices/<bus
> > device> */  static struct attribute *vmbus_attrs[] = {
> >  	&dev_attr_id.attr,
> > @@ -409,6 +427,8 @@ static struct attribute *vmbus_attrs[] = {
> >  	&dev_attr_in_write_index.attr,
> >  	&dev_attr_in_read_bytes_avail.attr,
> >  	&dev_attr_in_write_bytes_avail.attr,
> > +	&dev_attr_vendor.attr,
> > +	&dev_attr_device.attr,
> >  	NULL,
> >  };
> >  ATTRIBUTE_GROUPS(vmbus);
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h index
> > 476c685..6fe4dfe 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -891,6 +891,8 @@ struct hv_device {
> >
> >  	/* the device instance id of this device */
> >  	uuid_le dev_instance;
> > +	u16 vendor_id;
> > +	u16 device_id;
> >
> >  	struct device device;
> >
> 
> You are adding new sysfs files without proper Documentation/ABI/ updates
> as well?  You know better than that...
> 
> And I don't see anything setting these fields, seems kind of pointless as-is,
> right?

Greg, 

You are right, nothing sets these fields today but I am working on a guest infiniband  RDMA driver that  uses this.
This driver registers itself as an infiniband HW driver and the vendor device id is needed for IHV libraries to discover this driver from user mode.  In some sense, these two fields are equivalent to the vendor ID and device of standard PCI devices as this VMBUS based infiniband driver needs to masquerade as the infiniband card in the host that is being presented to the guest.

I can resubmit this patch with the additional documentation.

Regards,

K. Y



