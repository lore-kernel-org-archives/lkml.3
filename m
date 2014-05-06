Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaEFRBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:01:24 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:35782 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaEFRBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:01:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140506165233.GR18016@ZenIV.linux.org.uk>
References: <20140502055127.GH18016@ZenIV.linux.org.uk>
	<CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
	<20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
	<20140502224022.GJ18016@ZenIV.linux.org.uk>
	<20140503042604.GM18016@ZenIV.linux.org.uk>
	<20140503182110.GN18016@ZenIV.linux.org.uk>
	<20140504062915.GQ18016@ZenIV.linux.org.uk>
	<CAJfpegvWOzd01tW5nRfWKW7EoBgPD8rudODJJm5OqxPd5Pd7uA@mail.gmail.com>
	<CA+55aFxeVn2Xfa4Dwt2+GzAL7MxV3UK-jMf-+Nvm2HE9hETS9w@mail.gmail.com>
	<20140506165233.GR18016@ZenIV.linux.org.uk>
Date: Tue, 6 May 2014 10:01:21 -0700
X-Google-Sender-Auth: 5lA6GIUxZCvS26-ik3OKMYrOKLY
Message-ID: <CA+55aFwzkKAFD3Bmq3G9xu2xNgbwfwY1gDv+2CWcjJJb0PCD5g@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 9:52 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK...  There's one more thing I would like to put there, if you are going to
> be away for the week.  It has sat in -next for a while, and it could stay
> there, except that there's a _lot_ of followups touching stuff all over the
> tree and I'd obviously prefer those to go into subsystem trees.  Which
> means inter-tree dependencies ;-/  Would you be OK if I included that one
> into pull request?  It just turns kvfree() into inline and takes it to
> mm.h, next to is_vmalloc_addr();

Is there any particular reason for inlining this? I'd actually rather
not, _especially_ if it means that a lot of "is_vmalloc_addr()" usage
goes away and we may end up with this as a real interface.

But no, I don't hate the patch.

              Linus
