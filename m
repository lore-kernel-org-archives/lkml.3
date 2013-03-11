Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3CKPKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:10:13 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:60896 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3CKPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130311003530.GE21522@ZenIV.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307213819.GB19543@redhat.com>
	<CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
	<20130307220333.GA31039@redhat.com>
	<20130307223610.GA2494@redhat.com>
	<CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
	<20130308145306.GA24085@redhat.com>
	<CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
	<20130310221047.GA21522@ZenIV.linux.org.uk>
	<20130311003530.GE21522@ZenIV.linux.org.uk>
Date: Mon, 11 Mar 2013 08:10:10 -0700
X-Google-Sender-Auth: Mdtbv7xFh4OvBmgbr-lwUNfTInc
Message-ID: <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
Subject: Re: pipe_release oops.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 5:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Hmm...  How the devil would things like pipe_read_open() get called, anyway?
> pipe_rdwr_open() can be called, all right - that happens if you do pipe()
> and then open() via /proc/self/fd/<n>.  But how could pipe_read_open() and
> pipe_write_open() be called?  They are accessible only as ->open() of
> read_pipefifo_fops/write_pipefifo_fops.  And those are only used by
> fifo_open(), which does reassign file->f_op to them, but does *not* call
> their ->open()...

.. same deal? Open the resulting fd from /proc/self/fd/<n> afterwards,
which will call file->f_op->open(), no?

                 Linus
