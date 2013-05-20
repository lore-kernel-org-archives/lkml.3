Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3ETQHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:07:22 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:19183 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3ETQHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:07:19 -0400
Message-ID: <1369066035.4616.6.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v2 6/7] PCI: Make sure VF's driver get attached after
 PF's
From: Ben Hutchings <bhutchings@solarflare.com>
To: Or Gerlitz <or.gerlitz@gmail.com>
CC: Greg Rose <gregory.v.rose@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yan Burman <yanb@mellanox.com>, Sathya Perla <Sathya.Perla@emulex.com>,
        <netdev@vger.kernel.org>
Date: Mon, 20 May 2013 17:07:15 +0100
In-Reply-To: <CAJZOPZ+L1QJdHePd_x9RAoqZKyJAKHo+hA8T1UZoe8=ozT98RA@mail.gmail.com>
References: <1368586102-17661-1-git-send-email-yinghai@kernel.org>
	 <20130515091248.00002fe3@unknown>
	 <CAJZOPZ+L1QJdHePd_x9RAoqZKyJAKHo+hA8T1UZoe8=ozT98RA@mail.gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19878.004
X-TM-AS-Result: No--21.917800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 15:28 +0300, Or Gerlitz wrote:
> On Wed, May 15, 2013 at 7:12 PM, Greg Rose <gregory.v.rose@intel.com> wrote:
> 
> 
> > I'm really not a fan of this.  Seems to me the tail is wagging the dog
> > here.  Fix the driver to work without a PF driver being present.
> 
> Greg, Alex,
> 
> As I wrote over the V1 thread, currently we can't go and patch mlx4 to
> use the sysfs API nor defer the call from within our probe function to
> enable sriov since  this requires some firmware change to allow
> enabling SRIOV after some  resources are initialized/provisioned.
> Hence the patch suggested here or any other patch we can agree on
> which will make sure that VF probing is done only once the PF is ready
> is preferred, I think.
> 
> I wasn't sure to totally follow on the argument that things need to
> work when the PF is absent in the sense there's no driver instance
> around over which the PF is probed, if you can explain little better,
> that would help.

It might be sufficient to return -EPROBE_DEFER from the VF probe
function when the PF is not yet ready, if you can easily detect that.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

