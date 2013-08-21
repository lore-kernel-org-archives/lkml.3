Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3HUOMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:12:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39967 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab3HUOME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:12:04 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5214C524.1050900@citrix.com>
References: <5214C524.1050900@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with existing use
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 21 Aug 2013 16:11:25 +0200
To: David Vrabel <david.vrabel@citrix.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Message-ID: <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eep.  This should be reverted, indeed.  This isn't a manifest bug on !Xen but we have gotten requests for WT support which would mean adding in the PAT but again.

David Vrabel <david.vrabel@citrix.com> wrote:
>All,
>
>179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
>PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as _PTE_PSE
>and _PTE_PAT.
>
>With a Xen PV guest, the use of the _PTE_PAT will result in the page
>having unexpected cachability which will introduce a range of subtle
>performance and correctness issues.  Xen programs the entry 4 in the
>PAT
>table with WC so a page that was previously WB will end up as WC.
>
>The use of this bit also appears to preclude the use of (transparent)
>huge pages by the application.  It is not clear if there is something
>else guaranteeing that that there will be no huge pages.
>
>To fix this regression I suggest one or more of:
>
>1. If no other changes are made, at a mimimum, MEM_SOFT_DIRTY must
>require !XEN and possibly !TRANSPARENT_HUGEPAGE and !HUGETLBFS.  This
>would prevent this option being enabled on the majority of standard
>Linux distributions.
>
>2. Find a different PTE bit to (re)use.
>
>3. Avoid clearing the soft dirty bit when repopulating a swapped out
>page.
>
>4. Redesign the soft dirty tracking to not require the use of
>architecture specific PTE bits.  e.g., by using a shadow set of
>structures for the soft dirty bit tracking.
>
>David

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
