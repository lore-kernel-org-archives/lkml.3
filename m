Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbaEIWJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 18:09:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48730 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757368AbaEIWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 18:09:50 -0400
Date: Fri, 9 May 2014 19:09:15 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
Message-ID: <20140509220915.GA391@arch.cereza>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-4-git-send-email-arnd@arndb.de>
 <20140509184505.GA30330@arch.cereza>
 <20140509212810.GF18257@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140509212810.GF18257@obsidianresearch.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 May 03:28 PM, Jason Gunthorpe wrote:
> 
> > I gave this a try in order to answer Arnd's performance
> > question. First of all, the patch seems wrong. I guess it's because
> > readsl reads 4-bytes pieces, instead of 8-bytes.
> > 
> > This patch below is tested (but not completely, see below) and works:
> 
> Compilers are better now, I think you can just ditch the weirdness:
> 
[..]
> 
> The below gives:
> 
>   c8:   ea000002        b       d8 <orion_nand_read_buf+0x84>
>   cc:   e5dc0000        ldrb    r0, [ip]
>   d0:   e7c30001        strb    r0, [r3, r1]
>   d4:   e2811001        add     r1, r1, #1
>   d8:   e1510002        cmp     r1, r2
> 
> Which looks the same as the asm version to me.
> 

Nice! It wasn't really needed but since I have the board here:

# time nanddump /dev/mtd5 -f /dev/null -q
real	0m 5.82s
user	0m 0.20s
sys	0m 5.60s

Jason: Care to submit a proper patch?

On 08 May 04:56 PM, Arnd Bergmann wrote:
> Ok, that is a noticeable difference. For scale, what is the size of that partition?

The board is Openblocks A6, running mainline.

# cat /proc/mtd 
dev:    size   erasesize  name
mtd0: 00090000 00004000 "uboot"
mtd1: 00044000 00004000 "env"
mtd2: 00024000 00004000 "test"
mtd3: 00400000 00004000 "conf"
mtd4: 01d20000 00004000 "linux"
mtd5: 01dec000 00004000 "user"

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
