Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750845AbaKURfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:35:53 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34997 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaKURfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:35:52 -0500
Message-ID: <546F77F3.3050002@suse.cz>
Date: Fri, 21 Nov 2014 18:35:47 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>
CC: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz> <20141121164027.GB11339@cerebellum.variantweb.net>
In-Reply-To: <20141121164027.GB11339@cerebellum.variantweb.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014, 05:40 PM, Seth Jennings wrote:
>>> --- /dev/null
>>> +++ b/arch/x86/include/asm/livepatch.h
>>> @@ -0,0 +1,37 @@
...
>>> +#ifndef _ASM_X86_LIVEPATCH_H
>>> +#define _ASM_X86_LIVEPATCH_H
>>> +
>>> +#include <linux/module.h>
>>> +
>>> +#ifdef CONFIG_LIVE_PATCHING
>>> +extern int klp_write_module_reloc(struct module *mod, unsigned long type,
>>> +				  unsigned long loc, unsigned long value);
>>> +
>>> +#else
>>> +static int klp_write_module_reloc(struct module *mod, unsigned long type,
>>
>> static inline?
> 
> I think the practice is to let the compiler handle inline determination
> unless you are sure that the compiler isn't inlining something you think
> it should.

Although you are right, it is a correct C, gcc specs (6.39) suggests to
use 'static inline' on such functions. gcc then shall inline such functions.

And if you look around in the kernel, we use that combination almost
everywhere.

thanks,
-- 
js
suse labs
