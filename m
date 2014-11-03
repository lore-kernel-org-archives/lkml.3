Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaKCUWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:22:20 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:59952 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaKCUWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:22:16 -0500
MIME-Version: 1.0
In-Reply-To: <1415046029.2726.6.camel@sipsolutions.net>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
 <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com>
 <1414741273.3014.3.camel@jlt4.sipsolutions.net> <20141031193408.GA12953@wotan.suse.de>
 <1414786943.3014.37.camel@jlt4.sipsolutions.net> <CAB=NE6UVca47FyZv54pED3C_1go+-Ra_AbSwW1+=Gj5YWP0GHw@mail.gmail.com>
 <CAB=NE6U7-TE9Oe_aTvjr4Y1iGALMeRohmx-ekbzmRuzAbbqTTA@mail.gmail.com>
 <1415043615.2726.4.camel@sipsolutions.net> <CAB=NE6XWWcmRb-3r28obFmChzW1mnynG0LkVDr2-y+QVpq=y9Q@mail.gmail.com>
 <1415046029.2726.6.camel@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Mon, 3 Nov 2014 12:21:54 -0800
X-Google-Sender-Auth: EPp8pcDlOUYkXUuIlsCnkNxsLeU
Message-ID: <CAB=NE6V1JViQyKRdEnaK=Ek4HC4qt_mdyrtk8kT_CG=YkxS+6w@mail.gmail.com>
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

On Mon, Nov 3, 2014 at 12:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-11-03 at 11:56 -0800, Luis R. Rodriguez wrote:
>
>> With my current code I end up with on a package (not integration):
>>
>> config BACKPORT_BUILD_AVERAGE
>>         bool
>>         depends on !AVERAGE
>>         default y if BACKPORT_USERSEL_BUILD_ALL
>>         default y if BACKPORT_AVERAGE
>>         #h-file linux/average.h
>>         #c-file lib/average.c
>>
>> config BACKPORT_AVERAGE
>>         bool
>>
>>
>> I do see I on the package with this on the Makfile though:
>>
>>
>> compat-$(CONFIG_BACKPORT_BACKPORT_BUILD_AVERAGE) += lib-average.o
>>
>> Would it not suffice to just ensure we don't have BACKPORT_BACKPORT_
>> here and just BACKPORT_ once ?
>
> The BACKPORT_BACKPORT_ is actually correct ... but it'll be really hard
> to make sense of :-)

OK I'll prefix the stuff we copy over with something else then, BPAUTO.

 Luis
