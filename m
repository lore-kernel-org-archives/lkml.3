Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3KOQBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:01:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23960 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3KOQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:01:47 -0500
Message-ID: <52864537.3040800@oracle.com>
Date: Sat, 16 Nov 2013 00:00:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        jiri@resnulli.us, gregkh@linuxfoundation.org, oleg@redhat.com,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com,
        linux-mtd@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] list: introduce list_last_entry_or_null()
References: <5285A33C.4040808@oracle.com> <20131115141100.GA17659@infradead.org>
In-Reply-To: <20131115141100.GA17659@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/15 2013 22:11, Christoph Hellwig wrote:
> On Fri, Nov 15, 2013 at 12:29:48PM +0800, Jeff Liu wrote:
>> Hi Folks,
>>
>> This patch is trying to introduce a new list helper to retrieve the
>> last entry or return NULL if the list is empty corresponding to it,
>> which is inspired by Jiri Pirko's list_first_entry_or_null().
> 
> How did we end up with the stupid _or_null prefix there?  I think the
> functionality is useful, but the naming is way to verbose, especially
> given that a list_first_entry or list_last_entry that optimizes away
> that one check doesn't seem useful.
> Instead of encoding detailed semantics in the name a good kerneldoc
> comment is way better.
When it comes to this point, looks the name is really a bit verbose.
And yes, they have the same kernel doc to list_first_entry/list_last_entry.

But at rculist.h, we have another similar routine with this suffix, i.e,
list_fist_or_null_rcu().

Maybe we can figure out a better name and replace the existing code with it
as list_first_entry_or_null() has not yet been widely used, it mainly being
used in drivers code as per a grep against linux-next tree.
 
$ grep list_first_entry_or_null -r linux-next

./drivers/acpi/acpi_ipmi.c:		driver_data.selected_smi = list_first_entry_or_null(
./drivers/base/regmap/regmap.c:		async = list_first_entry_or_null(&map->async_free,
./drivers/base/regmap/regmap.c:		async = list_first_entry_or_null(&map->async_free,
./drivers/net/team/team.c:	port = list_first_entry_or_null(&team->port_list,
./drivers/net/ethernet/sfc/mcdi.c:		async = list_first_entry_or_null(
./drivers/net/ethernet/intel/i40e/i40e_main.c:	return list_first_entry_or_null(&vsi->mac_filter_list,
./drivers/net/vxlan.c:	rd = list_first_entry_or_null(&f->remotes, struct vxlan_rdst, list);
./drivers/of/irq.c:		desc = list_first_entry_or_null(&intc_parent_list,
./fs/xfs/xfs_trans_priv.h:	return list_first_entry_or_null(&ailp->xa_ail, struct xfs_log_item,
./net/nfc/digital_core.c:	cmd = list_first_entry_or_null(&ddev->cmd_queue, struct digital_cmd,
./net/nfc/digital_core.c:	cmd = list_first_entry_or_null(&ddev->cmd_queue, struct digital_cmd,


Thanks,
-Jeff
