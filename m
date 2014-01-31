Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaAaAoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:44:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:32886 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaAaAox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:44:53 -0500
Date: Thu, 30 Jan 2014 16:44:51 -0800 (PST)
Message-Id: <20140130.164451.873520736572570393.davem@davemloft.net>
To: ryao@gentoo.org
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        aneesh.kumar@linux.vnet.ibm.com, will.deacon@arm.com,
        cov@codeaurora.org, behlendorf1@llnl.gov, mthode@mthode.org
Subject: Re: [PATCH] 9p/trans_virtio.c: Fix broken zero-copy on vmalloc()
 buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140130.162926.561686911250624301.davem@davemloft.net>
References: <1391104968-10258-1-git-send-email-ryao@gentoo.org>
	<1391104968-10258-2-git-send-email-ryao@gentoo.org>
	<20140130.162926.561686911250624301.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 30 Jan 2014 16:29:26 -0800 (PST)

> From: Richard Yao <ryao@gentoo.org>
> Date: Thu, 30 Jan 2014 13:02:48 -0500
> 
>> The 9p-virtio transport does zero copy on things larger than 1024 bytes
>> in size. It accomplishes this by returning the physical addresses of
>> pages to the virtio-pci device. At present, the translation is usually a
>> bit shift.
>> 
>> However, that approach produces an invalid page address when we
>> read/write to vmalloc buffers, such as those used for Linux kernle
>> modules. This causes QEMU to die printing:
>> 
>> qemu-system-x86_64: virtio: trying to map MMIO memory
>> 
>> This patch enables 9p-virtio to correctly handle this case. This not
>> only enables us to load Linux kernel modules off virtfs, but also
>> enables ZFS file-based vdevs on virtfs to be used without killing QEMU.
>> 
>> Also, special thanks to both Avi Kivity and Alexander Graf for their
>> interpretation of QEMU backtraces. Without their guidence, tracking down
>> this bug would have taken much longer.
>> 
>> Signed-off-by: Richard Yao <ryao@gentoo.org>
>> Acked-by: Alexander Graf <agraf@suse.de>
>> Reviewed-by: Will Deacon <will.deacon@arm.com>
> 
> Applied, thanks.

Actually I had to revert, is_vmalloc_or_malloc_addr() is not exported to
modules, so this change breaks the build.
