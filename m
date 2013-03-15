Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3COFEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:04:09 -0400
Received: from ozlabs.org ([203.10.76.45]:53406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3COFEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:04:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH] Allow optional module parameters
In-Reply-To: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 15 Mar 2013 15:33:32 +1030
Message-ID: <87ehfhtftn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
> Current parameter behavior is odd.  Boot parameters that have values
> and don't match anything become environment variables, with no
> warning.  Boot parameters without values that don't match anything
> go into argv_init.  Everything goes into /proc/cmdline.
>
> The init_module and finit_module syscalls, however, are strict:
> parameters that don't match result in -ENOENT.
>
> kmod (and hence modprobe), when loading a module called foo, look in
> /proc/cmdline for foo.x or foo.x=y, strip off the foo., and pass the
> rest to init_module.
>
> The upshot is that booting with module.nonexistent_parameter=1 is
> okay if module is built in or missing entirely but prevents module
> from loading if it's an actual module.  Similarly, option module
> nonexistent_parameter=1 in /etc/modprobe.d prevents the module from
> loading the parameter goes away.  This means that removing module
> parameters unnecessarily breaks things.

Err, yes.  Don't remove module parameters, they're part of the API.  Do
you have a particular example?

> With this patch, module parameters can be made explicitly optional.
> This approach is IMO silly, but it's unlikely to break anything,
> since I doubt that anyone needs init parameters or init environment
> variables that end in a tilde.

It's silly for the removal problem: that should be handled in the
kernel.  How would the poor user know that the option is going away?
So how about we add a module_param_obsolete(name) macro?

If a parameter were introduced, and the user wanted to specify it *if*
it was supported, that might justify this approach rather than using
complex install commands.  But I don't believe that's common, is it?

Thanks,
Rusty.
