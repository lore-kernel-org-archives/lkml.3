Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab3BKC6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 21:58:50 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58960 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140Ab3BKC6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 21:58:48 -0500
Message-ID: <1360551527.2028.10.camel@joe-AO722>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 net-next tree
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Date: Sun, 10 Feb 2013 18:58:47 -0800
In-Reply-To: <20130211133350.5f510bbb28759960a19a98af@canb.auug.org.au>
References: <20130211133350.5f510bbb28759960a19a98af@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 13:33 +1100, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless-next tree got conflicts in
> drivers/net/wireless/ti/wlcore/sdio.c and
> drivers/net/wireless/ti/wlcore/spi.c between commit 0d2e7a5c6080
> ("wireless: Remove unnecessary alloc/OOM messages, alloc cleanups") from
> the net-next tree and commit afb43e6d88e5 ("wlcore: remove if_ops from
> platform_data") from the wireless-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Thanks Stephen.

Can you remove just the dev_err below too please.

+       pdev_data = kzalloc(sizeof(*pdev_data), GFP_KERNEL);
+       if (!pdev_data) {
+               dev_err(&func->dev, "can't allocate platdev_data\n");
+               goto out;
+       }

Joe

