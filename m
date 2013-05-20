Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3ETQDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:03:00 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:19088 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3ETQC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:56 -0400
Message-ID: <1369065770.4616.3.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v2 6/7] PCI: Make sure VF's driver get attached after
 PF's
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Or Gerlitz <or.gerlitz@gmail.com>, Greg Rose <gregory.v.rose@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "Gu Zheng" <guz.fnst@cn.fujitsu.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yan Burman <yanb@mellanox.com>, Sathya Perla <Sathya.Perla@emulex.com>,
        <netdev@vger.kernel.org>
Date: Mon, 20 May 2013 17:02:50 +0100
In-Reply-To: <519A1DFD.5080809@linux.intel.com>
References: <1368586102-17661-1-git-send-email-yinghai@kernel.org>
	 <20130515091248.00002fe3@unknown>
	 <CAJZOPZ+L1QJdHePd_x9RAoqZKyJAKHo+hA8T1UZoe8=ozT98RA@mail.gmail.com>
	 <519A1DFD.5080809@linux.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19878.004
X-TM-AS-Result: No--19.803500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 15:58 +0300, Eliezer Tamir wrote:
> On 20/05/2013 15:28, Or Gerlitz wrote:
> > On Wed, May 15, 2013 at 7:12 PM, Greg Rose <gregory.v.rose@intel.com> wrote:
> >
> >
> >> I'm really not a fan of this.  Seems to me the tail is wagging the dog
> >> here.  Fix the driver to work without a PF driver being present.
> >
> > Greg, Alex,
> >
> > As I wrote over the V1 thread, currently we can't go and patch mlx4 to
> > use the sysfs API nor defer the call from within our probe function to
> > enable sriov since  this requires some firmware change to allow
> > enabling SRIOV after some  resources are initialized/provisioned.
> > Hence the patch suggested here or any other patch we can agree on
> > which will make sure that VF probing is done only once the PF is ready
> > is preferred, I think.
> >
> Maybe do the following:
> 1. split the VF PCI IDs into a separate PCI_ID device table.
> 2. have two pci_driver structs, one for all of the PF IDS and one with 
> the VF IDS.
> 3. only register the first pci_driver struct from mlx4_init().
> 4. register the one for the VFs once your PFs are all up and ready.

But hotplug.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

