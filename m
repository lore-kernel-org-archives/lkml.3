Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741Ab3BNQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:58:25 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39360 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068Ab3BNQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:58:24 -0500
MIME-Version: 1.0
In-Reply-To: <201302141650.21144.arnd@arndb.de>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org>
	<201302141557.18308.arnd@arndb.de>
	<CAD6h2NS_eR7zJjwAuBJPRrCb9=-4r=y-QJt7Lvg5U+yBf-e=kw@mail.gmail.com>
	<201302141650.21144.arnd@arndb.de>
Date: Fri, 15 Feb 2013 00:58:23 +0800
Message-ID: <CAD6h2NTJ1DdJ4j=UxNqgYQ5T16OAJ1saK9BEaMo_5NduG4c_ng@mail.gmail.com>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
        hpa@linux.intel.com, Jim Cromie <jim.cromie@gmail.com>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2013 00:50, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 14 February 2013, Haojian Zhuang wrote:
>> On 14 February 2013 23:57, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thursday 14 February 2013, Haojian Zhuang wrote:
>> >> If you can change it into code in below, it could work. Otherwise, it
>> >> always fails.
>> >>         driver_deferred_probe_enable = true;
>> >>         driver_deferred_probe_trigger();
>> >> +      deferred_probe_work_func(NULL);
>> >>         return 0;
>> >>
>> >> Because deferred_probe_work_func() depends on that deferred_probe is added
>> >> into deferred_probe_active_list. If driver_deferred_probe_trigger() isn't called
>> >> first, the deferred uart probe can't be added into active list. So even you call
>> >> work_func at here, it doesn't help.
>> >>
>> >
>> > Would that not cause two instances of the work function to run at the same time?
>> > That sounds like a source for a lot of problems.
>> >
>> >         Arnd
>>
>> Two instances of the work function? I'm sorry that I don't
>> understanding your meaning.
>> Could you help explain your question?
>
> I mean you end up calling the work function directly, while it gets run as part
> of the work queue on a different CPU at the same time. I just noticed that
> there is actually locking in place in deferred_probe_work_func that prevents
> any actual bugs, but you are still adding extra overhead here.
>
> Maybe just add
>
>         flush_workqueue(deferred_wq);
>
> here?
>
>         Arnd

It's fine to me. Since both of them are flushing workqueue.

Tested-by: <haojian.zhuang@linaro.org>
