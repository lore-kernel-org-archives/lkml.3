Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbbANOhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:37:09 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:60240 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbANOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:37:07 -0500
MIME-Version: 1.0
In-Reply-To: <87oaq1v49z.fsf@rasmusvillemoes.dk>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
	<87oaq1v49z.fsf@rasmusvillemoes.dk>
Date: Wed, 14 Jan 2015 20:07:06 +0530
Message-ID: <CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 19:43, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> Just thinking out loud: Could one simply mark a VMA as being used for
> stack during the clone call (is there room in vm_flags, or does
> VM_GROWSDOWN already tell the whole story?), and then write the TID into
> a new field in the VMA - I think one could make a union with vm_pgoff so
> as not to enlarge the structure.

vm_flags does not have space IIRC (that was my first approach at
implementing this) and VM_GROWSDOWN is not sufficient.  If we can make
a union with vm_pgoff like you say, we probably don't need a flag
value; a non-zero value could indicate that it is a thread stack.

One problem with caching the value on clone like this though is that
the stack could change due to a setcontext, but AFAICT we don't care
about that for the process stack either.

Siddhesh
-- 
http://siddhesh.in
