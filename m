Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987AbaD2SJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:09:04 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:58276 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaD2SJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <1398792971-10379-1-git-send-email-mq@suse.cz>
References: <1398792971-10379-1-git-send-email-mq@suse.cz>
Date: Tue, 29 Apr 2014 22:09:01 +0400
Message-ID: <CABjd4Yxj12O7pi2kiqjO+YYU_D=Gdx98yNz6XE4tCX=sL2eYxg@mail.gmail.com>
Subject: Re: [PATCH] net: via-rhine: fix compiler warning
From: Alexey Charkov <alchark@gmail.com>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: Roger Luethi <rl@hellgate.ch>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-29 21:36 GMT+04:00 Jan Moskyto Matejka <mq@suse.cz>:
> Fixed different size cast warning:
>
>         drivers/net/ethernet/via/via-rhine.c: In function ‘rhine_init_one_platform’:
>         drivers/net/ethernet/via/via-rhine.c:1132:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>           revision = (u32)match->data;
>                      ^
>
> That code was added in commit 2d283862dc62daead9db0dc89cd0d0351e91f765
> ("net: via-rhine: add OF bus binding").
>
> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>

Jan, thanks a lot for catching this. Have to admit that I didn't
compile it on 64bit.

Acked-by: Alexey Charkov <alchark@gmail.com>

Looks like the same would apply to e.g. drivers/clk/samsung/clk.c and
maybe some others... Also, a number of drivers cast OF data from (void
*) to (int) or (unsigned int) - isn't this also problematic on 64bit?

Thanks a lot,
Alexey
