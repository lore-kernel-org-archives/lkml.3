Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbbALVnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:43:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54302 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbALVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:43:17 -0500
Date: Mon, 12 Jan 2015 16:43:15 -0500 (EST)
Message-Id: <20150112.164315.1318481358364498844.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] usb/kaweth: use GFP_ATOMIC under spin_lock in
 usb_start_wait_urb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420845382-25815-1-git-send-email-khoroshilov@ispras.ru>
References: <1420845382-25815-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 13:43:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Sat, 10 Jan 2015 02:16:22 +0300

> Commit e4c7f259c5be ("USB: kaweth.c: use GFP_ATOMIC under spin_lock")
> makes sure that kaweth_internal_control_msg() allocates memory with GFP_ATOMIC,
> but kaweth_internal_control_msg() also calls usb_start_wait_urb()
> that still allocates memory with GFP_NOIO.
> 
> The patch fixes usb_start_wait_urb() as well.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied, thanks.
