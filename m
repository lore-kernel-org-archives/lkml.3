Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaL2Kk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:40:58 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:56327 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaL2Kk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:40:56 -0500
Date: Mon, 29 Dec 2014 12:37:57 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        davej@redhat.com, sasha.levin@oracle.com, hughd@google.com,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 30/38] s390: drop pte_file()-related helpers
Message-ID: <20141229103757.GA379@node.dhcp.inet.fi>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1419423766-114457-31-git-send-email-kirill.shutemov@linux.intel.com>
 <20141229110727.75afa56d@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141229110727.75afa56d@mschwide>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 11:07:27AM +0100, Martin Schwidefsky wrote:
> On Wed, 24 Dec 2014 14:22:38 +0200
> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > We've replaced remap_file_pages(2) implementation with emulation.
> > Nobody creates non-linear mapping anymore.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > ---
> > @@ -279,7 +279,6 @@ static inline int is_module_addr(void *addr)
> >   *
> >   * pte_present is true for the bit pattern .xx...xxxxx1, (pte & 0x001) == 0x001
> >   * pte_none    is true for the bit pattern .10...xxxx00, (pte & 0x603) == 0x400
> > - * pte_file    is true for the bit pattern .11...xxxxx0, (pte & 0x601) == 0x600
> >   * pte_swap    is true for the bit pattern .10...xxxx10, (pte & 0x603) == 0x402
> >   */
>  
> Nice, once this is upstream I can free up one of the software bits in
> the pte by redefining the type bits. Right now all of them are used up.
> Is the removal of non-linear mappings a done deal ?

Yes, if no horrible regression will be reported. We don't create
non-linear mapping in -mm (and -next) tree for a few release cycles.
Nobody complained so far.

Ack?

-- 
 Kirill A. Shutemov
