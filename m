Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3KJGl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 01:41:56 -0500
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:36567
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3KJGly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 01:41:54 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Nov 2013 01:41:54 EST
Date: Sat, 9 Nov 2013 23:35:13 -0700
From: Kevin Fenzi <kevin@scrye.com>
To: Kevin Fenzi <kevin@scrye.com>
Cc: AceLan Kao <acelan.kao@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
Message-ID: <20131109233513.636a299f@voldemort.scrye.com>
In-Reply-To: <20131106102838.347b005c@voldemort.scrye.com>
References: <20131028150250.755b4cc8@voldemort.scrye.com>
	<CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com>
	<CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
	<5270C549.30201@gmail.com>
	<alpine.LNX.2.00.1311051051590.2779@pobox.suse.cz>
	<CAFv23Qkbkh2UGv1fFRApg1nCP5ysvBLnLeSW19JLeAfDmbJEsA@mail.gmail.com>
	<20131106102838.347b005c@voldemort.scrye.com>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512;
 boundary="Sig_/uwxPvIS1Pw1vEgZ/rqwl3o="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uwxPvIS1Pw1vEgZ/rqwl3o=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Well, that was fun. ;)=20

git bisect start
# bad: [69c88dc7d9f1a6c3eceb7058111677c640811c94] vfs: fix new kernel-doc w=
arnings
git bisect bad 69c88dc7d9f1a6c3eceb7058111677c640811c94
# good: [31d141e3a666269a3b6fcccddb0351caf7454240] Linux 3.12-rc6
git bisect good 31d141e3a666269a3b6fcccddb0351caf7454240
# good: [b403b73c21fcab11411a1439867a3ead9117e5e4] Merge branch 'drm-fixes'=
 of git://people.freedesktop.org/~airlied/linux
git bisect good b403b73c21fcab11411a1439867a3ead9117e5e4
# good: [d55f0691c041dba46daad7790b8f2631acb55f9a] Merge remote-tracking br=
anch 'asoc/fix/pcm1792a' into asoc-linus
git bisect good d55f0691c041dba46daad7790b8f2631acb55f9a
# good: [20c87bd40e6c1ff7e31cc5eea4fb37829a57eb58] Merge tag 'asoc-v3.12-rc=
5' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-=
linus
git bisect good 20c87bd40e6c1ff7e31cc5eea4fb37829a57eb58
# good: [d24fec3991076124e069c889c530cdc69cd43fb8] Merge tag 'jfs-3.12' of =
git://github.com/kleikamp/linux-shaggy
git bisect good d24fec3991076124e069c889c530cdc69cd43fb8
# good: [93cd00043fffec840fa36909c4a8eb0f735dfb04] Merge tag 'sound-3.12' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 93cd00043fffec840fa36909c4a8eb0f735dfb04
# good: [606d6fe3ffdb5190d4c8e4d6cd23aa6c1f9cb6ad] fs/namei.c: fix new kern=
el-doc warning
git bisect good 606d6fe3ffdb5190d4c8e4d6cd23aa6c1f9cb6ad
# first bad commit: [69c88dc7d9f1a6c3eceb7058111677c640811c94] vfs: fix
new kernel-doc warnings

Which is... nonsense. ;)=20

So, I tried the first bad commit again and it works.=20

After a small period of head scratching, I noticed that the other change
in the non working kernel was re-enabling debugging options.=20

So, I rebuild locally the bad kernel with the debugging config and
sure enough it's back.=20

So, it's some debugging option causing it.

I can try and bisect again with debugging config but I just got this laptop
recently, so it could be that all debugging kernels have the issue and it's=
=20
nothing recent?

The diff of configs is attached in case anything leaps out at people:=20

kevin
--
164c164
< CONFIG_DEBUG_BLK_CGROUP=3Dy
---
> # CONFIG_DEBUG_BLK_CGROUP is not set
211d210
< CONFIG_PERF_USE_VMALLOC=3Dy
217c216
< CONFIG_DEBUG_PERF_USE_VMALLOC=3Dy
---
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
286c285
< CONFIG_MODULE_FORCE_UNLOAD=3Dy
---
> # CONFIG_MODULE_FORCE_UNLOAD is not set
346c345,350
< CONFIG_UNINLINE_SPIN_UNLOCK=3Dy
---
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=3Dy
> CONFIG_INLINE_READ_UNLOCK=3Dy
> CONFIG_INLINE_READ_UNLOCK_IRQ=3Dy
> CONFIG_INLINE_WRITE_UNLOCK=3Dy
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=3Dy
> CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
402,403c406,407
< CONFIG_MAXSMP=3Dy
< CONFIG_NR_CPUS=3D4096
---
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS=3D128
409d412
< CONFIG_PREEMPT_COUNT=3Dy
437c440
< CONFIG_NODES_SHIFT=3D10
---
> CONFIG_NODES_SHIFT=3D9
460c463
< CONFIG_SPLIT_PTLOCK_CPUS=3D999999
---
> CONFIG_SPLIT_PTLOCK_CPUS=3D4
484c487
< CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=3Dy
---
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
535c538
< CONFIG_PM_TEST_SUSPEND=3Dy
---
> # CONFIG_PM_TEST_SUSPEND is not set
561c564
< CONFIG_ACPI_DEBUG=3Dy
---
> # CONFIG_ACPI_DEBUG is not set
1391c1394
< CONFIG_CEPH_LIB_PRETTYDEBUG=3Dy
---
> # CONFIG_CEPH_LIB_PRETTYDEBUG is not set
1545c1548
< CONFIG_DRBD_FAULT_INJECTION=3Dy
---
> # CONFIG_DRBD_FAULT_INJECTION is not set
2293c2296
< CONFIG_ATH_DEBUG=3Dy
---
> # CONFIG_ATH_DEBUG is not set
2311c2314
< CONFIG_CARL9170_DEBUGFS=3Dy
---
> # CONFIG_CARL9170_DEBUGFS is not set
2342c2345
< CONFIG_B43_DEBUG=3Dy
---
> # CONFIG_B43_DEBUG is not set
2348c2351
< CONFIG_B43LEGACY_DEBUG=3Dy
---
> # CONFIG_B43LEGACY_DEBUG is not set
2384c2387
< CONFIG_IWLWIFI_DEVICE_TRACING=3Dy
---
> # CONFIG_IWLWIFI_DEVICE_TRACING is not set
4745,4746c4748
< CONFIG_DMADEVICES_DEBUG=3Dy
< CONFIG_DMADEVICES_VDEBUG=3Dy
---
> # CONFIG_DMADEVICES_DEBUG is not set
5202c5204
< CONFIG_EXT4_DEBUG=3Dy
---
> # CONFIG_EXT4_DEBUG is not set
5204c5206
< CONFIG_JBD2_DEBUG=3Dy
---
> # CONFIG_JBD2_DEBUG is not set
5249c5251
< CONFIG_QUOTA_DEBUG=3Dy
---
> # CONFIG_QUOTA_DEBUG is not set
5380c5382
< CONFIG_NFSD_FAULT_INJECTION=3Dy
---
> # CONFIG_NFSD_FAULT_INJECTION is not set
5505c5507
< CONFIG_DEBUG_FORCE_WEAK_PER_CPU=3Dy
---
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
5513,5521c5515,5516
< CONFIG_DEBUG_OBJECTS=3Dy
< # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
< CONFIG_DEBUG_OBJECTS_FREE=3Dy
< CONFIG_DEBUG_OBJECTS_TIMERS=3Dy
< CONFIG_DEBUG_OBJECTS_WORK=3Dy
< CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy
< CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=3Dy
< CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=3D1
< CONFIG_SLUB_DEBUG_ON=3Dy
---
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
5524,5528c5519,5520
< CONFIG_DEBUG_KMEMLEAK=3Dy
< CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=3D1024
< # CONFIG_DEBUG_KMEMLEAK_TEST is not set
< CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=3Dy
< CONFIG_DEBUG_STACK_USAGE=3Dy
---
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
5548,5551c5540
< CONFIG_DETECT_HUNG_TASK=3Dy
< CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=3D120
< # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
< CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=3D0
---
> # CONFIG_DETECT_HUNG_TASK is not set
5561,5562c5550
< CONFIG_DEBUG_RT_MUTEXES=3Dy
< CONFIG_DEBUG_PI_LIST=3Dy
---
> # CONFIG_DEBUG_RT_MUTEXES is not set
5564,5572c5552,5558
< CONFIG_DEBUG_SPINLOCK=3Dy
< CONFIG_DEBUG_MUTEXES=3Dy
< CONFIG_DEBUG_WW_MUTEX_SLOWPATH=3Dy
< CONFIG_DEBUG_LOCK_ALLOC=3Dy
< CONFIG_PROVE_LOCKING=3Dy
< CONFIG_LOCKDEP=3Dy
< CONFIG_LOCK_STAT=3Dy
< # CONFIG_DEBUG_LOCKDEP is not set
< CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
---
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
5574d5559
< CONFIG_TRACE_IRQFLAGS=3Dy
5579c5564
< CONFIG_DEBUG_WRITECOUNT=3Dy
---
> # CONFIG_DEBUG_WRITECOUNT is not set
5581,5583c5566,5568
< CONFIG_DEBUG_SG=3Dy
< CONFIG_DEBUG_NOTIFIERS=3Dy
< CONFIG_DEBUG_CREDENTIALS=3Dy
---
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
5588,5589d5572
< CONFIG_PROVE_RCU=3Dy
< # CONFIG_PROVE_RCU_REPEATEDLY is not set
5597,5603c5580
< CONFIG_FAULT_INJECTION=3Dy
< CONFIG_FAILSLAB=3Dy
< CONFIG_FAIL_PAGE_ALLOC=3Dy
< CONFIG_FAIL_MAKE_REQUEST=3Dy
< CONFIG_FAIL_IO_TIMEOUT=3Dy
< CONFIG_FAIL_MMC_REQUEST=3Dy
< CONFIG_FAULT_INJECTION_DEBUG_FS=3Dy
---
> # CONFIG_FAULT_INJECTION is not set
5649,5650c5626
< CONFIG_MMIOTRACE=3Dy
< # CONFIG_MMIOTRACE_TEST is not set
---
> # CONFIG_MMIOTRACE is not set
5658c5634
< CONFIG_TEST_LIST_SORT=3Dy
---
> # CONFIG_TEST_LIST_SORT is not set
5670c5646
< CONFIG_DMA_API_DEBUG=3Dy
---
> # CONFIG_DMA_API_DEBUG is not set
5685c5661
< CONFIG_X86_PTDUMP=3Dy
---
> # CONFIG_X86_PTDUMP is not set
5709c5685
< CONFIG_X86_DEBUG_STATIC_CPU_HAS=3Dy
---
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
5924a5901
> CONFIG_CMPXCHG_LOCKREF=3Dy
5973d5949
< CONFIG_CPUMASK_OFFSTACK=3Dy

--Sig_/uwxPvIS1Pw1vEgZ/rqwl3o=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJSfykkAAoJEEs3sNgP+7teE8wP/0J4Af3I3jIJitsTT3jHWj7+
NJ0UL9y9qkbeVPRZQnDkWKV4b0dW6B7J5PnshAsBeqb6ffl35EcbbJ7wKvLS6YDW
vIqAa3y8aRXmkaa/7uhNGMAIennYP68omRy1scgSVeHeZZehP67hzW1Opb4vzYZu
YFi9ABwGqAeKR2dM0LxFl7HW6X6GWmDZRamgNB9vqdnC9RpDH055dSj6tj4LQF83
XDDBTy1eY9k3kQhXVkjbmubdPrLLpP6tFQ7JwXQZ5q95Ez81yapWSbD2gbQAnjaA
7UA2gOw/h5NVdyP175TcthogZ4gKxuzYNKhVLbwVnoecwYJBxdfkuKFImL1gI8Xg
aaSjqbfxSKUitDulcgFeqjqIAnu2yowvpppelyCpYlsLKPWwpJ1RNZate3rfPApX
Q3xiG5jZlXOaDyaIJxq1DP4lNxZt4NfdRr8PGJ9HPSFuGW0GAfvr0OYgiAlXNzoV
QJOuNRs0V+3DF2nia6rFpROnCn/iOeg0Y68QHXpjMolNae8lJ7DwC2n54mvtde1w
2QgO3qBsBp9T1IqW/vpCYNaxmXC5lAF3ZzWoj/AWRbaTRxdLFHQMKeCDrgUw50rE
vDMaa2okT5k0TnoODT8s1WN7NMG1YrDiMS1ZfeiBaI1S8sDYaEUNWt8o9MNO54Hx
RQtA7XUknbMN999aEZLO
=qNP0
-----END PGP SIGNATURE-----

--Sig_/uwxPvIS1Pw1vEgZ/rqwl3o=--
