Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaK0O3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:29:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbaK0O3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:29:47 -0500
Message-ID: <54773557.6020600@suse.de>
Date: Thu, 27 Nov 2014 15:29:43 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "J. German Rivera" <German.Rivera@freescale.com>,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
CC: stuart.yoder@freescale.com, Kim.Phillips@freescale.com,
        scottwood@freescale.com, bhamciu1@freescale.com, R89243@freescale.com,
        Geoff.Thorpe@freescale.com, bhupesh.sharma@freescale.com,
        nir.erez@freescale.com, richard.schmitt@freescale.com
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
In-Reply-To: <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13.11.14 18:54, J. German Rivera wrote:
> APIs to access the Management Complex (MC) hardware
> module of Freescale LS2 SoCs. This patch includes
> APIs to check the MC firmware version and to manipulate
> DPRC objects in the MC.
> 
> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>

[...]

> +/*
> + * Object descriptor, returned from dprc_get_obj()
> + */
> +struct dprc_obj_desc {
> +	/* Type of object: NULL terminated string */
> +	char type[16];

I don't see where it actually gets NULL terminated - all 16 bytes come
directly from the device.

While it's probably ok to trust it, I think we'd still be safer off if
we just make this a char[17] array to always have our NULL terminating
string. That way we're guaranteed we'll never run over our memory
boundaries.

Also sorry for the slowly trickling in comments - I'm just noting things
as I dig through the whole interface :).


Alex
