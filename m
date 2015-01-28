Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbbA1GIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:08:30 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61993 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbbA1GI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:08:28 -0500
Date: Wed, 28 Jan 2015 15:08:25 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2] zram: free meta out of init_lock
Message-ID: <20150128060732.GA442@swordfish>
References: <20150127040305.GB665@swordfish>
 <20150128001526.GA25828@blaptop>
 <20150128002203.GB25828@blaptop>
 <20150128020759.GA343@swordfish>
 <20150128025707.GB32712@blaptop>
 <20150128035354.GA7790@swordfish>
 <20150128040757.GA577@swordfish>
 <20150128045028.GB577@swordfish>
 <20150128045855.GD32712@blaptop>
 <20150128053541.GE32712@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128053541.GE32712@blaptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/28/15 14:35), Minchan Kim wrote:
> I tested it with dd on /dev/zram0 without any FS on my KVM
> and I cannot see any measureable performance gap.
> Hmm, I will try it on real machine.

hm... no, it's 100% stable

 ./iozone -t 3 -R -r 16K -s 60M -I +Z

        test           base        srcu

 "  Initial write " 1274320.94  1251996.78
 "        Rewrite " 1965783.94  1994964.06
 "           Read " 4994070.75  4785895.88
 "        Re-read " 5134244.62  5010810.50
 "   Reverse Read " 4098531.38  4049988.38
 "    Stride read " 4577775.75  4263884.50
 "    Random read " 4131315.75  4636718.38
 " Mixed workload " 3675635.25  3854783.06
 "   Random write " 1832045.12  1863511.31
 "         Pwrite " 1238366.59  1258660.47
 "          Pread " 2475710.28  2404201.75
 "         Fwrite " 2410579.94  2396443.25
 "          Fread " 7723248.00  7127479.75

 "  Initial write " 1325167.41  1321517.41
 "        Rewrite " 2044098.62  2161141.06
 "           Read " 5267661.12  6203909.25
 "        Re-read " 5458601.62  5773477.12
 "   Reverse Read " 5001896.25  5103856.12
 "    Stride read " 4858877.62  5003335.25
 "    Random read " 4620529.88  4685374.62
 " Mixed workload " 3868978.19  3939195.31
 "   Random write " 2037816.75  1949729.56
 "         Pwrite " 1298255.91  1323038.47
 "          Pread " 2688768.09  2957903.06
 "         Fwrite " 2482632.44  2351247.50
 "          Fread " 7905214.75  7500859.75

 "  Initial write " 1334890.88  1332275.59
 "        Rewrite " 2061126.00  2152643.69
 "           Read " 5749209.88  5652791.62
 "        Re-read " 5845869.00  6261777.25
 "   Reverse Read " 4681375.12  4875618.50
 "    Stride read " 4760689.75  5242670.00
 "    Random read " 5112395.75  4650536.62
 " Mixed workload " 4129292.06  4075847.88
 "   Random write " 2067824.19  2022719.88
 "         Pwrite " 1328648.88  1334709.97
 "          Pread " 2607281.94  2581113.12
 "         Fwrite " 2404771.38  2348427.62
 "          Fread " 7903982.75  7486812.50

	-ss
