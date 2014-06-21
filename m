Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaFUTez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 15:34:55 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39713 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaFUTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 15:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140621185051.GA25094@amd.pavel.ucw.cz>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
	<CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
	<20140621185051.GA25094@amd.pavel.ucw.cz>
Date: Sat, 21 Jun 2014 15:34:54 -0400
X-Google-Sender-Auth: DdfwduFdDQnyloGfm_gti8l5mpo
Message-ID: <CAKb7UvjkdRvH=hNTe=7wTF53X1DsUJ4FhM2Kv-C1bjbsn+F=hA@mail.gmail.com>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>, Greg KH <greg@kroah.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 2:50 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sat 2014-06-21 14:22:59, Ilia Mirkin wrote:
>> On Sat, Jun 21, 2014 at 2:02 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> > AFAICT, pstate file will contain something like
>> >
>> > 07: core 100 MHz memory 123 MHz *
>> > 08: core 100-200 MHz memory 123 MHz
>> >
>> > ...which does not look exactly like one-value-per-file, and I'm pretty
>> > sure userspace will get it wrong if it tries to parse it. Plus, I
>> > don't see required documentation in Documentation/ABI.
> ...
>>
>> FTR, this file has been in place since 3.13, and there was a different
>> file before it (performance_levels), with a comparable format since
>> much earlier (definitely 3.8, probably earlier). I think it's meant
>> a
>
> According to the article, it is only starting to work now. I know
> articles can be wrong, but I don't have that hardware... Sorry if it
> is the case.

Commit 26fdd78cce3f51a49e1f2d3ad27ee893a28d220e introduced this particular one.
Commit 330c5988ee78045e6a731c3693251aaa5b0d14e3 had introduced the
former version, which was removed in 3.13, replaced with the new one.

>
>> lot more for people looking at it and echo'ing stuff to it to modify
>> the levels (where supported), than for programs parsing it. Perhaps
>> sysfs is the wrong place for this -- what is the right place? debugfs?
>
> debugfs would work, yes.
>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
