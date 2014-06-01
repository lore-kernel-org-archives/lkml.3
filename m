Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaFAN5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:57:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328AbaFAN5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:57:34 -0400
Message-ID: <538B314B.2050604@nod.at>
Date: Sun, 01 Jun 2014 15:57:31 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Real Name <enjoymindful@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete unnecessary bootmem struct page array
References: <1401628131-1948-1-git-send-email-enjoymindful@gmail.com> <1401628131-1948-2-git-send-email-enjoymindful@gmail.com>
In-Reply-To: <1401628131-1948-2-git-send-email-enjoymindful@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.06.2014 15:08, schrieb Real Name:
> From: Honggang Li <enjoymindful@gmail.com>
> 
> 1) uml kernel bootmem managed through bootmem_data->node_bootmem_map,
> not the struct page array, so the array is unnecessary.
> 
> 2) the bootmem struct page array has been pointed by a *local* pointer,
> struct page *map, in init_maps function. The array can be accessed only
> in init_maps's scope. As a result, uml kernel wastes about 1% of total
> memory.

I reread your patch again.
You missed one important point. init_maps() setups max_mapnr which is used by
virt_addr_valid().

We have to be extremely careful here to not introduce a subtle fuckup.

Thanks,
//richard
