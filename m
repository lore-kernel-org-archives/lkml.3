Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaFTEaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:30:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39267 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaFTEaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:30:10 -0400
Message-ID: <53A3B8B7.70806@zytor.com>
Date: Thu, 19 Jun 2014 21:29:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] initramfs: Support initrd that is bigger then 2G.
References: <1403230336-10444-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1403230336-10444-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 07:12 PM, Yinghai Lu wrote:
> When initrd (compressed or not) is used, kernel report data corrupted
> with /dev/ram0.
> 
> The root cause:
> During initramfs checking, if it is initrd, it will be transferred to
> /initrd.image with sys_write.
> sys_write only support 2G-4K write, so if the initrd ram is more than
> that, /initrd.image will not complete at all.
> 
> Add local sys_write_large to loop calling sys_write to workaround the
> problem.
> 
> Also need to use that in write_buffer path for cpio that have file is
> more than file.

That sentence doesn't make sense.

> At the same time, we don't need to worry about sys_read/sys_write in
> do_mounts_rd.c::crd_load. As decompressor will have fill/flush that
> means it will allocate buffer and buffer is smaller than 2G.
> 
> Test with uncompressed initrd, and compressed with gz, bz2, lzma,xz,
> lzop.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I would call this function xwrite(), which is usually called in userspace.

It would be nice in order to support very large initrd/initramfs, to
free the memory as it becomes available instead of requiring two copies
of the data in memory at the same time.

Otherwise,

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa


