Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3AUCO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:14:29 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:35049 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3AUCO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:14:28 -0500
MIME-Version: 1.0
In-Reply-To: <7vpq0zi9c7.fsf@alter.siamese.dyndns.org>
References: <87zk03wg7r.fsf@rustcorp.com.au> <CA+55aFwzdcv0LXovZobha=EH=L6DapJt+ODP0nq=TWWAqCxLYQ@mail.gmail.com>
 <87fw1vwcao.fsf@rustcorp.com.au> <CA+55aFy1nW859yaGP17epRX8A+TaJ8APvb0-Ww1zw91dCAOhoQ@mail.gmail.com>
 <7vpq0zi9c7.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 18:14:06 -0800
X-Google-Sender-Auth: 6hPNTy2zwUlgyimM7RjN0tnRnqA
Message-ID: <CA+55aFw=8w8Eao3iA5F5-jFaO0MtcH+jivTD8SkDtMfrhQgWHg@mail.gmail.com>
Subject: Re: [PULL] Module fixes, and a virtio block fix.
To: Junio C Hamano <gitster@pobox.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Git Mailing List <git@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Alexander Graf <agraf@suse.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 6:00 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> What you mean by "corrupt" is not clear to me

Some versions would just silently change the actual name you were using.

So if you said "for-linus", it might change it to "linus", just
because that branch happened to have the same SHA1 commit ID.

That's not right.

Other versions would replace the "for-linus" with "**missing-branch**"
because "for-linus" hadn't mirrored out yet.

That's not right either.

Basically, if "git request-pull" is given a branch/tag name, that is
the only valid output (although going from branch->tag *might* be
acceptable). The whole "verify that it actually exists on the remote
side" must never *ever* actually change the message itself, it should
just cause a warning outside of the message.

I can't say from the commit message whether that's the thing that
fixed it or not, but at least some people stopped sending me broken
pull requests after updating to git. I'm just not sure which of the
two different failure cases they happened to have (Rusty seems to have
hit both)

            Linus
