Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaE1KDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:03:30 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:43776 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaE1KD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:03:26 -0400
Message-ID: <5385B46B.9030807@imgtec.com>
Date: Wed, 28 May 2014 11:03:23 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        <linux-metag@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul <Paul.Burton@imgtec.com>
Subject: Re: [PATCH] arch: metag: mm: hugetlbpage.c:  Cleaning up inconsistent
 NULL checks
References: <1400796102-12832-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400796102-12832-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On 22/05/14 23:01, Rickard Strandqvist wrote:
> Cleaning up inconsistent NULL checks.
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/metag/mm/hugetlbpage.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
> index 0424315..3f8d5cd 100644
> --- a/arch/metag/mm/hugetlbpage.c
> +++ b/arch/metag/mm/hugetlbpage.c
> @@ -188,7 +188,8 @@ new_search:
>  			}
>  		}
>  		after_huge = 0;
> -		addr = ALIGN_HUGEPT(vma->vm_end);
> +		if (vma)
> +			addr = ALIGN_HUGEPT(vma->vm_end);
>  	}
>  }
>  #endif
> 

I don't think this is a correct fix.

If !vma && !after_huge the first if block in the loop will match and the
function will return 0.
If !vma && after_huge the 3rd if block in the loop will match and the
function will return addr.

So removing the vma condition on the final if block in the loop would
probably make sense instead. Does that satisfy cppcheck?

Cheers
James
