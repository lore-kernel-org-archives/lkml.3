Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3LSXAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:00:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36531 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3LSXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:00:06 -0500
Date: Thu, 19 Dec 2013 18:00:01 -0500 (EST)
Message-Id: <20131219.180001.2300376892730549121.davem@davemloft.net>
To: therbert@google.com
Cc: haiyangz@microsoft.com, dborkman@redhat.com, bhutchings@solarflare.com,
        netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+mtBx_SSPd6s5519dWCyPGmFvO=kE+Fh3ZQ9w9oo=pJraRAFQ@mail.gmail.com>
References: <CA+mtBx-BBBQjVTOrnaow=GNc7VM5D2Zj8xr=fPM4b4f_xT7qkQ@mail.gmail.com>
	<05be4f23ff784e56b710dd02eb88358a@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
	<CA+mtBx_SSPd6s5519dWCyPGmFvO=kE+Fh3ZQ9w9oo=pJraRAFQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:00:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Herbert <therbert@google.com>
Date: Thu, 19 Dec 2013 13:43:06 -0800

> +       u32 v, r;
> +       int off, rem;
> +
> +       off = idx / 8;
> +       rem = idx % 8;
> +
> +       v = (((unsigned int)key[off]) << 24) +
> +           (((unsigned int)key[off + 1]) << 16) +
> +           (((unsigned int)key[off + 2]) << 8) +
> +           (((unsigned int)key[off + 3]));
> +
> +       r = v << rem | (unsigned int)key[off + 4] >> (8 - rem);

Minor nit, since the type you are using is "u32", that's probably what
you should be casting to in these spots instead of "unsigned int".
