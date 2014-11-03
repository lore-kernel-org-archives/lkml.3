Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaKCT5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:57:10 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:62160 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaKCT5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:57:07 -0500
MIME-Version: 1.0
In-Reply-To: <1415043615.2726.4.camel@sipsolutions.net>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
 <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com>
 <1414741273.3014.3.camel@jlt4.sipsolutions.net> <20141031193408.GA12953@wotan.suse.de>
 <1414786943.3014.37.camel@jlt4.sipsolutions.net> <CAB=NE6UVca47FyZv54pED3C_1go+-Ra_AbSwW1+=Gj5YWP0GHw@mail.gmail.com>
 <CAB=NE6U7-TE9Oe_aTvjr4Y1iGALMeRohmx-ekbzmRuzAbbqTTA@mail.gmail.com> <1415043615.2726.4.camel@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Mon, 3 Nov 2014 11:56:44 -0800
X-Google-Sender-Auth: QF6JM0524aC7TQgOi9-UpSmAnr0
Message-ID: <CAB=NE6XWWcmRb-3r28obFmChzW1mnynG0LkVDr2-y+QVpq=y9Q@mail.gmail.com>
Subject: Re: [RFC v2 1/4] backports: replace CPTCFG prefix for CONFIG_BACKPORT
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 11:40 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-11-03 at 11:30 -0800, Luis R. Rodriguez wrote:
>> On Fri, Oct 31, 2014 at 1:33 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> >> That also makes me think of something else - we currently use BACKPORT_
>> >> as a prefix for some of the other stuff under compat/Kconfig, and in
>> >> fact rename some things (like CONFIG_BACKPORT_AVERAGE) so maybe also
>> >> using CONFIG_BACKPORT_ here isn't a great idea? Might want to use
>> >> something else, say CONFIG_BPT_ or so.
>> >
>> > That's a good point, I take it that it does not matter which one we
>> > pick for each, so long as its different? If so I think CONFIG_BACKPORT
>> > is pretty clear for things we carry over like device drivers, but this
>> > is just subjective and so long as we pick something I think it'll be
>> > fine.
>>
>> Thought about this some more, the stuff under compat/ is just
>> backported through a slightly different strategy -- the Kconfig
>> copy-file stuff but yet its very similar to the copy-list mechanism,
>> where it ends up is different but I am not sure if it makes sense to
>> keep a different naming scheme for each backport strategy.
>
> Yes, but the stuff under compat/ is also treated specially by the
> scripting - config symbols there automatically replace the ones in the
> rest of the tree for example (see "config AVERAGE" for example, you get
> "depends on BACKPORT_AVERAGE" and some BUILD_PACKPORT_AVERAGE magic)

With my current code I end up with on a package (not integration):

config BACKPORT_BUILD_AVERAGE
        bool
        depends on !AVERAGE
        default y if BACKPORT_USERSEL_BUILD_ALL
        default y if BACKPORT_AVERAGE
        #h-file linux/average.h
        #c-file lib/average.c

config BACKPORT_AVERAGE
        bool


I do see I on the package with this on the Makfile though:


compat-$(CONFIG_BACKPORT_BACKPORT_BUILD_AVERAGE) += lib-average.o

Would it not suffice to just ensure we don't have BACKPORT_BACKPORT_
here and just BACKPORT_ once ?

  Luis
