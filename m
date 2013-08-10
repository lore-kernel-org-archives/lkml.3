Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab3HJUtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 16:49:13 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:44303 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803Ab3HJUtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 16:49:12 -0400
Message-ID: <5206A74B.3000005@linuxtoys.org>
Date: Sat, 10 Aug 2013 13:49:15 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com> <5202B674.7060005@linuxtoys.org> <20130807213325.GB5373@kroah.com> <520569B2.4000704@linuxtoys.org> <20130809230150.GA23418@kroah.com> <52069DCA.6060706@linuxtoys.org> <CAFLxGvwp79uqxHVy7A+SYMUnCFtCbtq1K=YppBx9j+R1oVC7PA@mail.gmail.com>
In-Reply-To: <CAFLxGvwp79uqxHVy7A+SYMUnCFtCbtq1K=YppBx9j+R1oVC7PA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger wrote:
>> GOAL
>> The goal of this patch was to make it possible to configure
>> daemons using simple file IO.  The litmus test for this is
>> that commands like these should be possible
>>          cat < /var/daemons/wpa_supplicant/use_channel
>>          echo 5 >/var/daemons/wpa_supplicant/use_channel
>>
>> Yes, there are many other ways to configure a daemon but
>> none with the simplicity and grace of file IO.  For proof
>> of this I point to procfs and sysfs.

> /me read the whole thread and still does get why you can't use CUSE.
> ...or AF_UNIX.
Rightly or wrongly, my goal is pretty clear.  I want to be able
to use file IO to control a daemon.  AF_UNIX doesn't help.
CUSE/FUSE takes over main() and makes it very difficult to use
select() and file descriptors.  So it fails too for now.

> If you really have an use case which is not covered by CUSE,
> please fix CUSE.
Yeah, if I proceed from here then modifying the user space parts
of FUSE might be the best way to go.

Sorry that it took so long to get to the point that my goals
for the patch were clearly stated.  As I say, I'm an EE who
probably need more adult supervision.  :)

thanks
Bob Smith


