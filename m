Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaEHJkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:40:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16471 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaEHJj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:39:57 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-6c-536b50eb9d6c
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1399541860.13268.48.camel@kjgkr>
Subject: Re: [BUG] kmemleak on __radix_tree_preload
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Thu, 08 May 2014 18:37:40 +0900
In-reply-to: <20140508092646.GA17349@arm.com>
References: <1398390340.4283.36.camel@kjgkr> <20140501170610.GB28745@arm.com>
 <20140501184112.GH23420@cmpxchg.org> <1399431488.13268.29.camel@kjgkr>
 <20140507113928.GB17253@arm.com> <1399540611.13268.45.camel@kjgkr>
 <20140508092646.GA17349@arm.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ93XAdnBBm3rZSzeL+thtFi9ydfi
	8q45bBb31vxndWDxWDNvDaPH4TfvmT02fZrE7vF5k1wASxSXTUpqTmZZapG+XQJXxpX2ycwF
	zyUrZt6/yNbA2CfSxcjJISFgIrGm6S0zhC0mceHeejYQW0hgGaPEyfmGMDWrZkxg7GLkAoov
	YpTYM+k/C0iCV0BQ4sfke2A2s4C6xKR5i5ghbBGJs//fsULY2hLLFr5mhmh+xSjx7u9Edohm
	XYkT63eDFQkLGEssnNrA1MXIwcEG1LB5vwHEEYoSb/ffBSsRASq/0DYFatcURomPx1VAbBYB
	VYnVvXPBRnIC1VxvgNn1j1Hi5szLYM38AqIShxduh/pSSWJ3eyc7hH2KXeLcTTuIQQIS3yYf
	YgG5QUJAVmLTAahySYmDK26wTGCUnIXk5VlIXp6F5OVZSF5ewMiyilE0tSC5oDgpvchErzgx
	t7g0L10vOT93EyMkVifsYLx3wPoQYzLQ+onMUqLJ+cBYzyuJNzQ2M7IwNTE1NjK3NCNNWEmc
	V+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxuINTvMz5jGIyn2c8d5yfcHLu90t0Y3L
	dL+X9XQfNJ+Xu1ZBjfmtdG0od7RGaplgjeyr2eW+mdWFLOmP/00sPFTFfUHlo9av2nlJrKXr
	A7au4Sk+oe6a46XMM33Pp6vv/uw8EGt7RPHyimxTd68l9zdbvPj59n311Xkrjcz3i+iE59d8
	UpU4rcRSnJFoqMVcVJwIAAput+LrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3XAdnBBq1rJCzeL+thtFi9ydfi
	8q45bBb31vxndWDxWDNvDaPH4TfvmT02fZrE7vF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY0bD1sNMBaclK+5PesLawPhJuIuRk0NCwERi1YwJjBC2mMSFe+vZ
	uhi5OIQEFjFK7Jn0nwUkwSsgKPFj8j0gm4ODWUBe4silbJAws4C6xKR5i5gh6l8xSrz7O5Ed
	ol5X4sT63awgtrCAscTCqQ1MIL1sAtoSm/cbgISFBBQl3u6/C1YiAlR+oW0KC8TMKYwSH4+r
	gNgsAqoSq3vngo3kBKq53vAaatc/RombMy+DNfMLiEocXridGeIBJYnd7Z3sExiFZiE5exbC
	2bOQnL2AkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBkP5PawbiyweIQowAHoxIPb4Zz
	VrAQa2JZcWXuIUYJDmYlEV4e/+xgId6UxMqq1KL8+KLSnNTiQ4zJQJdPZJYSTc4HJp28knhD
	YxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamBMXfiJv0Th/H3zTt+g
	nVVPuA+7Tn/l96zC6O3/1JLI59OSWHOO+Xe+3NVe2RIdN4Ntd4Mgq3OpjgrnLOYlD55+eHw9
	R27+JA15ifK991hP2W1b41vNlyzBH9Vv/7FnanBbeJFXG+tOtqYXsT5zN2pKWM78I76sr0b2
	YfbRzV8at1veW9jyyEGJpTgj0VCLuag4EQBcD0lJMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-08 (목), 10:26 +0100, Catalin Marinas:
> On Thu, May 08, 2014 at 06:16:51PM +0900, Jaegeuk Kim wrote:
> > 2014-05-07 (수), 12:39 +0100, Catalin Marinas:
> > > On Wed, May 07, 2014 at 03:58:08AM +0100, Jaegeuk Kim wrote:
> > > > unreferenced object 0xffff880004226da0 (size 576):
> > > >   comm "fsstress", pid 14590, jiffies 4295191259 (age 706.308s)
> > > >   hex dump (first 32 bytes):
> > > >     01 00 00 00 81 ff ff ff 00 00 00 00 00 00 00 00  ................
> > > >     50 89 34 81 ff ff ff ff b8 6d 22 04 00 88 ff ff  P.4......m".....
> > > >   backtrace:
> > > >     [<ffffffff816c02e8>] kmemleak_update_trace+0x58/0x80
> > > >     [<ffffffff81349517>] radix_tree_node_alloc+0x77/0xa0
> > > >     [<ffffffff81349718>] __radix_tree_create+0x1d8/0x230
> > > >     [<ffffffff8113286c>] __add_to_page_cache_locked+0x9c/0x1b0
> > > >     [<ffffffff811329a8>] add_to_page_cache_lru+0x28/0x80
> > > >     [<ffffffff81132f58>] grab_cache_page_write_begin+0x98/0xf0
> > > >     [<ffffffffa02e4bf4>] f2fs_write_begin+0xb4/0x3c0 [f2fs]
> > > >     [<ffffffff81131b77>] generic_perform_write+0xc7/0x1c0
> > > >     [<ffffffff81133b7d>] __generic_file_aio_write+0x1cd/0x3f0
> > > >     [<ffffffff81133dfe>] generic_file_aio_write+0x5e/0xe0
> > > >     [<ffffffff81195c5a>] do_sync_write+0x5a/0x90
> > > >     [<ffffffff811968d2>] vfs_write+0xc2/0x1d0
> > > >     [<ffffffff81196daf>] SyS_write+0x4f/0xb0
> > > >     [<ffffffff816dead2>] system_call_fastpath+0x16/0x1b
> > > >     [<ffffffffffffffff>] 0xffffffffffffffff
> > > 
> > > OK, it shows that the allocation happens via add_to_page_cache_locked()
> > > and I guess it's page_cache_tree_insert() which calls
> > > __radix_tree_create() (the latter reusing the preloaded node). I'm not
> > > familiar enough to this code (radix-tree.c and filemap.c) to tell where
> > > the node should have been freed, who keeps track of it.
> > > 
> > > At a quick look at the hex dump (assuming that the above leak is struct
> > > radix_tree_node):
> > > 
> > > 	.path = 1
> > > 	.count = -0x7f (or 0xffffff81 as unsigned int)
> > > 	union {
> > > 		{
> > > 			.parent = NULL
> > > 			.private_data = 0xffffffff81348950
> > > 		}
> > > 		{
> > > 			.rcu_head.next = NULL
> > > 			.rcu_head.func = 0xffffffff81348950
> > > 		}
> > > 	}
> > > 
> > > The count is a bit suspicious.
> > > 
> > > From the union, it looks most likely like rcu_head information. Is
> > > radix_tree_node_rcu_free() function at the above rcu_head.func?
> 
> Thanks for the config. Could you please confirm that 0xffffffff81348950
> address corresponds to the radix_tree_node_rcu_free() function in your
> System.map (or something else)?

Yap, the address is matched to radix_tree_node_rcu_free().
Thanks,

> 
> > > Also, if you run echo scan > /sys/kernel/debug/kmemleak a few times, do
> > > any of the above leaks disappear (in case the above are some transient
> > > rcu freeing reports; normally this shouldn't happen as the objects are
> > > still referred but I'll look at the relevant code once I have your
> > > .config).
> > 
> > Once I run the echo, the leaks are still remained.
> 
> OK, so they aren't just transient.
> 
> Thanks.
> 

-- 
Jaegeuk Kim
Samsung

