Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaGQRFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:05:25 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:53277 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaGQRFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140717170115.GO1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org> <20140717170115.GO1491@thunk.org>
From: Bob Beck <beck@openbsd.org>
Date: Thu, 17 Jul 2014 11:05:01 -0600
X-Google-Sender-Auth: QeUQy4VNQE1AcXoFKgpuVHj8N8Q
Message-ID: <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
To: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-abi <linux-abi@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Bob Beck <beck@openbsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, yeah I understand the reasoning, it would be good if there was
a way to influence the various libc people to
ensure they manage to provide a getentropy().


On Thu, Jul 17, 2014 at 11:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 17, 2014 at 09:12:15AM -0700, Christoph Hellwig wrote:
>> On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:
>> > The getrandom(2) system call was requested by the LibreSSL Portable
>> > developers.  It is analoguous to the getentropy(2) system call in
>> > OpenBSD.
>>
>> What's the reason to not implement exactly the same system call OpenBSD
>> does?  Having slightly different names and semantics for the same
>> functionality is highly annoying.
>
> The getrandom(2) system call is a superset of getentropy(2).  When we
> add the support for this into glibc, it won't be terribly difficult
> nor annoying to drop the following in alongside the standard support
> needed for any new system call:
>
> int getentropy(void *buf, size_t buflen)
> {
>         int     ret;
>
>         ret = getentropy(buf, buflen, 0);
>         return (ret > 0) ? 0 : ret;
> }
>
> The reason for the additional flags is that I'm trying to solve more
> problems than just getentropy()'s raison d'etre.  The discussion of
> this is in the commit description; let me know if there bits that I
> could make clearer.
>
> Cheers,
>
>                                         - Ted
