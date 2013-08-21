Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3HUR3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:29:00 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:35737 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3HUR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:28:59 -0400
MIME-Version: 1.0
In-Reply-To: <5214C524.1050900@citrix.com>
References: <5214C524.1050900@citrix.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 Aug 2013 10:28:38 -0700
Message-ID: <CALCETrWZqGUC4+43VT54gFd8qAf+0o4Ekyq8dKVqYpuZOCR9qg@mail.gmail.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
To: David Vrabel <david.vrabel@citrix.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 6:48 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> All,
>
> 179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
> PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as _PTE_PSE
> and _PTE_PAT.
>
> With a Xen PV guest, the use of the _PTE_PAT will result in the page
> having unexpected cachability which will introduce a range of subtle
> performance and correctness issues.  Xen programs the entry 4 in the PAT
> table with WC so a page that was previously WB will end up as WC.
>

Kind of off topic, but do you have a summary of how Xen uses the high
PAT bits?  I'm the one who wants WT, and if there's already precedent
for using the high PAT bits, it'll be helpful.

(Also, Xen is a little weird, and I'd rather not break it again by
accident like I did with the vsyscall changes a couple years ago.)

--Andy
