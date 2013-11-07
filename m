Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3KGXvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:51:15 -0500
Received: from ozlabs.org ([203.10.76.45]:41435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3KGXvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:51:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] module.h: Remove unnecessary semicolon
In-Reply-To: <1383800991.7940.51.camel@joe-AO722>
References: <1383685095.4387.45.camel@joe-AO722> <87zjph55px.fsf@rustcorp.com.au> <1383800991.7940.51.camel@joe-AO722>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 08 Nov 2013 09:41:48 +1030
Message-ID: <877gcj6c3v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> On Thu, 2013-11-07 at 12:32 +1030, Rusty Russell wrote:
>> Joe Perches <joe@perches.com> writes:
>> > This semicolon isn't necessary, remove it.
>> >
>> > Signed-off-by: Joe Perches <joe@perches.com>
>> 
>> This is a terrible description.  Really bad.
>
> I'd've preferred no description.

Me too.

>> First, it just repeats the subject, with more words.
>
> Which others have demanded.

They're wrong.

>> Second, it gives me no indication that you've done a grep to make sure
>> noone is abusing the macro, so I can't apply it without doing that check
>> myself.
>
> That's a trust issue.
> I've done it.  It isn't necessary.

WTF?  Now you just said it's not necessary, I *know* I can't trust you.

> The other #define module_put_and_exit in a
> different #if #else already doesn't have one.

You didn't mention this, and even if you did, it's not sufficient.  Some
code only ever gets compiled as a module, so it'd never hit the
!CONFIG_MODULES case.

> Trust it or not, apply it or not.

Now I know when I receive a patch from you I have to check it carefully,
because you can't be bothered.

I've fixed your patch, you can find it below.

From: Joe Perches <joe@perches.com>
Subject: module.h: Remove unnecessary semicolon

[All 8 callers already have semicolons. -- RR]

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 15cd6b1b211e..46e548fd502a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -451,7 +451,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
-#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
+#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
 
 #ifdef CONFIG_MODULE_UNLOAD
 unsigned long module_refcount(struct module *mod);
