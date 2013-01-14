Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3ANDt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 22:49:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53165 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3ANDt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 22:49:27 -0500
Date: Mon, 14 Jan 2013 14:49:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: linux-next: manual merge of the akpm tree with the kbuild tree
Message-Id: <20130114144916.c88c0c073426361969804c73@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Jan_2013_14_49_16_+1100_bXCg9zR+x_Ffkuyj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Jan_2013_14_49_16_+1100_bXCg9zR+x_Ffkuyj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
scripts/tags.sh between commit 9f14b4201239 ("scripts/tags.sh: Fix regex
syntax for etags") from the kbuild tree and commit "scripts/tags.sh: add
magic for declarations of popular kernel type" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc scripts/tags.sh
index 4c53b7d,b33e7ce..0000000
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@@ -205,30 -221,41 +221,41 @@@ emacs(
  	--regex=3D'/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
  	--regex=3D'/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
  	--regex=3D'/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/' \
 -	--regex=3D'/PAGEFLAG\(([^,)]*).*/Page\1/'			\
 -	--regex=3D'/PAGEFLAG\(([^,)]*).*/SetPage\1/'		\
 -	--regex=3D'/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
 -	--regex=3D'/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'	\
 -	--regex=3D'/TESTPAGEFLAG\(([^,)]*).*/Page\1/'		\
 -	--regex=3D'/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
 -	--regex=3D'/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'	\
 -	--regex=3D'/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
 -	--regex=3D'/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
 -	--regex=3D'/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'	\
 -	--regex=3D'/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
 -	--regex=3D'/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
 -	--regex=3D'/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
 -	--regex=3D'/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\
 -	--regex=3D'/TESTSCFLAG\(([^,)]*).*/TestSetPage\1/'	\
 -	--regex=3D'/TESTSCFLAG\(([^,)]*).*/TestClearPage\1/'	\
 -	--regex=3D'/SETPAGEFLAG_NOOP\(([^,)]*).*/SetPage\1/'	\
 -	--regex=3D'/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
 -	--regex=3D'/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
 -	--regex=3D'/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 -	--regex=3D'/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
 -	--regex=3D'/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'			\
 -	--regex=3D'/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/'	\
 -	--regex=3D'/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/'\
 +	--regex=3D'/PAGEFLAG(\([^,)]*\).*/Page\1/'			\
 +	--regex=3D'/PAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
 +	--regex=3D'/PAGEFLAG(\([^,)]*\).*/ClearPage\1/'		\
 +	--regex=3D'/TESTSETFLAG(\([^,)]*\).*/TestSetPage\1/'	\
 +	--regex=3D'/TESTPAGEFLAG(\([^,)]*\).*/Page\1/'		\
 +	--regex=3D'/SETPAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
 +	--regex=3D'/__SETPAGEFLAG(\([^,)]*\).*/__SetPage\1/'	\
 +	--regex=3D'/TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
 +	--regex=3D'/__TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
 +	--regex=3D'/CLEARPAGEFLAG(\([^,)]*\).*/ClearPage\1/'	\
 +	--regex=3D'/__CLEARPAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
 +	--regex=3D'/__PAGEFLAG(\([^,)]*\).*/__SetPage\1/'		\
 +	--regex=3D'/__PAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
 +	--regex=3D'/PAGEFLAG_FALSE(\([^,)]*\).*/Page\1/'		\
 +	--regex=3D'/TESTSCFLAG(\([^,)]*\).*/TestSetPage\1/'	\
 +	--regex=3D'/TESTSCFLAG(\([^,)]*\).*/TestClearPage\1/'	\
 +	--regex=3D'/SETPAGEFLAG_NOOP(\([^,)]*\).*/SetPage\1/'	\
 +	--regex=3D'/CLEARPAGEFLAG_NOOP(\([^,)]*\).*/ClearPage\1/'	\
 +	--regex=3D'/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
 +	--regex=3D'/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
 +	--regex=3D'/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
 +	--regex=3D'/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
- 	--regex=3D'/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/'=
 \
- 	--regex=3D'/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1=
/'
++	--regex=3D'/PCI_OP_READ(\(\w\).*[1-4])/pci_bus_read_config_\1/' \
++	--regex=3D'/PCI_OP_WRITE(\(\w\).*[1-4])/pci_bus_write_config_\1/' \
+ 	--regex=3D'/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
+ 	--regex=3D'/DEFINE_(RAW_SPINLOCK|RWLOCK|SEQLOCK)\((\w*)/\2/v/'	\
+ 	--regex=3D'/DECLARE_(RWSEM|COMPLETION)\((\w*)/\2/v/'		\
+ 	--regex=3D'/DECLARE_BITMAP\((\w*)/\1/v/'				\
+ 	--regex=3D'/(^|\s)(|L|H)LIST_HEAD\((\w*)/\3/v/'			\
+ 	--regex=3D'/(^|\s)RADIX_TREE\((\w*)/\2/v/'			\
+ 	--regex=3D'/DEFINE_PER_CPU\(([^,]*,\s*)(\w*).*\)/\2/v/'		\
+ 	--regex=3D'/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
+ 	--regex=3D'/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'			\
+ 	--regex=3D'/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
+ 	--regex=3D'/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
 =20
  	all_kconfigs | xargs $1 -a                              \
  	--regex=3D'/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_Jan_2013_14_49_16_+1100_bXCg9zR+x_Ffkuyj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ84A8AAoJEECxmPOUX5FEDnwP/3btqq4yiysEkyCbxqG+aS1I
HUl3FmsJXb+SveDV8AlTNSSpLMf4qpHQ8O9YyUq+0kEALcN0uCPzUdgX5TQdXwEc
OEzDsw93sMyS7La7Hb1Wt0Ts0+kF1ZNvRV5/+ydj7FLaYJWgOpDnxSq+heAf5QgL
NhcZDxK5FsAjAf/JTuI0Akdy4f2MBwHTyr+AA4qaYCl+1sikRNIGvXfanPC4ooPb
MWRP9C6o/eBAnLFh6kFrM01qVpG/WXl5HoBv1114Mvm4ueRQJ2HvrWHfEaOnO2ys
+UF+Vs+JPVwaU5kSjtgPzLH5FfwM6/LZU8ssEtrhf+QAZLJf7fiR9W3ESmzzD426
ZmeqhEbS1Vs3f6VVTkwteDvx4a8GWz1wQ1b6aIQlDhr8yFR+NvMyOeNlsGatEpHk
EI03IBkcGcvqyJMaoeJCgCobkA4u6nEqo98tkAPTTZ66e/67OfOI6n4jSFmQ5IZ9
zrpRl71Tw2s0hqPNhFUEMS44VRs4abDKcA249lHGVDCU2urWrT11NBFVNWdmG6e0
8Tjxs6mo5AufnTEmhXLn1547q3knle80FqHtt3xeOEE1l4lq47BBaC48vlYeixrl
3fiepNKpdzLiqACLOV89AIkpdGhemNHIkhIXKOVe7ZqdBDDamVTcPH2ATqyIBlsV
3TVGuNOf/6ySPzET46dP
=Cd6o
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Jan_2013_14_49_16_+1100_bXCg9zR+x_Ffkuyj--
