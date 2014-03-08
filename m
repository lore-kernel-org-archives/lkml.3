Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaCHLri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:47:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57737 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaCHLrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:47:35 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-f2-531b035615e2
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>, "'Kim'" <jaegeuk.kim@samsung.com>
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
References: <5319A2CC.3090206@cn.fujitsu.com>
In-reply-to: <5319A2CC.3090206@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH 1/5] f2fs: update start nid only once each circle
Date: Sat, 08 Mar 2014 19:46:35 +0800
Message-id: <001301cf3ac4$3220b8c0$96622a40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHEbXlHbUtYU5soaumMUpeUQDOhV5rsFyoQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jQd0wZulgg8YPchbP2w8wW1zf9ZfJ
	4tIid4vLu+awObB4/D84idlj94LPTB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVcWHDL5aC
	a3wVM+/+Z21g/MndxcjJISFgIjFx9RVmCFtM4sK99WxdjFwcQgLTGSWOv/nFCuH8YJS4Mukw
	I0gVm4CKxPKO/0wgtoiAp8Sdi71AcQ4OZoEUieVdtiBhIQFdieMd05hBwpwCehKdr2JBwsIC
	ARJP1p8F62QRUJVY2ryQHaSEV8BS4u9RG5Awr4CgxI/J91hAbGYBLYn1O48zQdjyEpvXvIU6
	U0Fix9nXjBAHGEk8f/CDFaJGXGLjkVssExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnD4P5PewbiqweIQowAHoxIPb8ALyWAh1sSy4srcQ4wSHMxKIryP
	X0oFC/GmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBkueTl
	EWJhvKHQVfj3QQV7jxtXT50/19B8ZsryB2G7dR7tF553c4nr13l3pM2YfIUMI3sDd71f296x
	3155Wtuyj+mXNs1j2cKrOkej4Zb4ygdPo9Y9PbkzTv2RoMrRHJfGuRFXJh5fc3aWEv+Hzaf/
	JX6fXMNnZrLAWzHJ52D+3pr3B+ysliW9UWIpzkg01GIuKk4EANXfZIF7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Friday, March 07, 2014 6:43 PM
> To: Kim
> Cc: linux-kernel; f2fs
> Subject: [f2fs-dev] [PATCH 1/5] f2fs: update start nid only once each circle
> 
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/node.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 8c14110..9653096 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1875,11 +1875,15 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
>  	while ((found = __gang_lookup_nat_cache(nm_i,
>  					nid, NATVEC_SIZE, natvec))) {
>  		unsigned idx;
> +
> +		nid = nat_get_nid(natvec[found - 1]) + 1;
> +
>  		for (idx = 0; idx < found; idx++) {
>  			struct nat_entry *e = natvec[idx];

Could we replace argument 'e' with 'natvec[idx]'? then we could remove 'e' and
brace here.

Thanks.

> -			nid = nat_get_nid(e) + 1;
> +
>  			__del_from_nat_cache(nm_i, e);
>  		}
> +
>  	}
>  	f2fs_bug_on(nm_i->nat_cnt);
>  	write_unlock(&nm_i->nat_tree_lock);
> --
> 1.7.7
> 
> 
> ------------------------------------------------------------------------------
> Subversion Kills Productivity. Get off Subversion & Make the Move to Perforce.
> With Perforce, you get hassle-free workflows. Merge that actually works.
> Faster operations. Version large binaries.  Built-in WAN optimization and the
> freedom to use Git, Perforce or both. Make the move to Perforce.
> http://pubads.g.doubleclick.net/gampad/clk?id=122218951&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

