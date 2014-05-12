Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaELHw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:52:27 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57117 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaELHw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:52:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Richard Lee <superlibj8301@gmail.com>, linux@arm.linux.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Lee <superlibj@gmail.com>
Subject: Re: [RFC][PATCH 2/2] ARM: ioremap: Add IO mapping space reused support.
Date: Mon, 12 May 2014 09:51:41 +0200
Message-ID: <5146762.jba3IJe7xt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399861195-21087-3-git-send-email-superlibj8301@gmail.com>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com> <1399861195-21087-3-git-send-email-superlibj8301@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wflw0bXlYxVGEkyTMNcu5/3f+7TMSrx/HxY/T6ficzZ
 DKuiHttfUgVJcnWFxkfm7H11O7FyAZq5OwlMa2Ey0qpiXZZ7v6
 f8yHQ4a32m8ejwu6CjHrdtFrMYFlsjj7ry9p0FgmnWgB1IyRll
 T750VVoj4JVIbh6mT4ekCkXPCBHBHUCo1PRFBBt+Lfpvv+scRY
 yGdvHsl/8IsigeG7JZnzmGddkNjCVhEtjKNVIeXyFEhflaxX0d
 LDC8cB2WiRxpGJQ6jluGC5yp3ccMyTBjVSVJFncAz+Tg/NLHK4
 pLIx1blboeVhVU+FaaUUKzwc9jvmgcX8jiyEbD1pjbi7hAi/vf
 vZnW/qGZL1fdEwHNkMec=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2014 10:19:55 Richard Lee wrote:
> For the IO mapping, for the same physical address space maybe
> mapped more than one time, for example, in some SoCs:
> 0x20000000 ~ 0x20001000: are global control IO physical map,
> and this range space will be used by many drivers.
> And then if each driver will do the same ioremap operation, we
> will waste to much malloc virtual spaces.
> 
> This patch add IO mapping space reused support.
> 
> Signed-off-by: Richard Lee <superlibj@gmail.com>

What happens if the first driver then unmaps the area?

	Arnd
