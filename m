Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab3IEFxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:53:16 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38882 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3IEFxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:53:14 -0400
Date: Thu, 5 Sep 2013 07:53:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gleb Natapov <gleb@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM changes for 3.12
Message-ID: <20130905055307.GA3864@osiris>
References: <20130903121046.GE22899@redhat.com>
 <CA+55aFwYvhLS8onJphR0PnL5e0zyS1ki65O_fSC05TeVSw0hDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwYvhLS8onJphR0PnL5e0zyS1ki65O_fSC05TeVSw0hDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090505-1948-0000-0000-00000632EAF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 06:08:08PM -0700, Linus Torvalds wrote:
> On Tue, Sep 3, 2013 at 5:10 AM, Gleb Natapov <gleb@redhat.com> wrote:
> >
> > This pull request adds tlb_gather_mmu() caller in S390 code, but 2b047252
> > in your tree added another parameter to the function, so the patch bellow
> > have to be applied during merge to resolve the conflicts. The patch was
> > used in linux-next for awhile.
> 
> Hmm. Fine. Except:
> 
> >         /* Reallocate the page tables with pgstes */
> >         mm->context.has_pgste = 1;
> > -       tlb_gather_mmu(&tlb, mm, 0);
> > +       tlb_gather_mmu(&tlb, mm, 0, TASK_SIZE);
> >         page_table_realloc(&tlb, mm, 0, TASK_SIZE);
> >         tlb_finish_mmu(&tlb, 0, -1);
> >         up_write(&mm->mmap_sem);
> 
> Realistically, the begin/end arguments to tlb_gather_mmu() and
> tlb_finish_mmu() should match. In fact, I considered getting rid of
> the ones to tlb_finish_mmu() because they are kind of pointless these
> days (but didn't, because I wanted to keep the patches minimal).
> 
> And in your case they don't. Which implies a certain amount of confusion.

Actually they do match in our internal version of the merge conflict. It
was just a copy-paste error from me when sending the merge resolution patch.
Since the fix contained two changes lines within the same hunk it was
hard to get right.. oh well.. :)

Thanks for fixing it!

