Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3ILHbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:31:15 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45619 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3ILHbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <5231836102000078000F29AD@nat28.tlf.novell.com>
References: <20130911193040.GA16688@www.outflux.net>
	<1378929961.4714.21.camel@joe-AO722>
	<CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
	<5231836102000078000F29AD@nat28.tlf.novell.com>
Date: Thu, 12 Sep 2013 00:31:12 -0700
X-Google-Sender-Auth: rQ7igQJ8Wg3gxITfqQ6xgnVAzkc
Message-ID: <CAGXu5jKMqnL_V9NP8kUHqLp1jZDNM3VySEEnPHSFMH_N8Np7HA@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Kees Cook <keescook@chromium.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
        Eldad Zack <eldad@fogrefinery.com>, George Spelvin <linux@horizon.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:03 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 11.09.13 at 22:18, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Sep 11, 2013 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
>>> On Wed, 2013-09-11 at 12:30 -0700, Kees Cook wrote:
>>>> The %n format is not ignored, so remove the incorrect comment about it.
>>>
>>> I think it may be better to reimplement the ignoring.
>>
>> Yeah, just had a quick look, and scanf doesn't use this code at all.
>> I'd much rather remove %n again instead.
>
> Why would you want to artificially make the function diverge
> from the spec? People shouldn't be caught by surprises if at all
> possible, and one can certainly not expect people to go look at
> the comment before the function implementation to find out
> what basic (standard) features _do not_ work (one can expect
> so when trying to find out about _extensions_).

The spec, in this case, is considered harmful. Without %n, format
string flaws are at worst "just" information leaks. Being able to
downgrade potential arbitrary memory writing vulnerabilities into info
leak vulnerabilities would be a very nice improvement. As another
point of reference, even Android's libc replacement, bionic, doesn't
implement %n for the very same reasons.

Since there are so few users of %n in the kernel, it seems that this
goal is not totally outside the realm of possibility in the
short-term. The inclusion of the WARN_ON() was suggested for the very
reason of helping a potential user of %n to notice that it's not
supported.

-Kees

-- 
Kees Cook
Chrome OS Security
