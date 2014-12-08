Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaLHLvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:51:11 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:51722 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaLHLvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:51:08 -0500
Date: Mon, 8 Dec 2014 13:50:32 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'riel@redhat.com'" <riel@redhat.com>,
        "'nasa4836@gmail.com'" <nasa4836@gmail.com>,
        "'sasha.levin@oracle.com'" <sasha.levin@oracle.com>
Subject: Re: [PATCH] mm:add VM_BUG_ON() for page_mapcount()
Message-ID: <20141208115032.GB28846@node.dhcp.inet.fi>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E688B313F1@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E688B313F5@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313F5@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 03:47:47PM +0800, Wang, Yalin wrote:
> This patch add VM_BUG_ON() for slab page,
> because _mapcount is an union with slab struct in struct page,
> avoid access _mapcount if this page is a slab page.
> Also remove the unneeded bracket.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  include/linux/mm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 11b65cf..34124c4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -373,7 +373,8 @@ static inline void reset_page_mapcount(struct page *page)
>  
>  static inline int page_mapcount(struct page *page)
>  {
> -	return atomic_read(&(page)->_mapcount) + 1;
> +	VM_BUG_ON(PageSlab(page));

VM_BUG_ON_PAGE(), please.

-- 
 Kirill A. Shutemov
