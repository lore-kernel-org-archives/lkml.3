Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3CLWAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:00:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab3CLWA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:00:29 -0400
Date: Tue, 12 Mar 2013 15:00:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>, lucas.de.marchi@gmail.com,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/7] usermodehelper: Export _exec() and _setup()
 functions
Message-Id: <20130312150027.51fed974151929f755b51b54@linux-foundation.org>
In-Reply-To: <CAMOw1v7XHryg6pBm7bGCyFqW0WGzi67kbOEpb8TpztFDhUhezQ@mail.gmail.com>
References: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
	<1363049291-946-2-git-send-email-lucas.demarchi@profusion.mobi>
	<20130312133148.106946def5edb288aafdfb51@linux-foundation.org>
	<CAMOw1v7XHryg6pBm7bGCyFqW0WGzi67kbOEpb8TpztFDhUhezQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013 18:52:54 -0300 Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

> On Tue, Mar 12, 2013 at 5:31 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 11 Mar 2013 21:48:06 -0300 Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:
> >
> >> call_usermodehelper_setup() + call_usermodehelper_exec() need to be
> >> called instead of call_usermodehelper_fns() when the cleanup function
> >> needs to be called even when an ENOMEM error occurs. In this case using
> >> call_usermodehelper_fns() the user can't distinguish if the cleanup
> >> function was called or not.
> >
> > call_usermodehelper_exec() was exported to modules but
> > call_usermodehelper_setup() was not?
> >
> 
> That was a mistake. We need both functions exported. Should I send and
> updated patch or a fixup?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: usermodehelper-export-_exec-and-_setup-functions-fix

export call_usermodehelper_setup() to modules

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kmod.c~usermodehelper-export-_exec-and-_setup-functions-fix kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-export-_exec-and-_setup-functions-fix
+++ a/kernel/kmod.c
@@ -541,6 +541,7 @@ struct subprocess_info *call_usermodehel
   out:
 	return sub_info;
 }
+EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
  * call_usermodehelper_exec - start a usermode application
_

