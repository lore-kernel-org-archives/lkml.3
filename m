Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaAXSxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:53:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaAXSxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:53:51 -0500
Message-ID: <52E2B6BB.5040806@infradead.org>
Date: Fri, 24 Jan 2014 10:53:47 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Aaron Tomlin <atomlin@redhat.com>, mingo@kernel.org
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, mingo@redhat.com, oleg@redhat.com,
        riel@redhat.com, bmr@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] mm: Document improved handling of swappiness==0
References: <1390576408-16673-1-git-send-email-atomlin@redhat.com>
In-Reply-To: <1390576408-16673-1-git-send-email-atomlin@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 07:13 AM, Aaron Tomlin wrote:
> Prior to upstream commit fe35004f ("[mm] avoid swapping out
> with swappiness==0") setting swappiness to 0, reclaim code
> could still evict recently used user anonymous memory to swap
> even though there is a significant amount of RAM used for page
> cache.
> 
> The behaviour of setting swappiness to 0 has since changed.
> When set, the reclaim code does not initiate swap until the
> amount of free pages and file-backed pages, is less than the
> high water mark in a zone.
> 
> Let's update the documentation to reflect this.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Bryn M. Reeves <bmr@redhat.com>
> ---
>  Documentation/sysctl/vm.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 9f5481b..38388ee 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -696,7 +696,9 @@ swappiness
>  
>  This control is used to define how aggressive the kernel will swap
>  memory pages.  Higher values will increase agressiveness, lower values
> -decrease the amount of swap.
> +decrease the amount of swap.  A value of 0 instructs the kernel not to
> +initiate swap until the amount of free and file-backed pages, is less

drop the comma                                                 ^

> +than the high water mark in a zone.
>  
>  The default value is 60.
>  
> 


-- 
~Randy
