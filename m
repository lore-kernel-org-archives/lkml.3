Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaL2KHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:07:39 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:32840 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaL2KHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:07:35 -0500
Date: Mon, 29 Dec 2014 11:07:27 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        davej@redhat.com, sasha.levin@oracle.com, hughd@google.com,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 30/38] s390: drop pte_file()-related helpers
Message-ID: <20141229110727.75afa56d@mschwide>
In-Reply-To: <1419423766-114457-31-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1419423766-114457-31-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122910-0013-0000-0000-0000025E7CDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2014 14:22:38 +0200
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> @@ -279,7 +279,6 @@ static inline int is_module_addr(void *addr)
>   *
>   * pte_present is true for the bit pattern .xx...xxxxx1, (pte & 0x001) == 0x001
>   * pte_none    is true for the bit pattern .10...xxxx00, (pte & 0x603) == 0x400
> - * pte_file    is true for the bit pattern .11...xxxxx0, (pte & 0x601) == 0x600
>   * pte_swap    is true for the bit pattern .10...xxxx10, (pte & 0x603) == 0x402
>   */
 
Nice, once this is upstream I can free up one of the software bits in
the pte by redefining the type bits. Right now all of them are used up.
Is the removal of non-linear mappings a done deal ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

