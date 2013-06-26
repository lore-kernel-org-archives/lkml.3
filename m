Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3FZDLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:11:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:40894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3FZDLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:11:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="335567569"
Message-ID: <1372216282.8177.4.camel@envy.home>
Subject: Re: [PATCH 8/8] pch_gbe: Add MinnowBoard support
From: Darren Hart <dvhart@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders@circuitco.com, vishal.l.verma@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date: Tue, 25 Jun 2013 20:11:22 -0700
In-Reply-To: <CAErSpo4PuKOqKM19Ra5D_jCH0SEtNTo95_EhyXVxYAB3J_27zg@mail.gmail.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <6c27e79870ec93f7a8c6692d4bcfebaee589fa6b.1372211451.git.dvhart@linux.intel.com>
	 <CAErSpo4PuKOqKM19Ra5D_jCH0SEtNTo95_EhyXVxYAB3J_27zg@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 20:35 -0600, Bjorn Helgaas wrote:
> On Tue, Jun 25, 2013 at 7:53 PM, Darren Hart <dvhart@linux.intel.com> wrote:

> >  static DEFINE_PCI_DEVICE_TABLE(pch_gbe_pcidev_id) = {
> >         {.vendor = PCI_VENDOR_ID_INTEL,
> >          .device = PCI_DEVICE_ID_INTEL_IOH1_GBE,
> > +        .subvendor = PCI_VENDOR_ID_CIRCUITCO,
> > +        .subdevice = PCI_DEVICE_ID_CIRCUITCO_MINNOWBOARD,
> 
> "MINNOWBOARD" seems like a pretty generic name for something that
> probably refers only to the gigabit ethernet device in the EG20T.  If
> you expect to use that same subdevice ID on other devices, I guess we
> can add PCI_DEVICE_ID_CIRCUITCO_MINNOWBOARD to pci_ids.h.  If it will
> only be used for the gigabit ethernet device, we would normally not
> add a #define for it and would just use the hex constant here (see the
> comment at the top of pci_ids.h).

The firmware populates the subsystem vendor and device ID for every
device on the PCH with PCI_VENDOR_ID_CIRCUITCO and
PCI_DEVICE_ID_CIRCUITCO_MINNOWBOARD, respectively. Currently I have
only made changes to pch_gbe to make use of it, but there is the
possibility of using this ID elsewhere. I don't currently have plans to
do so however. So if it is preferable, I can leave
PCI_VENDOR_ID_CIRCUITCO in pci_ids.h and use 0x0001 here for the
subsystem device ID.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

