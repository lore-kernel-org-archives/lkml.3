Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaEUJXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:23:55 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:43164 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751066AbaEUJXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:23:53 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.455
Date: Wed, 21 May 2014 17:23:38 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <1381816856.42144.1400664218906.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537C6D95.4040803@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_?=
 =?utf-8?Q?[PATCH]_arch/?= =?utf-8?Q?unicore32/kernel/setup.c:_?=
 =?utf-8?Q?add_generic_'screen=5Finfo'_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> 
> Yeah, I shall send patch v2 for it (within this week). And also thank
> you for your review the other patches.
> 
> BTW: I guess, it only leaves 2 kernel related issues for allmodconfig:
> 
>  - one for 'find_first*', 'cpuc_coherent_kern_range' and 'pm_power_off'.
>    I guess, we can export their symbol explicitly to fix this issue.

My suggestion:
 find_first_* could export themselves in lib/find_first.c, so each archs can use it.
   anyway, we can first add them in unicore32, and then make it a generic lib.
 what's the problem with cpuc_coherent_kern_range? in fact, I'll remove it later.
 pm_power_off need be exported.

> 
>  - the other for additional 'clk_*' which are needed when HAVE_CLK.
>    I guess, just "copy/past" the other platforms' implementation is OK.

Maybe, COMMON_CLK should be selected. I'm not sure.

> 
> The related errors:
> 
>   ERROR: "clk_round_rate" [sound/spi/snd-at73c213.ko] undefined!
>   ERROR: "clk_set_parent" [sound/soc/jz4740/snd-soc-jz4740-i2s.ko] undefined!
>   ERROR: "clk_round_rate" [sound/soc/fsl/snd-soc-fsl-ssi.ko] undefined!
>   ERROR: "clk_round_rate" [sound/soc/fsl/snd-soc-fsl-spdif.ko] undefined!
>   ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
>   ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
>   ERROR: "find_first_bit" [net/phonet/phonet.ko] undefined!
>   ERROR: "find_first_zero_bit" [net/nfc/nfc.ko] undefined!
>   ERROR: "find_first_zero_bit" [net/netfilter/nf_tables.ko] undefined!
>   ERROR: "find_first_bit" [net/mac80211/mac80211.ko] undefined!
>   ERROR: "find_first_zero_bit" [net/bridge/bridge.ko] undefined!
>   ERROR: "find_first_bit" [net/bridge/bridge.ko] undefined!
>   ERROR: "find_first_zero_bit" [fs/reiserfs/reiserfs.ko] undefined!
>   ERROR: "find_first_bit" [fs/ocfs2/ocfs2.ko] undefined!
>   ERROR: "find_first_zero_bit" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
>   ERROR: "find_first_bit" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
>   ERROR: "find_first_zero_bit" [fs/nfs/nfsv4.ko] undefined!
>   ERROR: "find_first_zero_bit" [fs/minix/minix.ko] undefined!
>   ERROR: "find_first_bit" [fs/hfsplus/hfsplus.ko] undefined!
>   ERROR: "find_first_zero_bit" [fs/gfs2/gfs2.ko] undefined!
>   ERROR: "find_first_zero_bit" [fs/bfs/bfs.ko] undefined!
>   ERROR: "find_first_zero_bit" [drivers/uwb/uwb.ko] undefined!
>   ...
> 
> Thanks.
> -- 
> Chen Gang
> 
> Open, share, and attitude like air, water, and life which God blessed

