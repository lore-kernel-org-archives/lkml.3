Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaK1NTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:19:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaK1NTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:19:19 -0500
Message-ID: <54787654.7020304@suse.cz>
Date: Fri, 28 Nov 2014 14:19:16 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eddie Kovsky <ewk@edkovsky.org>
CC: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Fix compiler warning
References: <20141120054437.GA30162@athena>
In-Reply-To: <20141120054437.GA30162@athena>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-20 06:44, Eddie Kovsky wrote:
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index a26cc5d2a9b0..a728d23949e7 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -559,8 +559,8 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>  		if (location == NULL && accessible)
>  			location = menu;
>  	}
> +	jump = xmalloc(sizeof(*jump));
>  	if (head && location) {
> -		jump = xmalloc(sizeof(struct jump_key));

This creates a memory leak, because 'jump' is allocated, but not added
to the list, if the following condition is not met.

Michal

