Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3KFDnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:43:18 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42654 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3KFDnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:43:17 -0500
Message-ID: <5279BACD.2080105@gmail.com>
Date: Wed, 06 Nov 2013 14:43:09 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Frank Haverkamp <haver@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de
Subject: Re: [PATCH 4/6] GenWQE Debugfs interfaces
References: <1383641074-13710-1-git-send-email-haver@linux.vnet.ibm.com> <1383641074-13710-5-git-send-email-haver@linux.vnet.ibm.com>
In-Reply-To: <1383641074-13710-5-git-send-email-haver@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 19:44, Frank Haverkamp wrote:
> Debugfs interfaces for the GenWQE card. Help to debug potential
> problems. Dump internal chip state for debugging and failure
> determination.
>
> Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
>             Michael Jung <MIJUNG@de.ibm.com>,
>             Michael Ruettger <michael@ibmra.de>

Couple of comments below.

~Ryan

> ---
>  Documentation/ABI/testing/debugfs-driver-genwqe |   70 +++
>  drivers/misc/genwqe/card_debugfs.c              |  579 +++++++++++++++++++++++
>  2 files changed, 649 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/debugfs-driver-genwqe
>  create mode 100644 drivers/misc/genwqe/card_debugfs.c
>
> diff --git a/Documentation/ABI/testing/debugfs-driver-genwqe b/Documentation/ABI/testing/debugfs-driver-genwqe
> new file mode 100644
> index 0000000..548883a
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-driver-genwqe
> @@ -0,0 +1,70 @@
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/ddcb_info
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    DDCB queue dump used for debugging queueing problems.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_regs
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Dump of the current error registers.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_uid0
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Internal chip state of UID0 (unit id 0).
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_uid1
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Internal chip state of UID1.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_uid2
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Internal chip state of UID2.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_regs
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Dump of the error registers before the last reset of
> +                the card occured.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_uid0
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Internal chip state of UID0 before card was reset.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_uid1
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Internal chip state of UID1 before card was reset.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_uid2
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Internal chip state of UID2 before card was reset.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/info
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Comprehensive summary of bitstream version and software
> +                version. Used bitstream and bitstream clocking information.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/err_inject
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Possibility to inject error cases to ensure that the drivers
> +                error handling code works well.
> +
> +What:           /sys/kernel/debug/genwqe/genwqe<n>_card/vf<0..14>_jobtimeout_msec
> +Date:           Oct 2013
> +Contact:        haver@linux.vnet.ibm.com
> +Description:    Default VF timeout 250ms. Testing might require 1000ms.
> +                Using 0 will use the cards default value (whatever that is).
> +
> +                The timeout depends on the max number of available cards
> +                in the system and the maximum allowed queue size.
> +
> +                The driver ensures that the settings are done just before
> +                the VFs get enabled. Changing the timeouts in flight is not
> +                possible.
> diff --git a/drivers/misc/genwqe/card_debugfs.c b/drivers/misc/genwqe/card_debugfs.c
> new file mode 100644
> index 0000000..ebf2f93
> --- /dev/null
> +++ b/drivers/misc/genwqe/card_debugfs.c
> @@ -0,0 +1,579 @@
> +/**
> + * IBM Accelerator Family 'GenWQE'
> + *
> + * (C) Copyright IBM Corp. 2013
> + *
> + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> + * Author: Michael Jung <mijung@de.ibm.com>
> + * Author: Michael Ruettger <michael@ibmra.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License (version 2 only)
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +/*
> + * Debugfs interfaces for the GenWQE card. Help to debug potential
> + * problems. Dump internal chip state for debugging and failure
> + * determination.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/uaccess.h>
> +
> +#include "card_base.h"
> +#include "card_ddcb.h"
> +
> +static void DBG_UIDn_show(struct seq_file *s, struct genwqe_reg *regs,
> +			 int entries)

What's with the weird capitalisation in the function names? Function
names should be lower case, and use underscores as a separator.

> +{
> +	unsigned int i;
> +	u32 v_hi, v_lo;
> +
> +	for (i = 0; i < entries; i++) {
> +		v_hi = (regs[i].val >> 32) & 0xffffffff;
> +		v_lo = (regs[i].val)       & 0xffffffff;
> +
> +		seq_printf(s, "  0x%08x 0x%08x 0x%08x 0x%08x EXT_ERR_REC\n",
> +			   regs[i].addr, regs[i].idx, v_hi, v_lo);
> +	}
> +}
> +
> +static int curr_DBG_UIDn_show(struct seq_file *s, void *unused, int uid)
> +{
> +	struct genwqe_dev *cd = s->private;
> +	int entries;
> +	struct genwqe_reg *regs;
> +
> +	entries = genwqe_ffdc_buff_size(cd, uid);
> +	if (entries < 0)
> +		return -EINVAL;
> +
> +	if (entries == 0)
> +		return 0;
> +
> +	regs = kzalloc(entries * sizeof(*regs), GFP_ATOMIC);
> +	if (regs == NULL)
> +		return -ENOMEM;
> +
> +	genwqe_stop_traps(cd); /* halt the traps while dumping data */
> +	genwqe_ffdc_buff_read(cd, uid, regs, entries);
> +	genwqe_start_traps(cd);
> +
> +	DBG_UIDn_show(s, regs, entries);
> +	kfree(regs);
> +	return 0;
> +}
> +
> +static int genwqe_curr_DBG_UID0_show(struct seq_file *s, void *unused)
> +{
> +	return curr_DBG_UIDn_show(s, unused, 0);
> +}
> +
> +static int genwqe_curr_DBG_UID0_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_curr_DBG_UID0_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_curr_DBG_UID0_fops = {
> +	.open = genwqe_curr_DBG_UID0_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};

You could create macros like sysfs has to get rid of all the
boiler-plate code, something like (not tested):

  #define GENWQE_DEBUGFS(_name, _showfn)                                         \ 
      static int genwqe_debugfs_##_name##_open(struct seq_file *s, void *unused) \
      {                                                                          \
              return single_open(file, _showfn, inode->i_private);               \
      }                                                                          \
      static const struct file_operations genwqe_##_name##_fops = {              \
              .open = genwqe_debugfs_##_name##_open,                             \
              .read = seq_read,                                                  \
              .llseek = seq_lseek,                                               \
              .release = single_release,                                         \
      } 


> +
> +static int genwqe_curr_DBG_UID1_show(struct seq_file *s, void *unused)
> +{
> +	return curr_DBG_UIDn_show(s, unused, 1);
> +}
> +
> +static int genwqe_curr_DBG_UID1_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_curr_DBG_UID1_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_curr_DBG_UID1_fops = {
> +	.open = genwqe_curr_DBG_UID1_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int genwqe_curr_DBG_UID2_show(struct seq_file *s, void *unused)
> +{
> +	return curr_DBG_UIDn_show(s, unused, 2);
> +}
> +
> +static int genwqe_curr_DBG_UID2_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_curr_DBG_UID2_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_curr_DBG_UID2_fops = {
> +	.open = genwqe_curr_DBG_UID2_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int prev_DBG_UIDn_show(struct seq_file *s, void *unused, int uid)
> +{
> +	struct genwqe_dev *cd = s->private;
> +
> +	DBG_UIDn_show(s, cd->ffdc[uid].regs,  cd->ffdc[uid].entries);
> +	return 0;
> +}
> +
> +static int genwqe_prev_DBG_UID0_show(struct seq_file *s, void *unused)
> +{
> +	return prev_DBG_UIDn_show(s, unused, 0);
> +}
> +
> +static int genwqe_prev_DBG_UID0_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_prev_DBG_UID0_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_prev_DBG_UID0_fops = {
> +	.open = genwqe_prev_DBG_UID0_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int genwqe_prev_DBG_UID1_show(struct seq_file *s, void *unused)
> +{
> +	return prev_DBG_UIDn_show(s, unused, 1);
> +}
> +
> +static int genwqe_prev_DBG_UID1_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_prev_DBG_UID1_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_prev_DBG_UID1_fops = {
> +	.open = genwqe_prev_DBG_UID1_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int genwqe_prev_DBG_UID2_show(struct seq_file *s, void *unused)
> +{
> +	return prev_DBG_UIDn_show(s, unused, 2);
> +}
> +
> +static int genwqe_prev_DBG_UID2_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_prev_DBG_UID2_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_prev_DBG_UID2_fops = {
> +	.open = genwqe_prev_DBG_UID2_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int genwqe_curr_regs_show(struct seq_file *s, void *unused)
> +{
> +	struct genwqe_dev *cd = s->private;
> +	unsigned int i;
> +	struct genwqe_reg *regs;
> +
> +	regs = kzalloc(GENWQE_FFDC_REGS * sizeof(*regs), GFP_ATOMIC);

Use kcalloc when multiplying in the size argument. Why is the allocation
GFP_ATOMIC here?

> +	if (regs == NULL)
> +		return -ENOMEM;
> +
> +	genwqe_stop_traps(cd);
> +	genwqe_read_ffdc_regs(cd, regs, GENWQE_FFDC_REGS, 1);
> +	genwqe_start_traps(cd);
> +
> +	for (i = 0; i < GENWQE_FFDC_REGS; i++) {
> +		if (regs[i].addr == 0xffffffff)
> +			break;  /* invalid entries */
> +
> +		if (regs[i].val == 0x0ull)
> +			continue;  /* do not print 0x0 FIRs */
> +
> +		seq_printf(s, "  0x%08x 0x%016llx\n",
> +			   regs[i].addr, regs[i].val);
> +	}
> +	return 0;
> +}
> +
> +static int genwqe_curr_regs_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_curr_regs_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_curr_regs_fops = {
> +	.open = genwqe_curr_regs_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int genwqe_prev_regs_show(struct seq_file *s, void *unused)
> +{
> +	struct genwqe_dev *cd = s->private;
> +	unsigned int i;
> +	struct genwqe_reg *regs = cd->ffdc[GENWQE_DBG_REGS].regs;
> +
> +	if (regs == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < GENWQE_FFDC_REGS; i++) {
> +		if (regs[i].addr == 0xffffffff)
> +			break;  /* invalid entries */
> +
> +		if (regs[i].val == 0x0ull)
> +			continue;  /* do not print 0x0 FIRs */
> +
> +		seq_printf(s, "  0x%08x 0x%016llx\n",
> +			   regs[i].addr, regs[i].val);
> +	}
> +	return 0;
> +}
> +
> +static int genwqe_prev_regs_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_prev_regs_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_prev_regs_fops = {
> +	.open = genwqe_prev_regs_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int genwqe_jtimer_show(struct seq_file *s, void *unused)
> +{
> +	struct genwqe_dev *cd = s->private;
> +	unsigned int vf_num;
> +	u64 jtimer;
> +
> +	jtimer = genwqe_read_jtimer(cd, 0);
> +	seq_printf(s, "  PF   0x%016llx %d msec\n", jtimer,
> +		   genwqe_pf_jobtimeout_msec);
> +
> +	for (vf_num = 0; vf_num < cd->num_vfs; vf_num++) {
> +		jtimer = genwqe_read_jtimer(cd, vf_num + 1);
> +		seq_printf(s, "  VF%-2d 0x%016llx %d msec\n", vf_num, jtimer,
> +			   cd->vf_jobtimeout_msec[vf_num]);
> +	}
> +	return 0;
> +}
> +
> +static int genwqe_jtimer_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_jtimer_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_jtimer_fops = {
> +	.open = genwqe_jtimer_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int genwqe_ddcb_info_show(struct seq_file *s, void *unused)
> +{
> +	struct genwqe_dev *cd = s->private;
> +	unsigned int i;
> +	struct ddcb_queue *queue;
> +	struct ddcb *pddcb;
> +
> +	queue = &cd->queue;
> +	seq_puts(s, "DDCB QUEUE:\n");
> +	seq_printf(s, "  ddcb_max:            %d\n"
> +		   "  ddcb_daddr:          %016llx - %016llx\n"
> +		   "  ddcb_vaddr:          %016llx\n"
> +		   "  ddcbs_in_flight:     %u\n"
> +		   "  ddcbs_max_in_flight: %u\n"
> +		   "  ddcbs_completed:     %u\n"
> +		   "  busy:                %u\n"
> +		   "  irqs_processed:      %u\n",
> +		   queue->ddcb_max, (long long)queue->ddcb_daddr,
> +		   (long long)queue->ddcb_daddr +
> +		   (queue->ddcb_max * DDCB_LENGTH),
> +		   (long long)queue->ddcb_vaddr, queue->ddcbs_in_flight,
> +		   queue->ddcbs_max_in_flight, queue->ddcbs_completed,
> +		   queue->busy, cd->irqs_processed);
> +
> +	/* Hardware State */
> +	seq_printf(s, "  0x%08x 0x%016llx IO_QUEUE_CONFIG\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_STATUS\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_SEGMENT\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_INITSQN\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_WRAP\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_OFFSET\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_WTIME\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_ERRCNTS\n"
> +		   "  0x%08x 0x%016llx IO_QUEUE_LRW\n",
> +		   queue->IO_QUEUE_CONFIG,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_CONFIG),
> +		   queue->IO_QUEUE_STATUS,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_STATUS),
> +		   queue->IO_QUEUE_SEGMENT,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_SEGMENT),
> +		   queue->IO_QUEUE_INITSQN,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_INITSQN),
> +		   queue->IO_QUEUE_WRAP,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_WRAP),
> +		   queue->IO_QUEUE_OFFSET,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_OFFSET),
> +		   queue->IO_QUEUE_WTIME,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_WTIME),
> +		   queue->IO_QUEUE_ERRCNTS,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_ERRCNTS),
> +		   queue->IO_QUEUE_LRW,
> +		   __genwqe_readq(cd, queue->IO_QUEUE_LRW));
> +
> +	seq_printf(s, "DDCB list (ddcb_act=%d/ddcb_next=%d):\n",
> +		   queue->ddcb_act, queue->ddcb_next);
> +
> +	pddcb = queue->ddcb_vaddr;
> +	for (i = 0; i < queue->ddcb_max; i++) {
> +		seq_printf(s, "  %-3d: RETC=%03x SEQ=%04x HSI/SHI=%02x/%02x ",
> +			   i, be16_to_cpu(pddcb->retc_16),
> +			   be16_to_cpu(pddcb->seqnum_16),
> +			   pddcb->hsi, pddcb->shi);
> +		seq_printf(s, "PRIV=%06llx CMD=%02x\n",
> +			   be64_to_cpu(pddcb->priv_64), pddcb->cmd);
> +		pddcb++;
> +	}
> +	return 0;
> +}
> +
> +static int genwqe_ddcb_info_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_ddcb_info_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_ddcb_info_fops = {
> +	.open = genwqe_ddcb_info_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +
> +static int genwqe_info_show(struct seq_file *s, void *unused)
> +{
> +	struct genwqe_dev *cd = s->private;
> +	u16 val16, type;
> +	u64 app_id, slu_id, bitstream = -1;
> +	struct pci_dev *pci_dev = cd->pci_dev;
> +
> +	slu_id = __genwqe_readq(cd, IO_SLU_UNITCFG);
> +	app_id = __genwqe_readq(cd, IO_APP_UNITCFG);
> +
> +	if (genwqe_is_privileged(cd))
> +		bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM);
> +
> +	val16 = (u16)(slu_id & 0x0fLLU);
> +	type  = (u16)((slu_id >> 20) & 0xffLLU);
> +
> +	seq_printf(s, "%s driver version: %s\n"
> +		   "    Device Name/Type: %s %s CardIdx: %d\n"
> +		   "    SLU/APP Config  : 0x%016llx/0x%016llx\n"
> +		   "    Build Date      : %u/%x/%u\n"
> +		   "    Base Clock      : %u MHz\n"
> +		   "    Arch/SVN Release: %u/%llx\n"
> +		   "    Bitstream       : %llx\n",
> +		   GENWQE_DEVNAME, DRV_VERS_STRING, dev_name(&pci_dev->dev),
> +		   genwqe_is_privileged(cd) ?
> +		   "Physical" : "Virtual or no SR-IOV",
> +		   cd->card_idx, slu_id, app_id,
> +		   (u16)((slu_id >> 12) & 0x0fLLU),	   /* month */
> +		   (u16)((slu_id >>  4) & 0xffLLU),	   /* day */
> +		   (u16)((slu_id >> 16) & 0x0fLLU) + 2010, /* year */
> +		   genwqe_base_clock_frequency(cd),
> +		   (u16)((slu_id >> 32) & 0xffLLU), slu_id >> 40,
> +		   bitstream);
> +
> +	return 0;
> +}
> +
> +static int genwqe_info_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, genwqe_info_show, inode->i_private);
> +}
> +
> +static const struct file_operations genwqe_info_fops = {
> +	.open = genwqe_info_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +int genwqe_init_debugfs(struct genwqe_dev *cd)
> +{
> +	struct dentry *root;
> +	struct dentry *file;
> +	int ret, priv;
> +	char card_name[64];
> +	char name[64];
> +	unsigned int i;
> +
> +	sprintf(card_name, "%s%u_card", GENWQE_DEVNAME, cd->card_idx);
> +
> +	root = debugfs_create_dir(card_name, cd->debugfs_genwqe);
> +	if (!root) {
> +		ret = -ENOMEM;
> +		goto err0;
> +	}
> +	priv = genwqe_is_privileged(cd);
> +
> +	/* non privileged interfaces are done here */
> +	file = debugfs_create_file("ddcb_info", S_IRUGO, root, cd,
> +				   &genwqe_ddcb_info_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("info", S_IRUGO, root, cd,
> +				   &genwqe_info_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_x64("debug", 0666, root, &cd->debug);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_x64("err_inject", 0666, root, &cd->err_inject);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_u32("ddcb_software_timeout", 0666, root,
> +				  &cd->ddcb_software_timeout);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_u32("kill_timeout", 0666, root,
> +				  &cd->kill_timeout);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	/* privileged interfaces follow here */
> +	if (!priv) {
> +		cd->debugfs_root = root;
> +		return 0;
> +	}
> +
> +	file = debugfs_create_file("curr_regs", S_IRUGO, root, cd,
> +				   &genwqe_curr_regs_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("curr_dbg_uid0", S_IRUGO, root, cd,
> +				   &genwqe_curr_DBG_UID0_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("curr_dbg_uid1", S_IRUGO, root, cd,
> +				   &genwqe_curr_DBG_UID1_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("curr_dbg_uid2", S_IRUGO, root, cd,
> +				   &genwqe_curr_DBG_UID2_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("prev_regs", S_IRUGO, root, cd,
> +				   &genwqe_prev_regs_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("prev_dbg_uid0", S_IRUGO, root, cd,
> +				   &genwqe_prev_DBG_UID0_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("prev_dbg_uid1", S_IRUGO, root, cd,
> +				   &genwqe_prev_DBG_UID1_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_file("prev_dbg_uid2", S_IRUGO, root, cd,
> +				   &genwqe_prev_DBG_UID2_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	for (i = 0; i <  GENWQE_MAX_VFS; i++) {
> +		sprintf(name, "vf%d_jobtimeout_msec", i);
> +
> +		file = debugfs_create_u32(name, 0666, root,
> +					  &cd->vf_jobtimeout_msec[i]);
> +		if (!file) {
> +			ret = -ENOMEM;
> +			goto err1;
> +		}
> +	}
> +
> +	file = debugfs_create_file("jobtimer", S_IRUGO, root, cd,
> +				   &genwqe_jtimer_fops);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	file = debugfs_create_u32("skip_recovery", 0666, root,
> +				  &cd->skip_recovery);
> +	if (!file) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	cd->debugfs_root = root;
> +	return 0;
> +err1:
> +	debugfs_remove_recursive(root);
> +err0:
> +	return ret;
> +}
> +
> +void genqwe_exit_debugfs(struct genwqe_dev *cd)
> +{
> +	debugfs_remove_recursive(cd->debugfs_root);
> +}

