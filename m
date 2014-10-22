Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaJVEgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 00:36:18 -0400
Received: from ozlabs.org ([103.22.144.67]:52732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaJVEgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 00:36:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: Re: [RFC PATCH 5/5] module: Remove stop_machine from module unloading
In-Reply-To: <544636A5.1080204@hitachi.com>
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal> <20140825105555.21089.99958.stgit@kbuild-fedora.novalocal> <87ppdweg5g.fsf@rustcorp.com.au> <544636A5.1080204@hitachi.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Oct 2014 14:55:03 +1030
Message-ID: <87egu091eo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>>> +/*
>>> + * MODULE_REF_BASE must be 1, since we use atomic_inc_not_zero() for
>>> + * recovering refcnt (see try_release_module_ref() ).
>>> + */
>>> +#define MODULE_REF_BASE	1
>> 
>> True, but we could use atomic_add_unless() instead, and make this
>> completely generic, right?
>
> Would you mean just replacing atomic_inc_not_zero() with atomic_add_unless()?

Yes.

Cheers,
Rusty.
