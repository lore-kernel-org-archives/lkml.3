Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3BWE3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 23:29:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46894 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3BWE3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 23:29:11 -0500
Message-ID: <51284595.5040903@wwwdotorg.org>
Date: Fri, 22 Feb 2013 21:29:09 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Imre Deak <imre.deak@intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] lib/scatterlist: use page iterator in the mapping
 iterator
References: <1360768224-18163-1-git-send-email-imre.deak@intel.com> <1360768224-18163-2-git-send-email-imre.deak@intel.com>
In-Reply-To: <1360768224-18163-2-git-send-email-imre.deak@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 08:10 AM, Imre Deak wrote:
> For better code reuse use the newly added page iterator to iterate
> through the pages. The offset, length within the page is still
> calculated by the mapping iterator as well as the actual mapping.
> Idea from Tejun Heo <tj@kernel.org>.

This patch appears in linux-next since next-20130220. It breaks mounting
a root filesystem on an SD card on the Raspberry Pi ARM platform, with
errors such as those shown below.

next-20130222 with just this patch reverted works fine.

> [    0.708426] VFS: Mounted root (ext4 filesystem) on device 179:2.
> [    0.723742] devtmpfs: mounted
> [    0.733064] Freeing init memory: 204K
> [    0.777992] EXT4-fs error (device mmcblk0p2): ext4_iget:3814: inode #4259: comm swapper: bad extra_isize (57200 != 256)
> [    0.815172] EXT4-fs error (device mmcblk0p2): ext4_lookup:1428: inode #8198: comm swapper: deleted inode referenced: 487
> [    0.826179] Kernel panic - not syncing: No init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.

> [    0.719365] VFS: Mounted root (ext4 filesystem) on device 179:2.
> [    0.740918] devtmpfs: mounted
> [    0.745219] Freeing init memory: 204K
> ERROR: ld.so: object '/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so' from /etc/ld.so.preload cannot be preloaded: ignored.
> [    0.906840] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

> [    0.724018] VFS: Mounted root (ext4 filesystem) on device 179:2.
> [    0.739404] devtmpfs: mounted
> [    0.748741] Freeing init memory: 204K
> [    0.793603] EXT4-fs error (device mmcblk0p2): ext4_iget:3814: inode #4259: comm swapper: bad extra_isize (57200 != 256)
> [    0.822138] Kernel panic - not syncing: No init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.


