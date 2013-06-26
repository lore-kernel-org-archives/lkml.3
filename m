Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3FZRqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:46:52 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52769 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3FZRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:46:50 -0400
Message-ID: <51CB2907.4010100@gmail.com>
Date: Wed, 26 Jun 2013 13:46:47 -0400
From: Jason Baron <jasonbaron0@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Rupesh Gujare <rupesh.gujare@atmel.com>, devel@linuxdriverproject.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        shigekatsu.tateno@atmel.com, jim.cromie@gmail.com, trenn@suse.de
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>  <20130625170205.GA21328@kroah.com> <1372181390.1245.68.camel@joe-AO722>
In-Reply-To: <1372181390.1245.68.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 01:29 PM, Joe Perches wrote:
> On Tue, 2013-06-25 at 10:02 -0700, Greg KH wrote:
>> On Tue, Jun 25, 2013 at 05:30:02PM +0100, Rupesh Gujare wrote:
>>> convert all debug messages from printk to dev_dbg() & add kernel config to
>>> enable/disable these messages during compilation.
>> No, just use the built-in dynamic debug code in the kernel, no need to
>> provide any new macros or functions or most importantly, no new Kconfig
>> options.
> I think the Kconfig option is pretty poor too but a
> long needed extension to dev_dbg is to enable classes
> of messages by level or mask.
>
> There are many existing macros like
>
> #define module_dbg(level, fmt, ...)
> do {
> 	if (level >= some_module_var)
> 		debug_something(...);
> } while (0)
>
> and
>
> #define module_dbg(mask, fmt, ...)
> do {
> 	if (mask & some_module_var)
> 		debug_something(...)
> } while (0)
>
> It'd be nice to consolidate those in dev_dbg
>
> I'll get 'round to it one day if Jason doesn't.
>

Hi,

I've been a bit reluctant to add these 'flag' and 'level' to dynamic
debug b/c the debug statements can already be controlled individually,
and thus one could implement something pretty similar in userspace.
Also, it keeps things simpler.

That said, this has come up several times and might be a nice extension
for both the dynamic debug and non-dynamic debug case.

I think the interface could look something like:

pr_debug_level(&control_var, level, fmt, ...);
pr_debug_mask(&control_var, mask, fmt, ...);

and then you could do something like:

echo "grouping control_var level N +p" > /debugfs/dynamic_debug/control

or

echo "grouping control_var mask 0xN +p" > /debugfs/dynamic_debug/control

So we can think of the 'control_var' as 'grouping' debug statements
together. So it would provide a nice way of associating statements
together other than the existing: module, func, file, format, and line
selectors.

Thanks,

-Jason

























