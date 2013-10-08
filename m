Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3JHTU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:20:29 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:50007 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3JHTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131008190523.GW30970@tucnak.zalov.cz>
References: <20131005234430.GA22485@localhost>
	<CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	<20131008075151.GA15689@localhost>
	<CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
	<20131008185154.GA8258@redhat.com>
	<20131008190523.GW30970@tucnak.zalov.cz>
Date: Tue, 8 Oct 2013 12:20:26 -0700
X-Google-Sender-Auth: 8AHTZk_Gpx_ykYWwr_MEkukWCBQ
Message-ID: <CA+55aFx5i=vPeqx9S2WMZdqVC+g-MTczQxPa0mi84Vbs6_YF0g@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 12:05 PM, Jakub Jelinek <jakub@redhat.com> wrote:
>
> If you suspect a compiler bug, can somebody please narrow it down to
> a single object file (if I've skimmed the patch right, it is just an
> optimization, where object files compiled without and with the patch
> should actually coexist fine in the same kernel), ideally to a single
> routine if possible and post a preprocessed source + gcc command line
> + version of gcc?

It is indeed just an optimization, and we could in theory switch
between the two versions on a case-by-case basis, but we don't have
any sane way to really do that.

I'll try to see if I can reproduce this on my hardware (just applying
that patch on top of my own tip) and see if I can try to narrow things
down. But I looked at the assembly for a couple of files, and it all
looked good, and I know this patch works fine for others (ie all the
normal -tip testing), so I suspect it's something specific to what
Fengguang does.

                Linus
