Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbaFWR4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:56:09 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:46486 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbaFWR4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:56:07 -0400
MIME-Version: 1.0
In-Reply-To: <53A867DB.90604@free.fr>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
	<CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
	<20140621194538.GA4903@kroah.com>
	<CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
	<20140623160727.GA19557@kroah.com>
	<CAKb7UvhEMg96YzGuA=rxRDrzBhKiVaYMczrAcm4hA_A4jXAW2w@mail.gmail.com>
	<20140623163600.GB20939@kroah.com>
	<CAKb7Uvgx_1mEPapJF3V5s8vUViGnRGCerkixwdTv_EpHhEozBg@mail.gmail.com>
	<53A867DB.90604@free.fr>
Date: Mon, 23 Jun 2014 13:56:06 -0400
X-Google-Sender-Auth: SDsJNkEW5Q879uBuFm2IaHaQ57c
Message-ID: <CAKb7UvjPc1XGY7tETaMtn2N3ySq01CB6dLubVOZgW+NR_gsYMw@mail.gmail.com>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Martin Peres <martin.peres@free.fr>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 1:46 PM, Martin Peres <martin.peres@free.fr> wrote:
> Le 23/06/2014 18:40, Ilia Mirkin a écrit :
>>
>> On Mon, Jun 23, 2014 at 12:36 PM, Greg KH <greg@kroah.com> wrote:
>>>
>>> On Mon, Jun 23, 2014 at 12:18:51PM -0400, Ilia Mirkin wrote:
>>> A list of valid "values" that a file can be in is fine if you just then
>>> write one value back to that file.  That's the one exception, but a
>>> minor one given the huge number of sysfs files.  Other than that, if you
>>
>>
>> Which is pretty much what the pstate file is. Would it make things
>> better if we removed the descriptive info while leaving the pstate
>> file in place?
>
>
> This means we should also create a new sysfs file per performance level too,
> right? Is there another way for a driver to expose a list in sysfs?
>
> Since NVIDIA gives different names to performance levels depending on the
> card family, we may need to abstract the name away in order to provide some
> consistency and make listing performance levels easier from a program (may
> it use readdir() or stat()).
>
> Moving the file to debugfs would "fix" the one-value-per-file rule but it
> would also require users to mount debugfs at boot time in order to write the
> default configuration they want for PM instead of just changing
> /etc/sysctl.d/nouveau.conf... On the other hand, I'm not sure we can commit
> on having a stable ABI on the way we display clocks (unless people take them
> as a single value and do not try to parse them) as new hardware will alter
> the semantics of each clock domain, if not drop/split some of them!
>
> Whatever we do, it doesn't look like we can find a nice solution that fits
> every use cases unless we write a userspace program to access this data, but
> this seems highly overkill...

I was thinking just having the list of level ids in the pstate file,
and then stick the current file into debugfs. That way people retain
the ability to see things, as well as use pstate directly for a
configured system.

  -ilia
