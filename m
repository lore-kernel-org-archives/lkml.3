Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaKRAzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:55:52 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60724 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaKRAzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3293F681@ORSMSX114.amr.corp.intel.com>
References: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic> <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic> <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic> <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F5DA@ORSMSX114.amr.corp.intel.com>
 <CALCETrU6x4yVQy57KGm-Rk==ZYNqHorytAs6WvgKNVoT+Dk9Uw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F64E@ORSMSX114.amr.corp.intel.com>
 <CALCETrWPzO1vz+Rcjs78B+wWWi4eu_g__-k9iCHH1G1Mc6af+A@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3293F681@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Nov 2014 16:55:27 -0800
Message-ID: <CALCETrXsxJ6eotRJG1tjPD8dkpAd6P2roDm+fj+Yqi36uh3WHA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 4:22 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> It could also be interesting to tweak mce_panic to not actually panic
>> the machine but to try to return and stop the test instead.  Then real
>> debugging could be possible :)
>
> The lost cpu is *really* lost.  Warm reset doesn't fix the machine, I usually
> have to do a full power cycle.

How is it even possible that I did that with a few lines of asm?

Could this be a hardware bug?  Is there some condition that causes #MC
delivery to wedge hard enough that even INIT/RESET stops working?  Or
possibly some CPU got stuck in SMM -- I have no idea what warm reset
does these days.

My initial attempts to test machine_check in KVM using IPIs are having
some issues, probably because I'm not acking the interrupt.  I can do
it once, but then it stops working.

Here's the patch to improve the timeout messages, but given the degree
of wedgedness, I can guess what it'll say:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/paranoid&id=e5cbd9d141bde651ecb20f0b65ad13bcef2468d0

--Andy

>
> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
