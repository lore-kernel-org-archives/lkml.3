Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaDHP7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:59:21 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41345 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbaDHP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:59:19 -0400
MIME-Version: 1.0
In-Reply-To: <1396968207.30750.17.camel@sauron.fi.intel.com>
References: <20140408044407.GA13141@www.outflux.net>
	<20140408135729.GC2429@arch.cereza>
	<1396968207.30750.17.camel@sauron.fi.intel.com>
Date: Tue, 8 Apr 2014 08:59:19 -0700
X-Google-Sender-Auth: FBBqaCq6aCeKzRckFT6Akkbbwsg
Message-ID: <CAGXu5j+-1o9TmqLrq2ZPhoRvOmiv4Do5wvGkasxHb+Frm7hutA@mail.gmail.com>
Subject: Re: [PATCH] ubi: avoid workqueue format string leak
From: Kees Cook <keescook@chromium.org>
To: artem.bityutskiy@linux.intel.com
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux mtd <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 7:43 AM, Artem Bityutskiy
<artem.bityutskiy@linux.intel.com> wrote:
> On Tue, 2014-04-08 at 10:57 -0300, Ezequiel Garcia wrote:
>> Hello Kees,
>>
>> Thanks for the patch.
>>
>> On Apr 07, Kees Cook wrote:
>> > When building the name for the workqueue thread, make sure a format
>> > string cannot leak in from the disk name.
>> >
>>
>> Could you enlighten me and explain why you want to avoid the name leak?
>> Is it a security concern?
>>
>> I'd like to understad this better, so I can avoid making such mistakes
>> in the future.
>
> Well, the basics seem to be simple, attacker makes sure gd->disk_name
> contains a bunch of "%s" and other placeholders, and this leads
> "workqueue_alloc()" to read kernel memory and form the workqueue name.

Right. I don't think there is an actual exploitable vulnerability
here, but it's a best-practice to not pass variable strings in as a
potential format string.

> I did not think it through further, though, but that was enough for me
> to apply the patch right away. But yeah, curios parts are:
>
> 1. How attacker could end up with a crafted "gd->disk_name"

At present, the only way I know how to set that is via some special
controls in md, but I assume that would not work via ubi.

> 2. How attacker gets the workqueue name then, I guess there is a sysfs
> file or something, but I do not know off the top of my head.

This I haven't checked, but if there isn't a way to do it now, we can
at least avoid a nasty surprise in the future if one is created. :)

> Yeah, I am interested to get educated on this a too.

Thanks for pulling the fix!

-Kees

-- 
Kees Cook
Chrome OS Security
