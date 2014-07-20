Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaGTRG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:06:59 -0400
Received: from imap.thunk.org ([74.207.234.97]:46132 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaGTRG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:06:58 -0400
Date: Sun, 20 Jul 2014 13:06:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140720170635.GF5017@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	linux-abi@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <871ttg3u8h.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ttg3u8h.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 08:50:06AM -0700, Andi Kleen wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> >  
> >  #undef __NR_syscalls
> > -#define __NR_syscalls 277
> > +#define __NR_syscalls 278
> 
> You need to add the syscall to kernel/sys_ni.c too, otherwise it will be
> impossible to build without random device.

The random device is not optional; it is alaways guaranteed to be
present.  From drivers/char/Makefile:

obj-y			+= mem.o random.o

Cheers,

					- Ted
