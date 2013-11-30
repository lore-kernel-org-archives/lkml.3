Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3K3Mhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:37:42 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43058 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3K3Mhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:37:39 -0500
Message-ID: <5299DC0F.8020500@linux.com>
Date: Sat, 30 Nov 2013 13:37:35 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
References: <5298F900.9000208@linux.com> <20131129205628.GA20144@pd.tnic> <52999419.7040600@linux.com> <20131130111214.GB4323@pd.tnic> <5299CB38.8090808@linux.com> <20131130113229.GD4323@pd.tnic> <5299CFBB.4010209@linux.com> <20131130120827.GE4323@pd.tnic>
In-Reply-To: <20131130120827.GE4323@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-30 13:08 keltezéssel, Borislav Petkov írta:
> On Sat, Nov 30, 2013 at 12:44:59PM +0100, Levente Kurusa wrote:
>> Yes, I saw that as well. By that I meant that by doing some identifier
>> searches for device_register and then checking whether they call
>> put_device and have device_release registered. Also, I wonder if it
>> would be beneficial to have a generic device_release? Most of the
>> drivers I quickly swept through only call kfree(). Wouldn't a generic
>> one save some space?
> 
> Again, I wouldn't waste my time with hypothetical issues which never
> happen - there are many other, real issues which would rather need
> attention than what-if ones.
> 
> About saving space, that could be worth a try. If you can actually do
> that and show numbers to back it up, I'm sure people will have a look.
> And if you can't show any space savings, you'll still have learned stuff
> along the way.
> 
> But don't ask me about whether it makes sense to have a generic
> device_release - I'm no driver core and am not even trying. You could
> try to answer that question yourself, btw. :)

Okay, I will, thanks for the tips! :)
> 
>> Yes, I do that daily usually, but most of the time I only get some
>> uninitialized warnings. :-)
> 
> You can always try to understand why such warnings get issued and maybe
> even fix them if they're legit and the compiler is right. Also, look
> through git log for examples how others have fixed such warnings.
Yes, but there are some fake one where for example it doesn't recognize the
pci_read_config_byte call as something which could write to its args. So most
of them are fake warnings.

> 
> For example, sometimes changing code flow instead of simply shutting
> up the variable is much better. But in order to do that, you'd need to
> understand the code first and try to change it so that it doesn't break
> and the warning disappears. This is a very good way, IMO, to get to
> really understand what the code does and learn from others.
> 
> Another good exercise is trying to boot those random kernels with kvm -
> that can catch a bunch of issues too.
> 
> The save-space experiment you can also quickly test with kvm. By now you
> probably are catching my drift: testing kernels with kvm is awesome! :-)
I will try kvm, didn't use that before. :p

> 
>> What does that do? Never heard of it yet.
> 
> Well, you can have a look: scripts/Makefile.build

Ahh, now I see. Just didn't know where to look.

> 
> :-)
> 
> Good luck!
Thank you and for your time! :)

-- 
Regards,
Levente Kurusa
