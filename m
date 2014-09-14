Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaINR5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:57:10 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:59158 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaINR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:57:08 -0400
X-Yandex-Uniq: 3411e816-74a2-41df-ab68-464c0e324f19
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5415D6ED.30508@yandex.ru>
Date: Sun, 14 Sep 2014 21:57:01 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
CC: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        ebiederm@xmission.com, akpm@linux-foundation.org, ktkhai@parallels.com,
        sam@ravnborg.org
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to /proc/modules
References: <20140914100545.3745.23394.stgit@localhost> <20140914153832.GC4064@kroah.com> <20140914172709.GA1569@redhat.com>
In-Reply-To: <20140914172709.GA1569@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2014 21:27, Oleg Nesterov wrote:
> On 09/14, Greg KH wrote:
>>
>> On Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
>>> This series implements a possibility to show the list of built-in drivers
>>> to userspace. The names of drivers will be the same as when they are modules.
>>
>> Have you looked at /sys/modules/ ?  Doesn't that show what you want
>> here?
> 
> Well, /sys/module/ doesn't list the modules (drivers) compiled in. Say,
> /sys/module/kernel. And it can't help a user to figure out that, say, the
> loop driver is already "loaded" because CONFIG_BLK_DEV_LOOP=y.
> 
>> Module names aren't "standardized", we change them at times when needed,
>> just like CONFIG_ names.
> 
> OK, but still the name will be the same, in /proc/modules or /proc/builtin.
> 
>> What is your end goal here?  As you say, config.gz is the real kernel
>> configuration, just having a list of modules built in isn't going to
>> help much in getting a working kernel config without it.
> 
> Perhaps you are right... but otoh perhaps this can can be useful anyway.
> Again, a user can know about "insmod loop", but he can know nothing
> about CONFIG_ names.
> 
> That said, I do not really understand 2/3. Not only I do not understand
> this kbuild magic, I am not sure I understand what /proc/built-in will
> actually show.

It's a list of drivers, one driver per line:

loop
ipv4
ipv5
ipv6
ipv7
ipv8
etc ;)

> To me it would be better to change the "ifndef MODULE" version of
> module_init() to add KBUILD_MODNAME into __builtin_drivers_list[].
> 
> Yes, module_init() is overused. Say, why does kernel/kprobes.c use
> module_init() ? This looks confusing, this code can't be compiled as a
> module. And it seems that it has a lot more users which should have used
> __initcall() instead

Yeh, the realization may be different. I do not insist on additional
section. I'm happy listening to advices.
.
> In short, I dunno ;)

Thanks,
Kirill
