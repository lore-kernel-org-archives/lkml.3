Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3H3PZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:25:11 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:52661 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3H3PZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130830181202.bea6400ec4d92744e05b5b9f@canb.auug.org.au>
References: <20130830181202.bea6400ec4d92744e05b5b9f@canb.auug.org.au>
Date: Fri, 30 Aug 2013 08:25:06 -0700
X-Google-Sender-Auth: eWkgkTb97xpbPlh0cti5-Ag-x4s
Message-ID: <CA+55aFwWEqzGi7uW_xPt=eC0FC-5qnom=W4x87xbH_a2Oy4=6A@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 1:12 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> I don't know if it is safe to read d_lockref.count without locking

That's not the issue. Since commit 84d08fa888e7 ("helper for reading
->d_count") non-core VFS code shouldn't try to access d_count directly
at all. So instead of "dentry->d_count" it should use
"d_count(dentry)". Then the code doesn't need to know about lockrefs
or anything like that at all.

               Linus
