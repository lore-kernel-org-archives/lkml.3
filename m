Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaFPP14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:27:56 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:15318 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaFPP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:27:55 -0400
Message-ID: <539F0CF7.7010108@imgtec.com>
Date: Mon, 16 Jun 2014 16:27:51 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        <linux-metag@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: metag: mm: hugetlbpage.c:  Fix to remove null pointer
 checks that could never happen
References: <1401405118-11387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401405118-11387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/14 00:11, Rickard Strandqvist wrote:
> Removal of null pointer checks that could never happen
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied, thanks
James

> ---
>  arch/metag/mm/hugetlbpage.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
> index 0424315..e89c843 100644
> --- a/arch/metag/mm/hugetlbpage.c
> +++ b/arch/metag/mm/hugetlbpage.c
> @@ -178,7 +178,7 @@ new_search:
>  				mm->context.part_huge = 0;
>  			return addr;
>  		}
> -		if (vma && (vma->vm_flags & MAP_HUGETLB)) {
> +		if ((vma->vm_flags & MAP_HUGETLB)) {
>  			/* space after a huge vma in 2nd level page table? */
>  			if (vma->vm_end & HUGEPT_MASK) {
>  				after_huge = 1;
> 
