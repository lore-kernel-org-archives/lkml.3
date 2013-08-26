Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3HZOGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:06:40 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64695 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3HZOGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:06:39 -0400
X-Nat-Received: from [202.181.97.72]:65521 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1377525968.22483
To: ak@linux.intel.com, viro@ZenIV.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org, dhowells@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [linux-next-20130822] module: broken module versions?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201308262306.DHB48401.OHFSVQJOtLFOMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 26 Aug 2013 23:06:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 26082013 #10962352, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm seeing errors that several symbols have bad header (bad CRC ?)
as of linux-next-20130822.

  binfmt_misc: disagrees about version of symbol sys_close
  binfmt_misc: Unknown symbol sys_close (err -22)
  binfmt_misc: disagrees about version of symbol current_fs_time
  binfmt_misc: Unknown symbol current_fs_time (err -22)
  ipv6: disagrees about version of symbol sock_register
  ipv6: Unknown symbol sock_register (err -22)
  ipv6: disagrees about version of symbol ns_capable
  ipv6: Unknown symbol ns_capable (err -22)

next-20130815 worked OK.
I guess that the culprit commit touches something module related code but I'm
unable to run full bisection due to unbootable 3.11-rc5. Any clue?

Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.11-rc6-next-20130822 .

----------
# bad: [66a01bae29d11916c09f9f5a937cafe7d402e4a5] Add linux-next specific files for 20130819
# good: [49dfe76261e427f5521b40321fbc3d947350165d] Documentation: add networking/netdev-FAQ.txt
# good: [cf3c4c03060b688cbc389ebc5065ebcce5653e96] 8139cp: Add dma_mapping_error checking
# good: [093aba10e6a88a28fdc7d6ee8ec69aebd9767a22] Merge branch 'for-3.12/upstream' into for-next
# good: [d010e5769a5ab2ae8d2bcb36e77b98172c24d80c] PCI / ACPI: Use dev_dbg() instead of dev_info() in acpi_pci_set_power_state()
# good: [569935db80fd5338005d977ffc3428d43aad84ba] Merge branches 'cma', 'cxgb3', 'cxgb4', 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma' and 'qib' into for-next
# good: [e729eac6f65e11c5f03b09adcc84bd5bcb230467] udf: Refuse RW mount of the filesystem instead of making it RO
# good: [3fef7f795fff7ccc58d55a28315ca73305515884] Merge remote-tracking branch 'asoc/fix/wm0010' into asoc-linus
# good: [11a45820d02ee78ad22bb95d5abb94950a355d8d] Merge tag 'nfc-fixes-3.11-2' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes
# good: [8fe120b5a665fc869c23f86e4964b801f6e53486] ASoC: omap-abe-twl6040: Remove support for pdata (legacy boot)
# good: [66ffd113f5d81e951b0379acfd0a1df0771d8828] cifs: set sb->s_d_op before calling d_make_root()
# good: [6a3fc31f35025a583499c0d3b1c6fc5dcf6e48ec] spi/ep93xx: Fix format specifier warning
# good: [2de024b766bb9e31c357f70c6344d1107f38ce1a] spi/atmel: Fix format specifier warnings
# good: [e56566699ca64ec44dd134ec5310a3585ffacfec] regulator: pfuze100: Simplify pfuze100_set_ramp_delay implementation
# good: [6878ea72a5d1aa6caae86449975a50b7fe9abed5] aio: be defensive to ensure request batching is non-zero instead of BUG_ON()
# good: [70263cb474853c116f80713d468f3c17d805921c] ASoC: rcar: fix return value check in rsnd_gen1_probe()
# good: [3f1a91aa25579ba5e7268a47a73d2a83e4802c62] ASoC: fsl: Fix module build
# good: [db5ff9541b61ef8394bad0fb05508921b8c5b17b] ASoC: spdif: Add S20_3LE and S24_LE support for dummy codec drivers
# good: [01c6a6afd50f07dfd66b2891fd194c4b789fca48] x86 / tboot / ACPI: Fail extended mode reduced hardware sleep
# good: [21aa521727a004ce4a4c46e9a5cb7e34619b4d16] ARM: dts: Add G2D support to exynos5250
# good: [7b4e0c4ac1809eab6fcfe6818ec8b70be79b41bc] ACPI / PM: Remove redundant power manageable check from acpi_bus_set_power()
# good: [d29cae9f8f2a056138d1bfc55de6e5aa9b9c6a93] Merge branch 'for-3.12' into for-next
# good: [b36f4be3de1b123d8601de062e7dbfc904f305fb] Linux 3.11-rc6
# good: [d4e4ab86bcba5a72779c43dc1459f71fea3d89c8] Linux 3.11-rc5
# good: [c095ba7224d8edc71dcef0d655911399a8bd4a3f] Linux 3.11-rc4
# good: [5ae90d8e467e625e447000cb4335c4db973b1095] Linux 3.11-rc3
# good: [3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b] Linux 3.11-rc2
# good: [ad81f0545ef01ea651886dddac4bef6cec930092] Linux 3.11-rc1
# good: [8bb495e3f02401ee6f76d1b1d77f3ac9f079e376] Linux 3.10
# good: [c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1] Linux 3.9
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
# good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
# good: [28a33cbc24e4256c143dce96c7d93bf423229f92] Linux 3.5
# good: [76e10d158efb6d4516018846f60c2ab5501900bc] Linux 3.4
# good: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
# good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect start '66a01bae29d11916c09f9f5a937cafe7d402e4a5' '49dfe76261e427f5521b40321fbc3d947350165d' 'cf3c4c03060b688cbc389ebc5065ebcce5653e96' \
'093aba10e6a88a28fdc7d6ee8ec69aebd9767a22' 'd010e5769a5ab2ae8d2bcb36e77b98172c24d80c' '569935db80fd5338005d977ffc3428d43aad84ba' \
'e729eac6f65e11c5f03b09adcc84bd5bcb230467' '3fef7f795fff7ccc58d55a28315ca73305515884' '11a45820d02ee78ad22bb95d5abb94950a355d8d' \
'8fe120b5a665fc869c23f86e4964b801f6e53486' '66ffd113f5d81e951b0379acfd0a1df0771d8828' '6a3fc31f35025a583499c0d3b1c6fc5dcf6e48ec' \
'2de024b766bb9e31c357f70c6344d1107f38ce1a' 'e56566699ca64ec44dd134ec5310a3585ffacfec' '6878ea72a5d1aa6caae86449975a50b7fe9abed5' \
'70263cb474853c116f80713d468f3c17d805921c' '3f1a91aa25579ba5e7268a47a73d2a83e4802c62' 'db5ff9541b61ef8394bad0fb05508921b8c5b17b' \
'01c6a6afd50f07dfd66b2891fd194c4b789fca48' '21aa521727a004ce4a4c46e9a5cb7e34619b4d16' '7b4e0c4ac1809eab6fcfe6818ec8b70be79b41bc' \
'd29cae9f8f2a056138d1bfc55de6e5aa9b9c6a93' 'v3.11-rc6' 'v3.11-rc5' 'v3.11-rc4' 'v3.11-rc3' 'v3.11-rc2' 'v3.11-rc1' 'v3.10' 'v3.9' \
'v3.8' 'v3.7' 'v3.6' 'v3.5' 'v3.4' 'v3.3' 'v3.2' 'v3.1' 'v3.0'
# good: [e5e51a9b0965706638be2168de81bfd710402efa] Merge remote-tracking branch 'spi/for-next'
git bisect good e5e51a9b0965706638be2168de81bfd710402efa
# good: [0dbd9fe04c180edc33dc6bc23d0691f8575e3d60] Merge remote-tracking branch 'staging/staging-next'
git bisect good 0dbd9fe04c180edc33dc6bc23d0691f8575e3d60
# good: [194523e2d5dcb680b56d7817730c7b94155ec49c] Merge remote-tracking branch 'msm/for-next'
git bisect good 194523e2d5dcb680b56d7817730c7b94155ec49c
# good: [75c1f84c2dd22e58ecbfcfd7789bbd2b8ab90192] Merge remote-tracking branch 'aio/master'
git bisect good 75c1f84c2dd22e58ecbfcfd7789bbd2b8ab90192
# skip: [a1f8eee9bd6041e05003d86598aef6878f6135a8] MAINTAINERS: SI4713: fix file pattern
git bisect skip a1f8eee9bd6041e05003d86598aef6878f6135a8
# skip: [92a8363db29864b9766d3c0ad0b551d55e640acc] mm/hotplug: remove stop_machine() from try_offline_node()
git bisect skip 92a8363db29864b9766d3c0ad0b551d55e640acc
# bad: [cd857ff4dd4c7cba3849ababe179b0a828167617] xfs: fix dquot isolation hang
git bisect bad cd857ff4dd4c7cba3849ababe179b0a828167617
# skip: [df708487cbd4a49b7fb1a21cfa5578aaef113be4] efs: iget_locked() doesn't return an ERR_PTR()
git bisect skip df708487cbd4a49b7fb1a21cfa5578aaef113be4
# skip: [d112c138b32f46699b594e009e588f0829a94478] mm/zswap: use postorder iteration when destroying rbtree
git bisect skip d112c138b32f46699b594e009e588f0829a94478
# skip: [d7355ae0bce3c19ff5c44af5c5cf6e37c3a42b54] scripts/mod/modpost.c: handle non ABS crc symbols
git bisect skip d7355ae0bce3c19ff5c44af5c5cf6e37c3a42b54
# skip: [fc9d0bf4433ca996825815b8052530abdeaaac23] s390/vmcore: use vmcore for zfcpdump
git bisect skip fc9d0bf4433ca996825815b8052530abdeaaac23
----------
