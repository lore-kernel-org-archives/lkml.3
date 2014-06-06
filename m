Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaFFU2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:28:19 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42277 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFFU2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:28:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140606173546.GA1869@zod>
References: <20140606173546.GA1869@zod>
Date: Fri, 6 Jun 2014 13:28:09 -0700
X-Google-Sender-Auth: G9Y6Osw0bgflswkGO0mrd6r_0A0
Message-ID: <CA+55aFw6xpiU0ja0uUAKAyT2M4xp=XxZcT2=g2O1VQUdA9iAyg@mail.gmail.com>
Subject: Re: pte_present check on hugetlb_entry fix for 3.15?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 10:36 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>
>  I poked Linus about this
> early today privately (my fault, apologies) and he had some
> questions/comments on the code.

I changed it a bit (made the patch smaller by removing the now stale
"pte_none()" check) and added a comment about the apparent bogosity of
the generic page table walker to the commit message, but it's
basically applied to the current 3.15 git tree.

If some architecture really has a "pte_present()" function that
requires you to check "pte_none()" first, that architecture is
completely broken and would need to be fixed. I don't think that
exists, though.

              Linus
