Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaDBCnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:43:11 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64428 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaDBCnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140401190502.GA30970@kernel.dk>
References: <20140401190502.GA30970@kernel.dk>
Date: Tue, 1 Apr 2014 19:43:08 -0700
X-Google-Sender-Auth: QFARPWONxfC8tpU-sGobn7VoqOU
Message-ID: <CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO bits for 3.15-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@fb.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Jan Kara <jack@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 12:05 PM, Jens Axboe <axboe@fb.com> wrote:
>
> - Cleanup of the IPI usage from the block layer, and associated helper
>   code. From Frederic Weisbecker and Jan Kara.

So I absolutely *hate* how this was done.

Why the hell was it mixed in with the block layer code? It's not even
in some clean separate branch, it's just randomly in the middle of the
block code, for no obvious reason.

I'm pulling it this time, but quite frankly, next time I see this kind
of ugly AND TOTALLY POINTLESS layering violation, I will just drop the
stupid pull request.

If you want to push me cleanups that are to generic code and are in no
way specific to the block layer, fine. But I want a separate pull
request that is not in any way mixed up with block code.

In other words, this was NOT OK. This was stupid and wrong, and
violated all sanity. I can see absolutely no reason why that
smp_call_function_single_async() renaming and the other cleanups are
in the block branch. They are totally separate in every single way.

What the hell was going on here?

                  Linus
