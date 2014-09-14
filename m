Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaINS7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 14:59:30 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:42536 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaINS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 14:59:28 -0400
X-Yandex-Uniq: 610baf76-3765-4efb-83cd-d0a59b5d555f
Authentication-Results: smtp8.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5415E54D.1030908@yandex.ru>
Date: Sun, 14 Sep 2014 22:58:21 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, ktkhai@parallels.com,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to /proc/modules
References: <20140914100545.3745.23394.stgit@localhost>	<20140914153832.GC4064@kroah.com>	<20140914172709.GA1569@redhat.com>	<5415D6ED.30508@yandex.ru> <CAFLxGvyW8CWxkN=k5DE3OQ7HYTTMysOVttnrZGf7FTp53Z9Now@mail.gmail.com>
In-Reply-To: <CAFLxGvyW8CWxkN=k5DE3OQ7HYTTMysOVttnrZGf7FTp53Z9Now@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2014 22:12, Richard Weinberger wrote:
> On Sun, Sep 14, 2014 at 7:57 PM, Kirill Tkhai <tkhai@yandex.ru> wrote:
>> On 14.09.2014 21:27, Oleg Nesterov wrote:
>>> On 09/14, Greg KH wrote:
>>>>
>>>> On Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
>>>>> This series implements a possibility to show the list of built-in drivers
>>>>> to userspace. The names of drivers will be the same as when they are modules.
>>>>
>>>> Have you looked at /sys/modules/ ?  Doesn't that show what you want
>>>> here?
>>>
>>> Well, /sys/module/ doesn't list the modules (drivers) compiled in. Say,
>>> /sys/module/kernel. And it can't help a user to figure out that, say, the
>>> loop driver is already "loaded" because CONFIG_BLK_DEV_LOOP=y.
>>>
>>>> Module names aren't "standardized", we change them at times when needed,
>>>> just like CONFIG_ names.
>>>
>>> OK, but still the name will be the same, in /proc/modules or /proc/builtin.
>>>
>>>> What is your end goal here?  As you say, config.gz is the real kernel
>>>> configuration, just having a list of modules built in isn't going to
>>>> help much in getting a working kernel config without it.
>>>
>>> Perhaps you are right... but otoh perhaps this can can be useful anyway.
>>> Again, a user can know about "insmod loop", but he can know nothing
>>> about CONFIG_ names.
>>>
>>> That said, I do not really understand 2/3. Not only I do not understand
>>> this kbuild magic, I am not sure I understand what /proc/built-in will
>>> actually show.
>>
>> It's a list of drivers, one driver per line:
> 
> Built-in modules or drivers? :-)
> 

It's for boolean CONFIG_XXX too. Some targets have names, not obj-y.
For example, acpi. I did not change them.
