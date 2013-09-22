Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3IVT7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 15:59:44 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752967Ab3IVT7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 15:59:42 -0400
Message-ID: <523F4C2A.3050207@nod.at>
Date: Sun, 22 Sep 2013 21:59:38 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Markus Elfring <Markus.Elfring@web.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Would an "information module" be useful?
References: <l1n80j$ofi$1@ger.gmane.org> <CAFLxGvweL_O16TwvERsMSwf1UPa5BFwSyFNNRu6Z1CD4ExZXSg@mail.gmail.com> <523F4A55.3090106@web.de>
In-Reply-To: <523F4A55.3090106@web.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

Am 22.09.2013 21:51, schrieb Markus Elfring:
>> Why can't you use /proc/cmdline?
> 
> Thanks for your suggestion.
> 
> 
>> (see parse_proc_cmdline())
> 
> How do you think about reasons like the following?
> 
> 1. I would prefer to avoid the repeated parsing of boot command-line parameters
> because the reuse of the kernel infrastructure should be better here.
> 
> 2. Documentation
>    Module parameters can also be explained in the source files.
>    http://tldp.org/LDP/lkmpg/2.6/html/x323.html
> 
> 3. Is a corresponding check for specific data types "nice"?
>    http://www.linux-magazin.de/Ausgaben/2004/05/Kern-Technik/%28offset%29/2
> 

Yeah, but there is one big issue.
You can do all parsing in user space too.
There is no need to add code to the kernel...
The kernel itself also simply parses the cmdline[] variable.

> 
> How are the chances to clarify this implementation detail: In which subdirectory
> should a kernel module be stored if it will not manage any hardware?

Of course you can hack such a module for your own usage. But I'm sure it will not get merged.
All you need is a dummy module with a few module_param()s. You can find them later in
/sys/module/<name of your module>/parameters/.

drivers/misc/ is a nice place do dump such things. :-)

Thanks,
//richard
