Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3JIBdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:33:54 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:62759 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3JIBds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:33:48 -0400
MIME-Version: 1.0
In-Reply-To: <20131009010911.GA4222@localhost>
References: <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
	<20131008171522.GA29277@localhost>
	<CA+55aFzQC=W010GTxjXjBnsKO0CycXe7VZB+LTiNNtuBug_rbw@mail.gmail.com>
	<20131009010911.GA4222@localhost>
Date: Tue, 8 Oct 2013 18:33:45 -0700
X-Google-Sender-Auth: yvSaJZL8-17SCYd2K1NCovrnsUQ
Message-ID: <CA+55aFyFJMUAADPmGHUVX9OWOt_jN=WhfQ0EBMCY5+LOKxMXqA@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel NULL pointer dereference at (null)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>, Jakub Jelinek <jakub@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 6:09 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> [   27.189229] BUG: unable to handle kernel NULL pointer dereference at 00000108
> [   27.190165] IP: [<c1109200>] rw_verify_area+0xa0/0x1b0

This looks like file->f_inode is NULL, and it's trying to access inode->i_flock.

There's a number of other ones too (that last delayed __fput one, for
example) that might be due to a NULL inode.

And a lot of thre rest are file-handling too, with the BUG_ON() in
__put_cred() when there's something wrong with file->f_cred.

.. but I have no clue how that could happen and why the asm goto
should matter for this.

              Linus
