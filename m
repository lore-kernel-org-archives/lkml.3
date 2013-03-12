Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3CLPbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:31:53 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:48230 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3CLPbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130312130614.GA32237@ZenIV.linux.org.uk>
References: <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
	<20130307220333.GA31039@redhat.com>
	<20130307223610.GA2494@redhat.com>
	<CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
	<20130308145306.GA24085@redhat.com>
	<CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
	<20130310221047.GA21522@ZenIV.linux.org.uk>
	<20130311003530.GE21522@ZenIV.linux.org.uk>
	<CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
	<20130311180543.GF21522@ZenIV.linux.org.uk>
	<20130312130614.GA32237@ZenIV.linux.org.uk>
Date: Tue, 12 Mar 2013 08:31:50 -0700
X-Google-Sender-Auth: dhs0WW2FF4HgYQYaOCUv54lpHBc
Message-ID: <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
Subject: Re: pipe_release oops.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 6:06 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> While we are at it, I don't see any reason for having separate file_operations
> for r/o, w/o and r/w cases; the only differences are in EBADF-returning
> ->read() and ->write() (and ->f_mode checks in vfs_read() et.al. take care of
> that) and micro-optimizations in ->release() and ->fasync().
>
> Frankly, I really wonder if we should simply use def_fifo_fops for ->i_fops
> in get_pipe_inode() and let open() via /proc/<pid>/fd/<n> act as it would for
> FIFOs, O_NONBLOCK and all.  IOW, how about we simply merge all those
> file_operations in one, folding fifo.c into pipe.c?  And to hell with any
> reassignments of ->f_op.
>
> I'm probably missing something subtle here...

Probably not missing anything subtle. I think all of this code is very
old, and related to previous /proc/<pid>/fd/<n> escapades. And the
semantics for those files were in flux some time long long ago (the
whole "dup vs new struct file" issue), it's all just duct-tape, I
think.

             Linus
