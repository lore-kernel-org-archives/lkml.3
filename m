Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3JBFNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:13:30 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35610 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3JBFNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:13:24 -0400
Date: Wed, 2 Oct 2013 07:13:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: spinlock contention of files->file_lock
Message-ID: <20131002051319.GB27982@gmail.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
 <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
 <1380663718.19002.49.camel@edumazet-glaptop.roam.corp.google.com>
 <20131001220453.GY13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001220453.GY13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Oct 01, 2013 at 02:41:58PM -0700, Eric Dumazet wrote:
> > Maybe I am missing something obvious ?
> 
> Yes.  do_execve_common() starts with unshare_files(); there can be
> no other thread capable of modifying that descriptor table.

Btw., might the Android Binder:

  drivers/staging/android/binder.c:       struct files_struct *files = proc->files;
...
  drivers/staging/android/binder.c:               __fd_install(proc->files, fd, file);
...
  drivers/staging/android/binder.c:       retval = __close_fd(proc->files, fd);

violate that assumption?

Thanks,

	Ingo
