Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaBMVmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:42:51 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:13509 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaBMVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:42:48 -0500
X-IronPort-AV: E=Sophos;i="4.95,840,1384329600"; 
   d="scan'208";a="14566915"
Message-ID: <52FD3C50.6010209@broadcom.com>
Date: Thu, 13 Feb 2014 22:42:40 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>	<20140211072738.GA24232@gmail.com>	<20140211234534.6bc34e57@gandalf.local.home>	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>	<20140213102817.4bfd5eac@gandalf.local.home>	<y0mlhxfnhx8.fsf@fche.csb> <20140213104429.478b56e8@gandalf.local.home>
In-Reply-To: <20140213104429.478b56e8@gandalf.local.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 04:44 PM, Steven Rostedt wrote:
> On Thu, 13 Feb 2014 10:36:35 -0500
> fche@redhat.com (Frank Ch. Eigler) wrote:
> 
>>
>> rostedt wrote:
>>
>>> [...]
>>> Oh! You are saying that if the kernel only *supports* signed modules,
>>> and you load a module that is not signed, it will taint the kernel?
>>
>> Yes: this is the default for several distros.
>>
> 
> Rusty, Ingo,
> 
> This looks like a bug to me, as it can affect even in-tree kernel
> modules. If you have a kernel that supports signed modules, and you
> modify a module, recompile it, apply it, since it is no longer signed,
> then it sounds like we just tainted it. Worse yet, we just disabled any
> tracepoints on that module, which means it is even harder to debug that
> module (if that's the reason you recompiled it in the first place).

When I stumbled upon this issue a while ago on Fedora 19 I built my
kernel rpm packages which generates a signature key (.priv and .x509),
which I kept safe with the kernel headers. When building recompiling
modules I refer to it with MODSECKEY and MODPUBKEY, ie.

$ make MODSECKEY=bla MODPUBKEY=duh \
	M=drivers/net/wireless/brcm80211  modules

Or sign it manually using the sign-file perl script:

mod_sign_cmd = perl $(srctree)/scripts/sign-file \
	$(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)

Of course I could disable signed modules while building a new kernel,
but I was in it for the ride (I had better ones) ;-)

Gr. AvS

> -- Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

