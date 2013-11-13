Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3KMM6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:58:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab3KMM6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:58:03 -0500
References: <87fvr3h3b9.fsf@redhat.com> <20131111110701.GE22636@console-pimps.org> <87eh6nt8oo.fsf@redhat.com> <20131113112052.GJ22636@console-pimps.org>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many entries to nvram.
In-reply-to: <20131113112052.GJ22636@console-pimps.org>
Date: Wed, 13 Nov 2013 20:57:49 +0800
Message-ID: <878uws1msy.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


matt@console-pimps.org writes:

> On Mon, 11 Nov, at 08:38:31PM, Madper Xie wrote:
>> 
>> matt@console-pimps.org writes:
>> 
>> > On Mon, 11 Nov, at 02:15:22PM, Madper Xie wrote:
>> >> Howdy all,
>> >>   For now we ensure at least ~5kb free space. But my dell xps still
>> >>   become a brick after I add too many entries to my nvram. So maybe 5kb
>> >>   is not safe enough. and 5kb is just aginst Samsung's laptop.
>> >>   So should we enlarge EFI_MIN_RESERVE?
>> >
>
> OK, that's pretty conclusive. Thanks.
>
Ouch, Sorry. My mistake. Seems filling too much entries to nvram is not
the murderer...
For testing, I using following command to fill my nvram:
head -c20480 /dev/urandom | efibootmgr --quiet --create --append-binary-args - 

For occupy lots of nvram space, I run it many times. But when I try to
find the threshold, I find the real murderer is that command. I mean my
dell xps will bricked even if I just run the command once and have more
than 100kb free space...

So the murderer is the new added boot entry. I don't really know if it's
still a bug. And I apologize for my mistake. :-(
>  
> Have you been able to calculate the safe limit of NVRAM we need to
> reserve to avoid bricking your machine?
>
> I was interested in the DMI and other firmware strings from dmesg.


-- 
Best,
Madper Xie.
