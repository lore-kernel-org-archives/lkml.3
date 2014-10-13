Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaJMFQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:16:19 -0400
Received: from ozlabs.org ([103.22.144.67]:50479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaJMFQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:16:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules <linux-modules@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH 0/2] kmod: Support lockup option to make module un-removable
In-Reply-To: <CAKi4VAJH-oYuDrW1nvNrQ409D0ZQHxexuVwWq8arGRQwbU+ycA@mail.gmail.com>
References: <53FC52DA.9000303@hitachi.com> <20140826120442.8223.80618.stgit@kbuild-fedora.novalocal> <CAKi4VAJH-oYuDrW1nvNrQ409D0ZQHxexuVwWq8arGRQwbU+ycA@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Oct 2014 15:11:31 +1030
Message-ID: <87mw90eg3o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
> On Tue, Aug 26, 2014 at 9:04 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> Hi,
>>
>> Here is a pair of patches which adds --lockup option to
>> modprobe and libkmod.
>>
>> As I sent a series of patches which removes stop_machine()
>> from module removal: https://lkml.org/lkml/2014/8/25/142
>> it also adds lockup option which lock up the module in
>> the kernel and makes it un-removable.
>>
>> These patches enables us to use that option when loading
>> modules. Module lockup may be good for BIG SMP machines
>> since the kernel skips module refcounting if the module
>> is locked up :)
>>
>> Anyway, this is not needed if the lockup option is dropped
>> from the series. I send this for testing.
>
> Ok. I'm not sure it's clear... I'm waiting for feedback on the kernel
> patches in order to proceed with any review here. I'm not really
> convinced we want this option when loading a module.
>
> Rusty, what do you think?

I'm not convinced, I asked him to drop that patch.  If we have
significant performance issues, we'll have to do something smarter I
think anyway.

Cheers,
Rusty.
