Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaHFSho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:37:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54300 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756294AbaHFShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:37:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: markus@gutschke.com
Cc: Zhang Rui <rui.zhang@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
Date: Wed, 06 Aug 2014 20:56:21 +0200
Message-ID: <3611647.fAl6g4h0i8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALGCz1pSpzDVb8sQx=QFKjdR4fi566h42p2nRkFx+RXairbgFQ@mail.gmail.com>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com> <1407206650.10148.28.camel@rzhang1-toshiba> <CALGCz1pSpzDVb8sQx=QFKjdR4fi566h42p2nRkFx+RXairbgFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 06, 2014 11:31:07 AM Markus Gutschke wrote:
> I tried removing snd_hda_intel, but it didn't make any difference.
> 
> I then followed your instructions to turn on tracing, but I am more
> puzzled than I was before. The crash reliably happens, every time I
> suspend/resume without first having tracing turned on. But as soon as
> I enter "echo devices >/sys/power/pm_test" to enable tracing things
> change. Upon suspending, the machine now happily resumes itself again
> a few seconds later. No crash whatsoever.
> 
> Is this the expected behavior? Anything else you want me to do?

Yes, it is.  This means that suspending/resuming devices works correctly.

Please try

# echo platform > /sys/power/pm_test

and see if that triggers the crash.

If it doesn't, please try

# echo processors > /sys/power/pm_test

and if that doesn't trigger the crash,

# echo core > /sys/power/pm_test

(this is described in Documentation/power/basic-pm-debugging.txt in the kernel
source tree, BTW).

Rafael

