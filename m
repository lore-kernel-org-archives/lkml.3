Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3JCFhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:37:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab3JCFhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:37:35 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFwKTJp4giDbT6xHZE_o1bzFwDkBAdPvmB3JTpkAEzgYxA@mail.gmail.com>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu> <524CCF38.9000304@zytor.com> <CA+55aFwKTJp4giDbT6xHZE_o1bzFwDkBAdPvmB3JTpkAEzgYxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/7] cross rename
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 02 Oct 2013 22:36:29 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, "zab@redhat.com" <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Miklos Szeredi <mszeredi@suse.cz>
Message-ID: <f4996ec9-3f0d-469d-8459-c1c4c24f75a7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes... Al  and I had a brief conversation about the complexities over IRC this evening.

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Wed, Oct 2, 2013 at 6:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I would suggest it shouldn't be renameat2() but rather renameat3(),
>i.e.
>> rename file A -> B, if B exists rename B to C.  It may not be
>desirable
>> to expose the stale B in the same namespace as A, but still want it
>to
>> be possible to scavenge it.  Obviously, A=C is a valid subcase.
>
>I really *really* prefer to stay with two names. Miklos had an earlier
>three-name version, and it was hugely more complex, and it does not
>fit nearly as well in the model.
>
>Two directory entries is also what the current rename() effectively
>always does (clearing one, changing another). So doing the
>cross-rename model is actually fairly close to a normal rename. A
>three-way one is not actually at all similar.
>
>So I was actually very relieved to see this much simpler and cleaner
>model, because the alternative really was nasty. This one looks fairly
>simple and clean and straightforward. The previous was none of that.
>
>              Linus

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
