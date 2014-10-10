Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaJJOfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:35:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:63081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaJJOfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:35:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,692,1406617200"; 
   d="scan'208";a="586743167"
Message-ID: <5437EEA3.50705@intel.com>
Date: Fri, 10 Oct 2014 07:35:15 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fengwei Yin <yfw.kernel@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        fengguang.wu@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] smaps should deal with huge zero page exactly same as
 normal zero page
References: <CADUXgx7QTWBMxesxgCet5rjpGu-V-xK_-5f2rX9R+v-ggi902A@mail.gmail.com> <5436B98E.1070407@intel.com> <20141010132027.GB25038@gmail.com>
In-Reply-To: <20141010132027.GB25038@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 06:21 AM, Fengwei Yin wrote:
> @@ -787,6 +788,9 @@ check_pfn:
>  		return NULL;
>  	}
>  
> +	if (is_huge_zero_pfn(pfn))
> +		return NULL;
> +

That looks a lot better.  One thing, why not put the is_huge_zero_pfn()
check next to the is_zero_pfn() check?
