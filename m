Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3AaB7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:59:01 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1761 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3AaB67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:58:59 -0500
Message-ID: <1359596935.15120.110.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH v2 03/12] drivers/base: Add system device hotplug
 framework
From: Toshi Kani <toshi.kani@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Wed, 30 Jan 2013 18:48:55 -0700
In-Reply-To: <20130130045437.GG30002@kroah.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
	 <1357861230-29549-4-git-send-email-toshi.kani@hp.com>
	 <20130130045437.GG30002@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 23:54 -0500, Greg KH wrote:
> On Thu, Jan 10, 2013 at 04:40:21PM -0700, Toshi Kani wrote:
> > Added sys_hotplug.c, which is the system device hotplug framework code.
> > 
> > shp_register_handler() allows modules to register their hotplug handlers
> > to the framework.  shp_submit_req() provides the interface to submit
> > a hotplug or online/offline request of system devices.  The request is
> > then put into hp_workqueue.  shp_start_req() calls all registered handlers
> > in ascending order for each phase.  If any handler failed in validate or
> > execute phase, shp_start_req() initiates its rollback procedure.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  drivers/base/Makefile      |    1 
> >  drivers/base/sys_hotplug.c |  313 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 314 insertions(+)
> >  create mode 100644 drivers/base/sys_hotplug.c
> > 
> > diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> > index 5aa2d70..2e9b2f1 100644
> > --- a/drivers/base/Makefile
> > +++ b/drivers/base/Makefile
> > @@ -21,6 +21,7 @@ endif
> >  obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
> >  obj-$(CONFIG_REGMAP)	+= regmap/
> >  obj-$(CONFIG_SOC_BUS) += soc.o
> > +obj-y			+= sys_hotplug.o
> 
> No option to select this for systems that don't need it?  If not, then
> put it up higher with all of the other code for the core.

It used to have CONFIG_HOTPLUG, but I removed it as you suggested.  Yes,
I will put it up higher.  

Thanks,
-Toshi


