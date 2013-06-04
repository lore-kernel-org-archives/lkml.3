Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3FDXIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:08:17 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:55807 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3FDXIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:08:13 -0400
MIME-Version: 1.0
Date: Wed, 5 Jun 2013 01:08:12 +0200
Message-ID: <CAG-aW07oTun9z_bOTLE25X+60KmCG1c0nMFecLrf_UAzNMF2Pw@mail.gmail.com>
Subject: 3.10-rc4: mtrr_cleanup: can not find optimal value, please specify mtrr_gran_size/mtrr_chunk_size
From: Matt <jackdachef@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,


I noticed today the following error messages in /var/log/kern.log :


Jun  5 00:26:48 localhost kernel: [    0.000000] MTRR default type: uncachable
Jun  5 00:26:48 localhost kernel: [    0.000000] MTRR fixed ranges enabled:
Jun  5 00:26:48 localhost kernel: [    0.000000]   00000-9FFFF write-back
Jun  5 00:26:48 localhost kernel: [    0.000000]   A0000-BFFFF uncachable
Jun  5 00:26:48 localhost kernel: [    0.000000]   C0000-D3FFF write-protect
Jun  5 00:26:48 localhost kernel: [    0.000000]   D4000-DFFFF uncachable
Jun  5 00:26:48 localhost kernel: [    0.000000]   E0000-E3FFF write-protect
Jun  5 00:26:48 localhost kernel: [    0.000000]   E4000-E7FFF write-through
Jun  5 00:26:48 localhost kernel: [    0.000000]   E8000-EBFFF write-protect
Jun  5 00:26:48 localhost kernel: [    0.000000]   EC000-EFFFF write-through
Jun  5 00:26:48 localhost kernel: [    0.000000]   F0000-FFFFF write-protect
Jun  5 00:26:48 localhost kernel: [    0.000000] MTRR variable ranges enabled:
Jun  5 00:26:48 localhost kernel: [    0.000000]   0 base 000000000
mask E00000000 write-back
Jun  5 00:26:48 localhost kernel: [    0.000000]   1 base 200000000
mask FC0000000 write-back
Jun  5 00:26:48 localhost kernel: [    0.000000]   2 base 0C0000000
mask FC0000000 uncachable
Jun  5 00:26:48 localhost kernel: [    0.000000]   3 disabled
Jun  5 00:26:48 localhost kernel: [    0.000000]   4 disabled
Jun  5 00:26:48 localhost kernel: [    0.000000]   5 disabled
Jun  5 00:26:48 localhost kernel: [    0.000000]   6 disabled
Jun  5 00:26:48 localhost kernel: [    0.000000]   7 disabled
Jun  5 00:26:48 localhost kernel: [    0.000000] x86 PAT enabled: cpu
0, old 0x7040600070406, new 0x7010600070106
Jun  5 00:26:48 localhost kernel: [    0.000000] original variable MTRRs
Jun  5 00:26:48 localhost kernel: [    0.000000] reg 0, base: 0GB,
range: 8GB, type WB
Jun  5 00:26:48 localhost kernel: [    0.000000] reg 1, base: 8GB,
range: 1GB, type WB
Jun  5 00:26:48 localhost kernel: [    0.000000] reg 2, base: 3GB,
range: 1GB, type UC
Jun  5 00:26:48 localhost kernel: [    0.000000] total RAM covered: 8192M
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 64K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 128K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 256K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 128K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 256K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 256K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1G
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1G
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:26:48 localhost kernel: [    0.000000]  gran_size: 2G
chunk_size: 2G num_reg: 2   lose cover RAM: 2G
Jun  5 00:26:48 localhost kernel: [    0.000000] mtrr_cleanup: can not
find optimal value
Jun  5 00:26:48 localhost kernel: [    0.000000] please specify
mtrr_gran_size/mtrr_chunk_size



when trying to append some commands, e.g.:

enable_mtrr_cleanup mtrr_spare_reg_nr=1 mtrr_gran_size=32M mtrr_chunk_size=128M

or

enable_mtrr_cleanup mtrr_spare_reg_nr=0

it doesn't make any change


this would yield the following result:


Jun  5 00:20:47 localhost kernel: [    0.000000] MTRR default type: uncachable
Jun  5 00:20:47 localhost kernel: [    0.000000] MTRR fixed ranges enabled:
Jun  5 00:20:47 localhost kernel: [    0.000000]   00000-9FFFF write-back
Jun  5 00:20:47 localhost kernel: [    0.000000]   A0000-BFFFF uncachable
Jun  5 00:20:47 localhost kernel: [    0.000000]   C0000-D3FFF write-protect
Jun  5 00:20:47 localhost kernel: [    0.000000]   D4000-DFFFF uncachable
Jun  5 00:20:47 localhost kernel: [    0.000000]   E0000-E3FFF write-protect
Jun  5 00:20:47 localhost kernel: [    0.000000]   E4000-E7FFF write-through
Jun  5 00:20:47 localhost kernel: [    0.000000]   E8000-EBFFF write-protect
Jun  5 00:20:47 localhost kernel: [    0.000000]   EC000-EFFFF write-through
Jun  5 00:20:47 localhost kernel: [    0.000000]   F0000-FFFFF write-protect
Jun  5 00:20:47 localhost kernel: [    0.000000] MTRR variable ranges enabled:
Jun  5 00:20:47 localhost kernel: [    0.000000]   0 base 000000000
mask E00000000 write-back
Jun  5 00:20:47 localhost kernel: [    0.000000]   1 base 200000000
mask FC0000000 write-back
Jun  5 00:20:47 localhost kernel: [    0.000000]   2 base 0C0000000
mask FC0000000 uncachable
Jun  5 00:20:47 localhost kernel: [    0.000000]   3 disabled
Jun  5 00:20:47 localhost kernel: [    0.000000]   4 disabled
Jun  5 00:20:47 localhost kernel: [    0.000000]   5 disabled
Jun  5 00:20:47 localhost kernel: [    0.000000]   6 disabled
Jun  5 00:20:47 localhost kernel: [    0.000000]   7 disabled
Jun  5 00:20:47 localhost kernel: [    0.000000] x86 PAT enabled: cpu
0, old 0x7040600070406, new 0x7010600070106
Jun  5 00:20:47 localhost kernel: [    0.000000] original variable MTRRs
Jun  5 00:20:47 localhost kernel: [    0.000000] reg 0, base: 0GB,
range: 8GB, type WB
Jun  5 00:20:47 localhost kernel: [    0.000000] reg 1, base: 8GB,
range: 1GB, type WB
Jun  5 00:20:47 localhost kernel: [    0.000000] reg 2, base: 3GB,
range: 1GB, type UC
Jun  5 00:20:47 localhost kernel: [    0.000000] total RAM covered: 8192M
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] invalid
mtrr_gran_size or mtrr_chunk_size, will find optimal one
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 64K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 128K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 256K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 128K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 256K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 256K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 512K num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 1M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 2M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 4M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 8M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 16M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 32M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 64M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 128M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 256M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512M
chunk_size: 512M num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512M
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512M
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1G
chunk_size: 1G num_reg: 4   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1G
chunk_size: 2G num_reg: 5   lose cover RAM: -0G
Jun  5 00:20:47 localhost kernel: [    0.000000]  gran_size: 2G
chunk_size: 2G num_reg: 2   lose cover RAM: 2G
Jun  5 00:20:47 localhost kernel: [    0.000000] mtrr_cleanup: can not
find optimal value
Jun  5 00:20:47 localhost kernel: [    0.000000] please specify
mtrr_gran_size/mtrr_chunk_size





Is this some kind of kernel BUG due to the negative value (- 0G) ?

MTRR seems to be a topic that is not widely discussed or thoroughly
understood when using google to find answers.

cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 8192MB, count=1: write-back
reg01: base=0x200000000 ( 8192MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable


Many thanks in advance


Kind Regards

Matt


P.S.: I'm not subscribed to the list so please CC me when needed
