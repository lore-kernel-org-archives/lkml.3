Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaFWRsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:48:09 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:47995 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440AbaFWRsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:48:07 -0400
Message-ID: <53A867DB.90604@free.fr>
Date: Mon, 23 Jun 2014 19:46:03 +0200
From: Martin Peres <martin.peres@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>, Greg KH <greg@kroah.com>
CC: kernel list <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
References: <20140621180201.GA4621@amd.pavel.ucw.cz> <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com> <20140621194538.GA4903@kroah.com> <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com> <20140623160727.GA19557@kroah.com> <CAKb7UvhEMg96YzGuA=rxRDrzBhKiVaYMczrAcm4hA_A4jXAW2w@mail.gmail.com> <20140623163600.GB20939@kroah.com> <CAKb7Uvgx_1mEPapJF3V5s8vUViGnRGCerkixwdTv_EpHhEozBg@mail.gmail.com>
In-Reply-To: <CAKb7Uvgx_1mEPapJF3V5s8vUViGnRGCerkixwdTv_EpHhEozBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/06/2014 18:40, Ilia Mirkin a écrit :
> On Mon, Jun 23, 2014 at 12:36 PM, Greg KH <greg@kroah.com> wrote:
>> On Mon, Jun 23, 2014 at 12:18:51PM -0400, Ilia Mirkin wrote:
>> A list of valid "values" that a file can be in is fine if you just then
>> write one value back to that file.  That's the one exception, but a
>> minor one given the huge number of sysfs files.  Other than that, if you
>
> Which is pretty much what the pstate file is. Would it make things
> better if we removed the descriptive info while leaving the pstate
> file in place?

This means we should also create a new sysfs file per performance level 
too, right? Is there another way for a driver to expose a list in sysfs?

Since NVIDIA gives different names to performance levels depending on 
the card family, we may need to abstract the name away in order to 
provide some consistency and make listing performance levels easier from 
a program (may it use readdir() or stat()).

Moving the file to debugfs would "fix" the one-value-per-file rule but 
it would also require users to mount debugfs at boot time in order to 
write the default configuration they want for PM instead of just 
changing /etc/sysctl.d/nouveau.conf... On the other hand, I'm not sure 
we can commit on having a stable ABI on the way we display clocks 
(unless people take them as a single value and do not try to parse them) 
as new hardware will alter the semantics of each clock domain, if not 
drop/split some of them!

Whatever we do, it doesn't look like we can find a nice solution that 
fits every use cases unless we write a userspace program to access this 
data, but this seems highly overkill...
