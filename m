Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3AROps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:45:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3AROpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:45:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 29/76] ARC: Boot #1: low-level, setup_arch(), /proc/cpuinfo, mem init
Date: Fri, 18 Jan 2013 14:45:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-30-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-30-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181445.39050.arnd@arndb.de>
X-Provags-ID: V02:K0:d2dl80pDVtRYs6xd72m4gObnHP9e9J9r15G5haEGADN
 sw8NcltXE/rqQcC3+jgFeprGJkHajG61D+gAhEhahrKWfHHHfz
 5/ujR4IdZXGxXtQctgsu2bHFbMYUkWIQU70fRg0UhIdjHqErus
 RMGz3DOFN01APkYlTPaJwq8ghfW7ZQuJjaZubMApoVvJQbVmN1
 wv+2Ph7sLIAcwcVnxFpNvgDyGqQmg3vBy1ndWcyV4DXCVrt2Fg
 mjE2CJ+pRDwY3QbhC/+sd9Nh1C3Q6JI8ac6zyruunWCOZcQKav
 /u+uF8kTHcBv8Lh3eGKz6Q14d8KwweLXDi+pBAxWLSkE+WAxhQ
 hF8/keLqNpADiFLcqX5k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> +       /* setup bootmem allocator */
> +       bootmap_sz = init_bootmem_node(NODE_DATA(0),
> +                                      first_free_pfn,/* bitmap start */
> +                                      min_low_pfn,   /* First pg to track */
> +                                      max_low_pfn);  /* Last pg to track */
> +
> +       /*
> +        * init_bootmem above marks all tracked Page-frames as inuse "allocated"
> +        * This includes pages occupied by kernel's elf segments.
> +        * Beyond that, excluding bootmem bitmap itself, mark the rest of
> +        * free-mem as "allocatable"
> +        */
> +       alloc_start = kernel_img_end + bootmap_sz;
> +       free_bootmem(alloc_start, end_mem - alloc_start);
> +
> +       memset(zones_size, 0, sizeof(zones_size));
> +       zones_size[ZONE_NORMAL] = num_physpages;
> +

IIRC, the bootmem allocator is no longer recommended for new architecture.
You should use the "memblock" interface instead, as arm64 and tile do.

I just saw that this is still listed as TODO for openrisc, sorry if I
put you on the wrong track there by recommending to copy from openrisc.

	Arnd
