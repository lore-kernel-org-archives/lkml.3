Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaKCHPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:15:50 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:49585 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaKCHPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:15:46 -0500
From: Eli Cohen <eli@dev.mellanox.co.il>
X-Google-Original-From: Eli Cohen <eli@mellanox.com>
Date: Mon, 3 Nov 2014 09:15:39 +0200
To: Dave Airlie <airlied@gmail.com>
Cc: Roland Dreier <roland@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Message-ID: <20141103071539.GD742@mtldesk30>
References: <1413499938-2378-1-git-send-email-roland@kernel.org>
 <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 06:06:45AM +1000, Dave Airlie wrote:
> On 17 October 2014 08:52, Roland Dreier <roland@kernel.org> wrote:
> > Hi Linus,
> >
> > Please pull from
> >
> >     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus
> >
> > ----------------------------------------------------------------
> > Main set of InfiniBand/RDMA updates for 3.18 merge window:
> >
> >  - Large set of iSER initiator improvements
> >  - Hardware driver fixes for cxgb4, mlx5 and ocrdma
> >  - Small fixes to core midlayer
> >
> 
> building on 32-bit x86.
> 
>  CC [M]  drivers/infiniband/ulp/iser/iser_verbs.o
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:
> In function ‘iser_handle_comp_error’:
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1171:33:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>   if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
>                                  ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1172:31:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>    struct iser_tx_desc *desc = (struct iser_tx_desc *)wc->wr_id;
>                                ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:
> In function ‘iser_handle_wc’:
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1198:14:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>     rx_desc = (struct iser_rx_desc *)wc->wr_id;
>               ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1203:14:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>     tx_desc = (struct iser_tx_desc *)wc->wr_id;
>               ^
> 
> Not sure anyone would ever want to run this code on 32-bit boxes, but
> I'm a bit worried if wr_id is a 64-bit value, and we encode it into a
> 32-bit pointer, you'd always lose the top 32-bits.
> 
On 32 bit systems your pointer is 32 bits as well so assigning to u64
and casting back to a pointer you don't loose anything. Maybe casting
from u64 to a pointer should go through casting to uintptr_t to avoid
warnings.
