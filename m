Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaKBUGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:06:49 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:40082 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaKBUGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:06:47 -0500
MIME-Version: 1.0
In-Reply-To: <1413499938-2378-1-git-send-email-roland@kernel.org>
References: <1413499938-2378-1-git-send-email-roland@kernel.org>
Date: Mon, 3 Nov 2014 06:06:45 +1000
Message-ID: <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
Subject: Re: [GIT PULL] please pull infiniband.git
From: Dave Airlie <airlied@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2014 08:52, Roland Dreier <roland@kernel.org> wrote:
> Hi Linus,
>
> Please pull from
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus
>
> ----------------------------------------------------------------
> Main set of InfiniBand/RDMA updates for 3.18 merge window:
>
>  - Large set of iSER initiator improvements
>  - Hardware driver fixes for cxgb4, mlx5 and ocrdma
>  - Small fixes to core midlayer
>

building on 32-bit x86.

 CC [M]  drivers/infiniband/ulp/iser/iser_verbs.o
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:
In function ‘iser_handle_comp_error’:
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1171:33:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
  if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
                                 ^
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1172:31:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
   struct iser_tx_desc *desc = (struct iser_tx_desc *)wc->wr_id;
                               ^
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:
In function ‘iser_handle_wc’:
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1198:14:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
    rx_desc = (struct iser_rx_desc *)wc->wr_id;
              ^
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1203:14:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
    tx_desc = (struct iser_tx_desc *)wc->wr_id;
              ^

Not sure anyone would ever want to run this code on 32-bit boxes, but
I'm a bit worried if wr_id is a 64-bit value, and we encode it into a
32-bit pointer, you'd always lose the top 32-bits.

Dave.
