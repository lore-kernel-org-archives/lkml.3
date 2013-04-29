Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3D2I3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:29:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42495 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3D2I3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:29:09 -0400
Date: Mon, 29 Apr 2013 18:29:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: linux-next: manual merge of the akpm tree with the  vfstree
Message-Id: <20130429182906.a964166ca79375595a16681c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_18_29_06_+1000_E93cOwQXTCe8MUsW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_18_29_06_+1000_E93cOwQXTCe8MUsW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/internal.h between commit 4608da4a9433 ("proc: Move non-public
stuff from linux/proc_fs.h to fs/proc/internal.h") from the vfs tree and
commit "pagemap: introduce the /proc/PID/pagemap2 file" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/internal.h
index d600fb0,188b886..0000000
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@@ -223,76 -191,4 +223,77 @@@ extern void proc_device_tree_init(void)
  extern const struct inode_operations proc_ns_dir_inode_operations;
  extern const struct file_operations proc_ns_dir_operations;
 =20
 +/*
 + * proc_net.c
 + */
 +extern const struct file_operations proc_net_operations;
 +extern const struct inode_operations proc_net_inode_operations;
 +
 +#ifdef CONFIG_NET
 +extern int proc_net_init(void);
 +#else
 +static inline int proc_net_init(void) { return 0; }
 +#endif
 +
 +/*
 + * proc_self.c
 + */
  extern int proc_setup_self(struct super_block *);
 +
 +/*
 + * proc_sysctl.c
 + */
 +#ifdef CONFIG_PROC_SYSCTL
 +extern int proc_sys_init(void);
 +extern void sysctl_head_put(struct ctl_table_header *);
 +#else
 +static inline void proc_sys_init(void) { }
 +static inline void sysctl_head_put(struct ctl_table_header *head) { }
 +#endif
 +
 +/*
 + * proc_tty.c
 + */
 +#ifdef CONFIG_TTY
 +extern void proc_tty_init(void);
 +#else
 +static inline void proc_tty_init(void) {}
 +#endif
 +
 +/*
 + * root.c
 + */
 +extern struct proc_dir_entry proc_root;
 +
 +extern void proc_self_init(void);
 +extern int proc_remount(struct super_block *, int *, char *);
 +
 +/*
 + * task_[no]mmu.c
 + */
 +struct proc_maps_private {
 +	struct pid *pid;
 +	struct task_struct *task;
 +#ifdef CONFIG_MMU
 +	struct vm_area_struct *tail_vma;
 +#endif
 +#ifdef CONFIG_NUMA
 +	struct mempolicy *task_mempolicy;
 +#endif
 +};
 +
 +extern const struct file_operations proc_pid_maps_operations;
 +extern const struct file_operations proc_tid_maps_operations;
 +extern const struct file_operations proc_pid_numa_maps_operations;
 +extern const struct file_operations proc_tid_numa_maps_operations;
 +extern const struct file_operations proc_pid_smaps_operations;
 +extern const struct file_operations proc_tid_smaps_operations;
 +extern const struct file_operations proc_clear_refs_operations;
 +extern const struct file_operations proc_pagemap_operations;
++extern const struct file_operations proc_pagemap2_operations;
 +
 +extern unsigned long task_vsize(struct mm_struct *);
 +extern unsigned long task_statm(struct mm_struct *,
 +				unsigned long *, unsigned long *,
 +				unsigned long *, unsigned long *);
 +extern void task_mem(struct seq_file *, struct mm_struct *);

--Signature=_Mon__29_Apr_2013_18_29_06_+1000_E93cOwQXTCe8MUsW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfi9SAAoJEECxmPOUX5FETCgP/je17R+70DbW12MgFyZwTEVP
f4IrZMiIeP+IjZhlBrHokcSBzdSC6CrEtmfJj1NIUYKxLgL039p1EwPO1Sjr0DoU
VlZATbTrZxEAoPe2zV2xOsHUPr0rWzEtfPl/JKjt3lm55m3qP6zfUcYc/Sp6s/76
lTWbPnsz2W5UaXPJvaVTSjtHvLsBPrAVARfaro/BhIYlBJu3ZyvocfMOLY4G8hcK
7HZAyMI1pa3ulIvRdOBmtl+sB7m+MOup64S+U3EgHvDTiUizWRV8LL+vlgIb1GQd
yxXq1ClsSRh1GgcP/2xtxLjlMgsOeaZ3KPdWz1E65S5v0uGkJ8/6iAjjIq/LY9z/
310hYjJpi5C3tKJbTCYa4/5SVW7doUDL/Kvv+qaDz6dNw0FbcZlv4cmFRYkaKzH5
i+tl8PN0qtb6+3p4ND8MDmiY/ooOhxqpiUtxswVPnGa68U39YKrKeX/slEmfGKQC
leRtAqqhZdGsB+JErjQ8zDLK2Ngxr4k5D/Gohp0FgmwBKGOST6wdxYZSeeBpttfE
ZArn3XkfkEVrnrKgJCy494S+QJM8Z5chrhH4wX0g2tl3zbmig9rTCCjvwOFNNlBO
pDjG+wt1lL+E7xCHJx69oFH8v7xfrheGazZZHBabM9CrRguOYqiPQ7jAU7SXp5Q/
FoR+jUJA9zg7BMMAUuxR
=5m6g
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_18_29_06_+1000_E93cOwQXTCe8MUsW--
