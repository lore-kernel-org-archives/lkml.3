Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3ETM6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:58:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:60468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab3ETM6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:58:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="244120244"
Message-ID: <519A1DFD.5080809@linux.intel.com>
Date: Mon, 20 May 2013 15:58:37 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Or Gerlitz <or.gerlitz@gmail.com>
CC: Greg Rose <gregory.v.rose@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yan Burman <yanb@mellanox.com>, Sathya Perla <Sathya.Perla@emulex.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] PCI: Make sure VF's driver get attached after
 PF's
References: <1368586102-17661-1-git-send-email-yinghai@kernel.org> <20130515091248.00002fe3@unknown> <CAJZOPZ+L1QJdHePd_x9RAoqZKyJAKHo+hA8T1UZoe8=ozT98RA@mail.gmail.com>
In-Reply-To: <CAJZOPZ+L1QJdHePd_x9RAoqZKyJAKHo+hA8T1UZoe8=ozT98RA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2013 15:28, Or Gerlitz wrote:
> On Wed, May 15, 2013 at 7:12 PM, Greg Rose <gregory.v.rose@intel.com> wrote:
>
>
>> I'm really not a fan of this.  Seems to me the tail is wagging the dog
>> here.  Fix the driver to work without a PF driver being present.
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
Maybe do the following:
1. split the VF PCI IDs into a separate PCI_ID device table.
2. have two pci_driver structs, one for all of the PF IDS and one with 
the VF IDS.
3. only register the first pci_driver struct from mlx4_init().
4. register the one for the VFs once your PFs are all up and ready.

Eliezer
