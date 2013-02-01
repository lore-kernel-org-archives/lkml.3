Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3BAHNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:13:46 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62830 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3BAHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:13:44 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-0d-510b6b246190
Message-ID: <510B6B24.8040000@lge.com>
Date: Fri, 01 Feb 2013 16:13:40 +0900
From: "kyungsik.lee" <kyungsik.lee@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130129225508.GC30535@twin.jikos.cz>
In-Reply-To: <20130129225508.GC30535@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-30 오전 7:55, David Sterba wrote:
> On Sat, Jan 26, 2013 at 02:50:43PM +0900, Kyungsik Lee wrote:
>> This patchset is for supporting LZ4 compressed kernel and initial ramdisk on
>> the x86 and ARM architectures.
> Have you considered the 'high compression' mode of lz4?
> http://code.google.com/p/lz4/source/browse/trunk/lz4hc.c
>
> The compression format remains the same, the compressor tries harder
> (but is slower), resulting compression ratio is better.
>
> an examle compression for vmlinux.bin of x86_64 build:
>
> input size: 16509520 bytes
>
> lz4 (svn 88):
> output size:        6393684    (38.7%)
> compression time:      41.7 ms (395 MB/s)
> decompression time:    13.7 ms (1204 MB/s)
>
> lz4hc (svn 88):
> output size:        5319137    (32.2%)
> compression time:       683 ms (24 MB/s)
> decompression time:    13.1 ms (1259 MB/s)
>
> compressed file delta: 6393684 - 5319137 = 1074547 ~ 1MB
>
> tested on a Nehalem box; same test on my slow desktop gives
>
> lz4:
> compression time:      97   ms (169 MB/s)
> decompression time:    25.7 ms (643 MB/s)
>
> lz4hc:
> compression time:    1386 ms (11 MB/s)
> decompression time:    26 ms (619 MB/s)
>
> While the decompression time is almost the same, image size is smaller.
> The kernel image compression is run in userspace and the low speed is
> not much of concern for a one-time operation.
>
> For the reference, lzo (current kernel version) run on the destktop:
>
> output size:         6026256 (36.5%)
> decompression time:     79.6 ms (207 MB/s)
>
>> It seems that it’s worth trying LZ4 compressed kernel image or ramdisk
>> for making the kernel boot more faster.
> There's another potential user of lz4: btrfs. I've submitted a feature
> preview integrating lz4 compression
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/15744
> and we have tried to integrate the HC mode as well
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/18165
> .
> So far it's on a slow track, conceptually it works, but I the code needs
> some work so it could live under lib/* (we've used the svn sources
> with minor changes, no kernel coding style). It would be easier for me
> to enhance the existing lib/lz4/* codebase.
>
> Also zram could consider lz4, I'm not sure if there are other potential
> users.
Yes, I guess squash fs and crypto would also benefit from lz4.


Thanks,
Kyungsik



