Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaFKLGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:06:39 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34047 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbaFKLGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:06:37 -0400
Date: Wed, 11 Jun 2014 07:06:32 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>
Subject: Re: [PATCH][RFC] err.h: silence sparse warning: dereference of
 noderef expression
Message-ID: <20140611070632.639e07ce@f20.localdomain>
In-Reply-To: <20140611052040.GM5500@mwanda>
References: <1402436329-24750-1-git-send-email-jlayton@poochiereds.net>
	<20140611052040.GM5500@mwanda>
X-Mailer: Claws Mail 3.10.0 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 08:45:18 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Tue, Jun 10, 2014 at 05:38:49PM -0400, Jeff Layton wrote:
> > From: Jeff Layton <jlayton@primarydata.com>
> > 
> > Lately, when I do a make with C=1, I get *tons* of these warnings:
> > 
> >     include/linux/err.h:35:16: warning: dereference of noderef expression
> >     include/linux/err.h:30:23: warning: dereference of noderef expression
> 
> Which version of Sparse, which version of the kernel and which .c file
> can I compile to reproduce this?
> 
> I built fs/cifs/ and I didn't see the sparse warning.
> 
> regards,
> dan carpenter
> 

$ rpm -q sparse
sparse-0.5.0-1.fc20.x86_64

I see it all over the tree, but an easy example is fs/locks.c:

$ make fs/locks.o C=1
make[1]: Nothing to be done for `all'.
make[1]: Nothing to be done for `relocs'.
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   fs/locks.c
include/linux/err.h:35:16: warning: dereference of noderef expression
include/linux/err.h:30:23: warning: dereference of noderef expression
include/linux/err.h:35:16: warning: dereference of noderef expression
include/linux/err.h:30:23: warning: dereference of noderef expression
  CC      fs/locks.o

It has two IS_ERR calls and two PTR_ERR calls, and each generates the
warning.

-- 
Jeff Layton <jlayton@poochiereds.net>
