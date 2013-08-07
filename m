Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3HGA02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:26:28 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:41766 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab3HGA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqU=yyxomNTg9-2+bxMKP=e5_pdVT7bhB_CHhFzB-ac_mQ@mail.gmail.com>
References: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com>
 <325b19bb936d7ebae11edad86aac8f0931e8abd9.1375719828.git.luto@amacapital.net>
 <5200B1BD.7030307@gmail.com> <CAG-2HqXEj06JbUOWee=NfuRXxL75uRf=55FZcXRLHroDzYUthQ@mail.gmail.com>
 <CAG-2HqVvoQK8ggErGGinO9i8Pbu-O-X=eYFW445ce24dpt7HyA@mail.gmail.com>
 <20130806163158.GA23093@kadzban.is-a-geek.net> <CAG-2HqU=yyxomNTg9-2+bxMKP=e5_pdVT7bhB_CHhFzB-ac_mQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Aug 2013 17:26:03 -0700
Message-ID: <CALCETrU-CWuefE5XUpC=xFuCXaL56Cox95nL35Bm9jMi_B+6_A@mail.gmail.com>
Subject: Re: [systemd-devel] [PATCH] Change CONFIG_FW_LOADER_USER_HELPER to
 default n and don't select it
To: Tom Gundersen <teg@jklm.no>
Cc: Bryan Kadzban <bryan@kadzban.is-a-geek.net>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-hotplug@vger.kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 5:24 PM, Tom Gundersen <teg@jklm.no> wrote:
>
> On 6 Aug 2013 18:32, "Bryan Kadzban" <bryan@kadzban.is-a-geek.net> wrote:
>>
>> On Tue, Aug 06, 2013 at 11:17:17AM +0200, Tom Gundersen wrote:
>> > On Tue, Aug 6, 2013 at 11:11 AM, Tom Gundersen <teg@jklm.no> wrote:
>> > > On Tue, Aug 6, 2013 at 10:20 AM, Maarten Lankhorst
>> > > <m.b.lankhorst@gmail.com> wrote:
>> > >> Op 05-08-13 18:29, Andy Lutomirski schreef:
>> > >>> The systemd commit below can delay firmware loading by multiple
>> > >>> minutes if CONFIG_FW_LOADER_USER_HELPER=y.  Unfortunately no one
>> > >>> noticed that the systemd-udev change would break new kernels as well
>> > >>> as old kernels.
>> > >>>
>> > >>> Since the kernel apparently can't count on reasonable userspace
>> > >>> support, turn this thing off by default.
>> > >>>
>> > >>> commit a3bd8447be4ea2ce230eb8ae0e815c04d85fa15a
>> > >>> Author: Tom Gundersen <teg@jklm.no>
>> > >>> Date:   Mon Mar 18 15:12:18 2013 +0100
>> > >>>
>> > >>>     udev: make firmware loading optional and disable by default
>> > >>>
>> > >>>     Distros that whish to support old kernels should set
>> > >>>
>> > >>> --with-firmware-dirs="/usr/lib/firmware/updates:/usr/lib/firmware"
>> > >>>     to retain the old behaviour.
>> > >>>
>> > >> methinks this patch should be reverted then,
>> > >
>> > > Well, all the code is still there, so it can be enabled if anyone
>> > > wants it.
>> > >
>> > >> or a stub should be added to udev to always fail firmware loading so
>> > >> timeouts don't occur.
>> > >
>> > > I think the only use (if any) of a userspace firmware loader would be
>> > > for anyone who wants a custom one (i.e., not udev), so we shouldn't
>> > > just fail the loading from udev unconditionally.
>> > >
>> > > How about we just improve the udev documentation a bit, similar to
>> > > Andy's kernel patch?
>> >
>> > Sorry, I should first have checked. We already document this in the
>> > README:
>> >
>> > >        Userspace firmware loading is deprecated, will go away, and
>> > >        sometimes causes problems:
>> > >          CONFIG_FW_LOADER_USER_HELPER=n
>>
>> ...And this patch is making the kernel default to the correct behavior,
>> instead of the now-broken-by-udev behavior.
>>
>> I'm not sure I see the issue with it?  :-)
>
> Oh yeah this patch is totally the right thing to do, I was just arguing that
> there is nothing to be done on the udev side.
>
>> (Add me to the list of people that think udev is broken too, fwiw.  But
>> let's at least not leave *both* sides in a broken-by-default state.)
>
> Well I don't think it is too much to ask that the kernel and udev should be
> configured in a consistent way. Especially as thing still work even if you
> get it wrong, albeit with a delay.

Except that the current defaults are inconsistent and there is no
explanation anywhere in the logs when this is screwed up.

--Andy
