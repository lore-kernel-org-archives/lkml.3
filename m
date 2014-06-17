Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaFQO2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:28:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47966 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbaFQO2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:28:15 -0400
Message-ID: <53A04FDA.6070101@oracle.com>
Date: Tue, 17 Jun 2014 22:25:30 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stefanr@s5r6.in-berlin.de, joro@8bytes.org, jejb@parisc-linux.org,
        deller@gmx.de, bhelgaas@google.com, clm@fb.com,
        Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com, bharrosh@panasas.com,
        bhalevy@primarydata.com, ccaulfie@redhat.com, teigland@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, cm224.lee@samsung.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        casey@schaufler-ca.com, LKML <linux-kernel@vger.kernel.org>
Subject: [patch 00/24] lib/kobject: kset_create_and_add return error clean
 up
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, to verify if kset_create_and_add() is succeed or not, almost
all subsystems with sysfs support are check up the return value against
NULL, then return -ENOMEM on failure, since kset_create_and_add() always 
return NULL in case of anything wrong.  However, kset_register() can fail
due to other reasons, hence it's better to return the actual error on
kset_create_and_add(), this patch series is just did that and this is
inspired by Christoph in another thread:
http://www.spinics.net/lists/linux-mm/msg74729.html


Jeff Liu (24)
  kobject: return actual error on kset_create_and_add
  sample/kobject: update kset-example code
  slub: return actual error on sysfs_slab_add
  powerpc: check/return acutal error on sysfs init
  s390: check/return actual error on sysfs init
  crypt: return actual error code on pcrypt_init
  kernel: return actual error on param_sysfs_init
  drivers/firmware: return actual error on sysfs init
  drivers/iommu: check actual error on iommu_init
  drivers/base: return actual error on sysfs init
  drviers/scsi: check sysfs init return value via IS_ERR at iscsi_boot_create_kset
  drivers/parisc: return actual error on pdc_stable_init
  drivers/pci: return actual error on pci_slot_init
  drivers/s390: return actual error on sysfs init functions
  drivers/of: return actual error on of_init
  btrfs: return actual error on btrfs_init_sysfs
  gfs2: return actual error on gfs2_sys_init
  exofs: return actual error on exofs_sysfs_odev_add
  fs/dlm: return actual error on dlm_lockspace_init
  ext4: return actual error on ext4_init_fs
  f2fs: return actual error on init_f2fs_fs
  ocfs2: return actual error on sysfs init
  net: return actual error on register_queue_kobjects
  security/smack: return acutal error on smk_init_sysfs


Cheers,
-Jeff
