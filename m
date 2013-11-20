Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3KTVTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:19:37 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35944 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3KTVTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <528A648F.1030007@oracle.com>
References: <528A648F.1030007@oracle.com>
Date: Wed, 20 Nov 2013 13:19:33 -0800
X-Google-Sender-Auth: lad0iCTsU0L4d06IB99AWtjc-AI
Message-ID: <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
Subject: Re: [GIT PULL] direct IO support for loop driver
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 11:03 AM, Dave Kleikamp
<dave.kleikamp@oracle.com> wrote:
> Linus,
>
> Please pull the following patches. They add the infrastructure for
> kernel-initiated direct-io, change the loop driver to perform direct-io,
> and change swap-over-nfs to use the new infrastructure.

Quite frankly, I got maybe ten patches into this series, at which
point I just threw my hands up and said: "This is too ugly to live".

The naming in fs/iov-iter.c is disgusting. :ii_iov_xyz? WTF?

Random "flag" value for marking things atomic? F*ck me, that's ugly.

A separate phase for checking addresses instead of just doing it in
the loop that loops over iovec's? Why? It sure as hell isn't because
it's more efficient, and it doubly sure as hell isn't because it's
prettier.

At that point, I just couldn't take it any more.

I really don't see the point of all this crap. All this for the loop
driver? If so, it had better at least be prettier than it is.

                      Linus
