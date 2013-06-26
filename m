Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab3FZFKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:10:46 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33997 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3FZFKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <1372140227.28480.69.camel@kjgkr>
References: <1369533945-6955-1-git-send-email-linkinjeon@gmail.com>
	<1369619214.10521.25.camel@kjgkr>
	<CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
	<1369704867.10521.46.camel@kjgkr>
	<CAKYAXd-OO5niMiFv+ysStw=c-NQXT4AkTz3m7o1wTRZRd=WYFw@mail.gmail.com>
	<1372140227.28480.69.camel@kjgkr>
Date: Wed, 26 Jun 2013 14:10:42 +0900
Message-ID: <CAKYAXd-NEKCuEyoLwWHLrN165yq7EKRRcz9RknfdbR5EOO6cvQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: add sysfs support for controlling the gc_thread
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi Namjae,
>
> Sorry for the late reply.
>
> 2013-05-29 (수), 09:01 +0900, Namjae Jeon:
>> >> I have thought more after getting your reply.
>> >> f2fs_cleaner(a tentative name) is that provide the following several
>> >> options to control gc thread.
>> >> 1. start forground gc thread to clean all invalid blocks.
>> >> 2. stop number 1(fg) working.
>> >> 3. set new tunning parameter (min/max/no_gc).
>> >> 4. get status of current f2fs.
>> >> We will provide user level util in f2fs tools and sysfs at the same
>> >> time.
>> >> It is useful if the console level user/App user can change them
>> >> easily.
>
> I think we'd better support configurable min/max/no_gc times only.
> And I don't think users need to do foreground GCs explicitly, since
> foreground GCs should be done only when the file system suffers from the
> shortage of free space. The foreground GC is the most costly operation
> so that I'd like to avoid triggering it as much as possible even if
> users want to do.
>
> Otherwise, if users would like to move data, they can just adjust
> background GC times appropriately and then do sync if they really move
> data synchronously.
Hi Jaegeuk.

Agreed, we can provide only time update values to the user and leave
the user to work out the setting as per the environment.

>
>> >>
>> >> >
>> >> > Afterwards, it is worth to add some information to
>> >> > Document/filesystems/f2fs.txt.
>> >> Yes, It will be included in next series patches.
>> >> How do you think ? If you agree my suggestion, I will start to work
>> >> the above jobs.
>> Hi. Jaegeuk.
>> >
>> > As I described, basically I agreed that this kind of interfaces and
>> > user
>> > apps are definitely beneficial to the f2fs users.
>> >
>> > But wrt design and implementation of new interfaces, we'd better
>> > discuss
>> > how to use them in more detail and what information should be needed
>> > for
>> > user-made cleaner.
>> > After then, we'd better start to design the interfaces as well as user
>> > scenarios clearly.
>> Okay. I agree.
>>
>> >
>> > IMO, the following issues should be addressed.
>> > - how to know system idle time by users?
>> e.g. When playing PVR function, In case of DTV, App try to read data
>> from filesystem of usb device.
>> now that, user app will never access flash rw partition and don't need
>> to access there.
>> I think that we can cleverly use such time to avoid or make slowly
>> come in the possible performance regression later.
>
> Okay.
>
>>
>> > - any priority scheme for cleaning?
>> Could you plz tell me a little more detail ?
>
> I meant, as well as the GC times, user also gives a kind of status like:
> LONG_IDLE, SHORT_IDLE, something like that.
> Therefore, how about using this information to select a victim selection
> policy between cost-benefit and greedy algorithms?
currently we will provide the option of updating the time values from
the ‘sysfs’ interface, and the GC policy is selected by default from
GC thread based upon the gc type, BG or FG.
So, do you mean we should provide an option to select the default GC
policy for the user using ‘sysfs’ interface? Like, if the user sets
“LONG_IDLE” – we choose Cost Benefit and in case of SHORT_IDLE
“Greedy” ? Please elaborate more on this.

Thanks.
>
>>
