Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3KUWGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:06:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:65227 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3KUWGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:06:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,747,1378882800"; 
   d="scan'208";a="439489348"
Message-ID: <528E83B6.5040107@intel.com>
Date: Thu, 21 Nov 2013 14:05:42 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>, linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/bootmem.c: remove unused 'limit' variable
References: <20131121164335.066fd6aa@redhat.com>
In-Reply-To: <20131121164335.066fd6aa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 01:43 PM, Luiz Capitulino wrote:
> @@ -655,9 +655,7 @@ restart:
>  void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
>  					unsigned long goal)
>  {
> -	unsigned long limit = 0;
> -
> -	return ___alloc_bootmem_nopanic(size, align, goal, limit);
> +	return ___alloc_bootmem_nopanic(size, align, goal, 0);
>  }

FWIW, I like those.  The way you leave it:

	return ___alloc_bootmem_nopanic(size, align, goal, 0);

the 0 is a magic number that you have to go look up the declaration of
___alloc_bootmem_nopanic() to decipher, or you have to add a comment to
it in some way.

I find it much more readable to have an 'unused' variable like that.
