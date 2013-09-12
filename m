Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3ILHvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:51:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42770 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3ILHvX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Thu, 12 Sep 2013 03:51:23 -0400
Message-Id: <52318E9802000078000F29FC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 12 Sep 2013 08:51:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kees Cook" <keescook@chromium.org>
Cc: "David Miller" <davem@davemloft.net>, "Eldad Zack" <eldad@fogrefinery.com>,
        "George Spelvin" <linux@horizon.com>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Joe Perches" <joe@perches.com>, "Jiri Kosina" <jkosina@suse.cz>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
References: <20130911193040.GA16688@www.outflux.net>
 <1378929961.4714.21.camel@joe-AO722>
 <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
 <5231836102000078000F29AD@nat28.tlf.novell.com>
 <CAGXu5jKMqnL_V9NP8kUHqLp1jZDNM3VySEEnPHSFMH_N8Np7HA@mail.gmail.com>
In-Reply-To: <CAGXu5jKMqnL_V9NP8kUHqLp1jZDNM3VySEEnPHSFMH_N8Np7HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.09.13 at 09:31, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Sep 12, 2013 at 12:03 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>>> On 11.09.13 at 22:18, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Sep 11, 2013 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
>>>> On Wed, 2013-09-11 at 12:30 -0700, Kees Cook wrote:
>>>>> The %n format is not ignored, so remove the incorrect comment about it.
>>>>
>>>> I think it may be better to reimplement the ignoring.
>>>
>>> Yeah, just had a quick look, and scanf doesn't use this code at all.
>>> I'd much rather remove %n again instead.
>>
>> Why would you want to artificially make the function diverge
>> from the spec? People shouldn't be caught by surprises if at all
>> possible, and one can certainly not expect people to go look at
>> the comment before the function implementation to find out
>> what basic (standard) features _do not_ work (one can expect
>> so when trying to find out about _extensions_).
> 
> The spec, in this case, is considered harmful. Without %n, format
> string flaws are at worst "just" information leaks. Being able to
> downgrade potential arbitrary memory writing vulnerabilities into info
> leak vulnerabilities would be a very nice improvement. As another
> point of reference, even Android's libc replacement, bionic, doesn't
> implement %n for the very same reasons.

Pretty strange argumentation: You disallow people knowing what
they do using this just to keep people not knowing what they do
from making mistakes? That may make sense in script languages,
but not in C (not to speak of in the kernel). In the end this seems
like enforcing a Google policy on everyone. But sure - if Linus is
willing to merge this, my objection likely doesn't count much.

Jan

