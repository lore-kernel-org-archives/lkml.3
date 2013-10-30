Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3J3DuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:50:10 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47736 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3J3DuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <20131029.224227.1700872646112764527.davem@davemloft.net>
References: <1383084998-22673-1-git-send-email-tdmackey@booleanhaiku.com>
	<20131029.224227.1700872646112764527.davem@davemloft.net>
Date: Tue, 29 Oct 2013 20:50:08 -0700
Message-ID: <CAM_iQpXzJOxZ3MFNthKw5ye=WcxDWbiPaHuL=pHMz7D1R4nJ+w@mail.gmail.com>
Subject: Re: [PATCH] bnx2: Use dev_kfree_skb_any() in bnx2_tx_int()
From: Cong Wang <xiyou.wangcong@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tdmackey@booleanhaiku.com, mchan@broadcom.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 7:42 PM, David Miller <davem@davemloft.net> wrote:
> From: David Mackey <tdmackey@booleanhaiku.com>
> Date: Tue, 29 Oct 2013 15:16:38 -0700
>
>> Using dev_kfree_skb_any() will resolve the below issue when a
>> netconsole message is transmitted in an irq.
>  ...
>> Signed-off-by: David Mackey <tdmackey@booleanhaiku.com>
>
> This is absolutely not the correct fix.
>
> The netpoll facility must invoke ->poll() in an environment which
> is compatible, locking and interrupt/soft-interrupt wise, as that
> in which it is normally called.
>

Normally ->poll() is called in softirq context, while netpoll could
be called in any context depending on its caller.

Also, netpoll disables IRQ for tx, which is another difference.
