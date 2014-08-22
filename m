Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaHVVn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:43:59 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:55450 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140822185110.GA2333@gmail.com>
References: <cover.1403632276.git.bcrl@kvack.org>
	<f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
	<20140819163733.GA10132@gmail.com>
	<20140819165404.GD13858@kvack.org>
	<20140819171426.GA11811@gmail.com>
	<20140820004651.GJ13858@kvack.org>
	<20140822160111.GD20391@kvack.org>
	<20140822161502.GA30392@gmail.com>
	<20140822162630.GF20391@kvack.org>
	<20140822185110.GA2333@gmail.com>
Date: Fri, 22 Aug 2014 14:43:56 -0700
X-Google-Sender-Auth: hGDJihQ77YHHdq0IghZvwAL2SIY
Message-ID: <CA+55aFzZbRkEh_MbB-XmurVP-4seMP3z9tbq+YQOhkjtDNTzfg@mail.gmail.com>
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user space"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dan Aloni <dan@kernelim.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        "security@kernel.org" <security@kernel.org>, linux-aio@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 11:51 AM, Dan Aloni <dan@kernelim.com> wrote:
>
> Ben, seems that the test program needs some twidling to make the bug
> appear still by setting MAX_IOS to 256 (and it still passes on a
> kernel with the original patch reverted). Under this condition the
> ring buffer size remains 128 (here, 32*4 CPUs), and it is overrun on
> the second attempt.

Ugh.

Ben, at this point my gut feel is that we should just revert the
original "fix", and you should take a much deeper look at this all.
The original "fix" was more broken then the leak it purported to fix,
and now the patch to fix your fix has gone through two iterations and
*still* Dan is finding bugs in it.  I'm getting the feeling that this
code needs more thinking than you are actually putting into it.

                Linus
