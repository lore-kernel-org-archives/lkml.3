Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaKCH6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:58:36 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52336 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaKCH6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:58:35 -0500
Message-ID: <545735A4.6060107@dev.mellanox.co.il>
Date: Mon, 03 Nov 2014 09:58:28 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>, Roland Dreier <roland@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] please pull infiniband.git
References: <1413499938-2378-1-git-send-email-roland@kernel.org> <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
In-Reply-To: <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/2014 10:06 PM, Dave Airlie wrote:
> On 17 October 2014 08:52, Roland Dreier <roland@kernel.org> wrote:
>> Hi Linus,
>>
>> Please pull from
>>
>>      git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus
>>
>> ----------------------------------------------------------------
>> Main set of InfiniBand/RDMA updates for 3.18 merge window:
>>
>>   - Large set of iSER initiator improvements
>>   - Hardware driver fixes for cxgb4, mlx5 and ocrdma
>>   - Small fixes to core midlayer
>>
>
> building on 32-bit x86.
>
>   CC [M]  drivers/infiniband/ulp/iser/iser_verbs.o
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:
> In function ‘iser_handle_comp_error’:
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1171:33:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>    if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
>                                   ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1172:31:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>     struct iser_tx_desc *desc = (struct iser_tx_desc *)wc->wr_id;
>                                 ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:
> In function ‘iser_handle_wc’:
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1198:14:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>      rx_desc = (struct iser_rx_desc *)wc->wr_id;
>                ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_verbs.c:1203:14:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>      tx_desc = (struct iser_tx_desc *)wc->wr_id;
>                ^
>
> Not sure anyone would ever want to run this code on 32-bit boxes, but
> I'm a bit worried if wr_id is a 64-bit value, and we encode it into a
> 32-bit pointer, you'd always lose the top 32-bits.
>

Hey Dave,

This was addressed in: 
http://marc.info/?l=linux-rdma&m=141448978030924&w=2 (part of iser fixes 
for 3.18-rc).

Thanks!

Sagi.
