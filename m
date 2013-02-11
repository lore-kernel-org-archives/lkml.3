Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3BKKLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:11:45 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:47629 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3BKKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:11:44 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <2964781.rPUOipNRNb@vostro.rjw.lan>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<3938124.8eafYb16IB@vostro.rjw.lan>
	<20130210185504.GA17268@amd.pavel.ucw.cz>
	<2964781.rPUOipNRNb@vostro.rjw.lan>
Date: Mon, 11 Feb 2013 11:11:40 +0100
Message-ID: <CAJfpegtNUr+AJXZcKmLEGBYqu20DVFwzg-OvOk_nS3fBS3wd=Q@mail.gmail.com>
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
        Li Fei <fei.li@intel.com>, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 12:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, February 10, 2013 07:55:05 PM Pavel Machek wrote:

>> Well, from freezer you need:
>>
>> 1) user process frozen.
>>
>> 2) essential locks _not_ held so that block devices are still functional.
>>
>> > > > mmap... what is problem with mmap? For suspend, memory is powered, so
>> > > > you can permit people changing it.
>> > >
>> > > Suppose mmap is used to make the registers of some device available to user
>> > > space.  Yes, that can happen.
>>
>> "Don't do it, then". Yes, can happen, but hopefully is not too common
>> these days. [And... freezer doing 1) but not 2) would be enough to
>> handle that. Freezer doing 1) but not 2) would also be simpler...]
>
> Again, I'm not sure what you mean.
>
> Are you trying to say that it would be OK to freeze user space tasks in
> the D state?

I think that's what Pavel is saying.   Processes in D state sleeping
on non-device mutexes _are_ actually OK to freeze.  And that would
nicely solve the fuse freeze problem.  The only little detail is how
do we implement that...

Thanks,
Miklos
