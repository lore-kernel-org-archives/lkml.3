Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaJUQBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:01:10 -0400
Received: from down.free-electrons.com ([37.187.137.238]:59156 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755877AbaJUQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:01:08 -0400
Date: Tue, 21 Oct 2014 18:01:03 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Ezaul Zillmer <ezaulzillmer@gmail.com>
Cc: linux-sunxi@googlegroups.com, computersforpeace@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yassinjaffer@gmail.com,
        maxime.ripard@free-electrons.com
Subject: Re: [PATCH v6 2/2] mtd: nand: add sunxi NFC dt bindings doc
Message-ID: <20141021180103.37ca7357@bbrezillon>
In-Reply-To: <89bb5f8e-2fb0-4012-a8b2-fdd618da8f11@googlegroups.com>
References: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
	<1413805520-14947-3-git-send-email-boris.brezillon@free-electrons.com>
	<20141021024134.GC1193@ld-irv-0074>
	<20141021145344.575b19e6@bbrezillon>
	<62d54110-9c7f-4342-9201-a1ae23194620@googlegroups.com>
	<20141021155841.180861d0@bbrezillon>
	<89bb5f8e-2fb0-4012-a8b2-fdd618da8f11@googlegroups.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 08:03:57 -0700 (PDT)
Ezaul Zillmer <ezaulzillmer@gmail.com> wrote:

> results 
> {"K9GBG08U0A 32G 3.3V 8-bit",
> { .id = {0xec, 0xd7, 0x94, 0x7a, 0x54, 0x43} },
>   SZ_8K, SZ_4K, SZ_1M, 0, 6, 640, NAND_ECC_INFO(24, SZ_1K) },
> 
> 
> Start this in the attached image
> ..................................................................
> 
> [   20.127045] Bad eraseblock 2900 at 0x0000b54fe000
> [   20.134025] Bad eraseblock 2901 at 0x0000b55fe000
> [   20.140993] Bad eraseblock 2902 at 0x0000b56fe000
> [   20.147973] Bad eraseblock 2903 at 0x0000b57fe000
> [   20.154952] Bad eraseblock 2904 at 0x0000b58fe000
> [   20.161932] Bad eraseblock 2905 at 0x0000b59fe000
> [   20.168900] Bad eraseblock 2906 at 0x0000b5afe000
> [   20.175878] Bad eraseblock 2907 at 0x0000b5bfe000
> [   20.182861] Bad eraseblock 2908 at 0x0000b5cfe000
> [   20.189828] Bad eraseblock 2909 at 0x0000b5dfe000
> [   20.196810] Bad eraseblock 2910 at 0x0000b5efe000
> [   20.203790] Bad eraseblock 2911 at 0x0000b5ffe000
> [   20.210758] Bad eraseblock 2912 at 0x0000b60fe000
> [   20.217742] Bad eraseblock 2913 at 0x0000b61fe000
> [   20.224723] Bad eraseblock 2914 at 0x0000b62fe000
> [   20.231702] Bad eraseblock 2915 at 0x0000b63fe000
> [   20.238669] Bad eraseblock 2916 at 0x0000b64fe000
> [   20.245649] Bad eraseblock 2917 at 0x0000b65fe000
> [   20.252618] Bad eraseblock 2918 at 0x0000b66fe000
> [   20.259585] Bad eraseblock 2919 at 0x0000b67fe000
> [   20.266565] Bad eraseblock 2920 at 0x0000b68fe000
> [   20.273546] Bad eraseblock 2921 at 0x0000b69fe000
> [   20.280512] Bad eraseblock 2922 at 0x0000b6afe000
> [   20.287490] Bad eraseblock 2923 at 0x0000b6bfe000
> [   20.294468] Bad eraseblock 2924 at 0x0000b6cfe000
> [   20.301437] Bad eraseblock 2925 at 0x0000b6dfe000
> [   20.312741] Bad eraseblock 2928 at 0x000. ok
> 
> 
> I thought this docs of this samsung nand "K9GBG08U0A" that talves be useful 
> since you have more knowledge about it! so I can help you make the tests of 
> your support in nand cubieboard2.


You have to force bad block erasure to get rid of AW's libnand layout
(which is overriding bad block markers).

Please follow these steps:
1) apply this patch [1]
2) boot on your new kernel and launch
$ flash_erase /dev/mtd0 0 0
3) revert the patch
4) Boot on your new kernel

Most of your bad blocks should be gone after that...

[1]http://code.bulix.org/k2v1hx-87237


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
