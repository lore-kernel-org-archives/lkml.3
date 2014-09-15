Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaIOLuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:50:19 -0400
Received: from forward1m.mail.yandex.net ([37.140.138.1]:54340 "EHLO
	forward1m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaIOLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:50:17 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "mmarek@suse.cz" <mmarek@suse.cz>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>,
        "sam@ravnborg.org" <sam@ravnborg.org>
In-Reply-To: <20140914185631.GB18506@kroah.com>
References: <20140914100545.3745.23394.stgit@localhost>
	 <20140914153832.GC4064@kroah.com>
	 <5415D10E.90809@yandex.ru>
	 <20140914173919.GA10059@kroah.com>
	 <5415D8FA.8040305@yandex.ru>
	 <20140914181353.GA12497@kroah.com>
	 <5415E00E.1000706@yandex.ru> <20140914185631.GB18506@kroah.com>
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to /proc/modules
MIME-Version: 1.0
Message-Id: <923151410781803@web9m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 15 Sep 2014 15:50:03 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



14.09.2014, 22:56, "Greg KH" <gregkh@linuxfoundation.org>:
> On Sun, Sep 14, 2014 at 10:35:58PM +0400, Kirill Tkhai wrote:
>> šOn 14.09.2014 22:13, Greg KH wrote:
>>> šOn Sun, Sep 14, 2014 at 10:05:46PM +0400, Kirill Tkhai wrote:
>>>> šOn 14.09.2014 21:39, Greg KH wrote:
>>>>> šOn Sun, Sep 14, 2014 at 09:31:58PM +0400, Kirill Tkhai wrote:
>>>>>> šOn 14.09.2014 19:38, Greg KH wrote:
>>>>>>> šOn Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
>>>>>>>> šThis series implements a possibility to show the list of built-in drivers
>>>>>>>> što userspace. The names of drivers will be the same as when they are modules.
>>>>>>> šHave you looked at /sys/modules/ ? šDoesn't that show what you want
>>>>>>> šhere?
>>>>>> šThere are only the drivers in "/sys/module" which have parameters.
>>>>>> šDrivers without parameters do not appear there.
>>>>> šAh, didn't realize that. šShould be easy to fix though, if you really
>>>>> šwanted to list the modules. šMuch better than a random proc file that
>>>>> šyou have to parse :)
>>>> šBut it looks like one file is better than many new directories.
>>> šWhy?
>> šIt's just an unification with /proc/modules. Why should we do any
>> šdifference between external and built-in modules? It's the same,
>> šit's similar, it's better to parse when they can be shown similar.
>
> /proc/modules is for loaded modules, and it includes lots of information
> that tools rely on. šIt is also a very old file, no new
> non-process-related proc/ files should be created anymore. šIt's been
> that way since sysfs was created (and one of the reasons for sysfs.)
>>> šNo, they want the functionality that a module provides, not the module
>>> šname, or some random configuation option.
>>>
>>> šIt seems like you are trying to solve a problem that isn't there. šWhat
>>> šprogram is broken right now that this new proc file (or sysfs directory)
>>> šwould fix?
>> šThe initial reason was I'm building custom kernels for more than 10
>> šyears (not so long, I agree), and every boot I see a big list of modules
>> šfrom distribution /etc/module, which can't be autoloaded. I prefer to
>> šbuild drivers in kernel. I tried to find is there a way for userspace to
>> šunderstand that a module are present, but there is no a way. So this is
>> ša reason.
>
> I don't understand, my distro doesn't have any modules listed in
> /etc/module that aren't autoloaded, perhaps you should work with your
> distro on that :)
>
> And how would these patches remove those config files?
>
> Again, focus on kernel functionality, not module names or config
> options, and you should be fine.

Ok, I have no objections anymore.

Thanks,
Kirill
