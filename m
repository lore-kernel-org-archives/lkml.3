Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaIXUvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:51:42 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:45379 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaIXUvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:51:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140924154142.GG5865@mwanda>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com> <20140924075206.GC5865@mwanda>
 <20140924143555.GJ28253@tassilo.jf.intel.com> <20140924154142.GG5865@mwanda>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Wed, 24 Sep 2014 22:51:14 +0200
Message-ID: <CAFo99gbGoyf6GEt4ST_Q_WfYe39j+ke7t7XL6QZBYvMesMNZQg@mail.gmail.com>
Subject: Re: [PATCH] lib: string.c: Added a funktion function strzcpy
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>, Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-24 17:41 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Sep 24, 2014 at 07:35:55AM -0700, Andi Kleen wrote:
>> On Wed, Sep 24, 2014 at 10:52:06AM +0300, Dan Carpenter wrote:
>> > On Tue, Sep 23, 2014 at 06:17:53PM -0700, Andi Kleen wrote:
>> > > On Wed, Sep 24, 2014 at 12:13:36AM +0200, Rickard Strandqvist wrote:
>> > > > Added a function strzcpy which works the same as strncpy,
>> > > > but guaranteed to produce the trailing null character.
>> > >
>> > > Do we really need the bizarre strncpy padding semantics for anything?
>> > > Why not just use strlcpy?
>> >
>> > We do need the padding in many places to prevent information leaks.
>>
>> Like where?
>>
>
> You're asking what would break if we switched every strncpy() to
> strlcpy() but it's not an easy question to answer.
>
> I've looked a lot at information leaks, but strings are still a blind
> spot for my Smatch.  My check only looks at normal variables, arrays.
> Eventually I hope to fix this, of course.
>
> I did a git search and Rickard has added some examples, but there were
> definitely other places that rely strncpy() padding before.
>
> regards,
> dan carpenter


Hi

If you want to see examples of this type of error, you can check the
patches I've done over the past two months.
So in linux-next

git log --patch-with-stat

And search for my email address.

And there is also an approximately 20 more patches I waited to see if
I will be able to use a potential strzcpy  :-)


Kind regards
Rickard Strandqvist
