Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaFQDfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:35:22 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:47037 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaFQDfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <1402975557.2797.8.camel@joe-AO725>
References: <1401728316.5770.9.camel@joe-AO725>
	<1402961300-17985-1-git-send-email-anish@chelsio.com>
	<1402964898.11561.2.camel@joe-AO725>
	<539F8F62.4000805@chelsio.com>
	<1402970429.2797.3.camel@joe-AO725>
	<CAK5sBcGurbiFvd7s5sd=HtRkdw0SydWVw3g7_zKBt_eJC+NGUw@mail.gmail.com>
	<1402975557.2797.8.camel@joe-AO725>
Date: Tue, 17 Jun 2014 09:05:19 +0530
Message-ID: <CAK5sBcFS23cymDxDsMe8e+CZPtFM=ugFSSgG-rFmjHzuvK9WKA@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Warn on unnecessary void function return statements
From: Sachin Kamat <spk.linux@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Anish Bhatt <anish@chelsio.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 8:55 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-06-17 at 08:46 +0530, Sachin Kamat wrote:
>> On Tue, Jun 17, 2014 at 7:30 AM, Joe Perches <joe@perches.com> wrote:
>> > On Mon, 2014-06-16 at 17:44 -0700, Anish Bhatt wrote:
>> >> My code has multiple exit lables:
>> >> void function(void)
>> >> {
>> >>       ...
>> >>
>> >>       if (err1)
>> >>               goto exit1;
>> >>       ...
>> >>       if (err2)
>> >>               goto exit2;
>> >>
>> >>       ...
>> >>       return; /* Good return, no errors */
>> >> exit1:
>> >>       printk(err1);
>> >>       return;
>> >> exit2:
>> >>       printk(err2);
>> >> }
>> >>
>> >> The single tabbed return was required to prevent the good return & err1
>> >> messages cascading down. The extra exit label with a noop looks weird,
>> >> but is passing checkpatch.pl --strict, so I will go with that, thanks.
>> >> -Anish
>> >>
>> >
>> > Hmm, those return uses seem reasonable
>> > to me.
>> >
>> > Perhaps the test should warn only on
>> > this specific 3 line sequence:
>> >
>> > [any line but a label]
>> >         return;
>> > }
>> >
>> > Andrew?  Anyone else?  Opinions?
>>
>> It should warn only if the return is followed by a value like
>> return 0; or return -EERROR_CODE; etc. and not just 'return;'
>
> No.  The compiler gets to warn on those.
> checkpatch isn't a compiler.

Right. I misunderstood the context of the discussion.
Sorry for the noise.

-- 
Regards,
Sachin.
