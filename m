Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaHLQMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:12:18 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54007 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaHLQMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:12:16 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <1407831975.2339.52.camel@rzhang1-toshiba>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <1407206650.10148.28.camel@rzhang1-toshiba> <CALGCz1pSpzDVb8sQx=QFKjdR4fi566h42p2nRkFx+RXairbgFQ@mail.gmail.com>
 <3611647.fAl6g4h0i8@vostro.rjw.lan> <CALGCz1rdyqeK8c_Rtmu88umaZA-pV_2_Q7JcY-kFBwg+QRzArA@mail.gmail.com>
 <CALGCz1o3_h1AY+7=5KG-5tqb3giUN7eJdymCNeRKg=RkG+g2qw@mail.gmail.com> <1407831975.2339.52.camel@rzhang1-toshiba>
From: Markus Gutschke <markus@gutschke.com>
Date: Tue, 12 Aug 2014 09:11:55 -0700
X-Google-Sender-Auth: CTRj_AcLoZxj4uJPmjACTqL8qtU
Message-ID: <CALGCz1p8=gPBqf6z-YpRzSE=raNJmJw-OKCsLwne3raCr4Y-1g@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: Zhang Rui <rui.zhang@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I said earlier in this thread, echo'ing "devices" into "pm_test"
does not result in a crash; but doing so for "platform" does.

Markus

On Aug 12, 2014 1:26 AM, "Zhang Rui" <rui.zhang@intel.com> wrote:
>
> On Sat, 2014-08-09 at 03:14 -0700, Markus Gutschke wrote:
> > I am back and have physical access to the machine now.
> >
> great!
>
> > I re-ran the test just to be sure, and I can confirm that "platform"
> > does in fact result in a crash.
> >
> what about "devices"?
> I mean
>
> # echo devices > /sys/power/pm_test
>
> and see if that triggers the crash.
>
> > Furthermore, I ran the test that Rui asked for. I suspended, resumed,
> > and upon crashing power-cycled the machine ASAP. "dmesg" suggests that
> > the problem is with LNXSYBUS:00 That doesn't tell me much, but
> > hopefully it makes sense to you guys.
> >
> [    0.930093]   Magic number: 10:810:122
> [    0.930185] acpi LNXSYBUS:00: hash matches
>
> This looks weird, ACPI will do nothing for LNXSYBUS devices during
> resume.
> Rafael, any thought on this?
>
> thanks,
> rui
>
