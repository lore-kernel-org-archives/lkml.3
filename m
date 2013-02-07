Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab3BGM72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:59:28 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:60343 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab3BGM7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:59:21 -0500
Date: Thu, 7 Feb 2013 13:59:04 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vivek Goyal <vgoyal@redhat.com>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] mm: don't overwrite mm->def_flags in do_mlockall()
Message-ID: <20130207135904.0ca7a3d5@thinkpad>
In-Reply-To: <20130206125103.61748ed0.akpm@linux-foundation.org>
References: <1360165774-55458-1-git-send-email-gerald.schaefer@de.ibm.com>
	<20130206125103.61748ed0.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 13020712-3548-0000-0000-0000047D764C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013 12:51:03 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  6 Feb 2013 16:49:34 +0100
> Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:
> 
> > With commit 8e72033 "thp: make MADV_HUGEPAGE check for
> > mm->def_flags" the VM_NOHUGEPAGE flag may be set on s390 in
> > mm->def_flags for certain processes, to prevent future thp
> > mappings. This would be overwritten by do_mlockall(), which sets it
> > back to 0 with an optional VM_LOCKED flag set.
> > 
> > To fix this, instead of overwriting mm->def_flags in do_mlockall(),
> > only the VM_LOCKED flag should be set or cleared.
> 
> What are the user-visible effects here?  Looking at the 274023da1e8
> changelog, I'm guessing that it might be pretty nasty - kvm breakage?

Yes, though at the moment there should be no mlockall()/munlockall()
involved with kvm/qemu. So currently no user-visible effects, Vivek
found this while reading the do_mlockall() code, but it might be a
good idea to add this to stable.
Could you add a "Cc: stable@vger.kernel.org # v3.7+"?

Thanks,
Gerald

