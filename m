Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaEVUUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:20:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51697 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaEVUUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:20:36 -0400
Message-ID: <537E5C11.1050600@infradead.org>
Date: Thu, 22 May 2014 13:20:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: poros@redhat.com
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] Documentation: incorrect formula to calculate CommitLimit
 value
References: <1400760284.3145.15.camel@holly>
In-Reply-To: <1400760284.3145.15.camel@holly>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 05:04 AM, Petr Oros wrote:
> The formula to calculate "CommitLimit" value mentioned in kernel documentation is incorrect.
> Right formula is: CommitLimit = ([total RAM pages] - [total huge TLB pages]) * overcommit_ratio / 100 + [total swap pages]
> 
> Signed-off-by: Petr Oros <poros@redhat.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Jiri, please grab this patch.

Thanks.


> ---
>  Documentation/filesystems/proc.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 8b9cd8e..b58d764 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -854,7 +854,8 @@ WritebackTmp: Memory used by FUSE for temporary writeback buffers
>                if strict overcommit accounting is enabled (mode 2 in
>                'vm.overcommit_memory').
>                The CommitLimit is calculated with the following formula:
> -              CommitLimit = ('vm.overcommit_ratio' * Physical RAM) + Swap
> +              CommitLimit = ([total RAM pages] - [total huge TLB pages]) *
> +                             overcommit_ratio / 100 + [total swap pages]
>                For example, on a system with 1G of physical RAM and 7G
>                of swap with a `vm.overcommit_ratio` of 30 it would
>                yield a CommitLimit of 7.3G.
> 


-- 
~Randy
