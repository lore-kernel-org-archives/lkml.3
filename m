Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaHECoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:44:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:12174 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaHECoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:44:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,802,1400050800"; 
   d="scan'208";a="583439760"
Message-ID: <1407206650.10148.28.camel@rzhang1-toshiba>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
From: Zhang Rui <rui.zhang@intel.com>
To: markus@gutschke.com
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 05 Aug 2014 10:44:10 +0800
In-Reply-To: <CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	 <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com>
	 <1405587482.28592.64.camel@rzhang1-toshiba>
	 <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
	 <1405988531.2455.14.camel@rzhang1-toshiba>
	 <CALGCz1okgr4K9S+6NfohM1Y3LregQLEKaj7FuON0xkk7xX1Jhg@mail.gmail.com>
	 <20140804141613.GB24261@amd.pavel.ucw.cz>
	 <CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Markus,

On Mon, 2014-08-04 at 09:06 -0700, Markus Gutschke wrote:
> Thanks for checking in. And no, I have not heard from Zhang since my
> last e-mail. I suspect he is still working on finding a solution.

Yes, I was trying to find out what differences commit
b04c58b1ed26317bfb4b33d3a2d16377fc6acd0f brings, and why it breaks
suspend. But so far, I didn't make any progress. Thus I do need your
help to do more test.

>  But
> you are of course right, reverting the patch in the meantime might be
> a good idea. I would love to be able to suspend my laptop again. But I
> defer to Zhang for the final decision. As long as it gets fixed
> eventually, I can personally live with a few weeks of delay while
> things get worked out. And of course, as offered before, I'll run
> whatever tests Zhang asks me to do.
> 
Great. Thanks for your help, please
1. make sure your kernel is built with CONFIG_PM_DEBUG and
CONFIG_PM_TRACE_RTC set.
2. in b04c58b1ed26317bfb4b33d3a2d16377fc6acd0f kernel, try "echo devices
> /sys/power/pm_test && echo mem > /sys/power/states", and wait for 10
seconds and see if the system can be resumed automatically.
3. if the test fails, please try a normal suspend, and reboot the kernel
ASAP after the hang, better in one minute, and then attach the dmesg
output after boot. Hopefully, we can find out which driver breaks your
machine by the suspend/resume trace feature. 

thanks,
rui

> Markus
> 
> On Mon, Aug 4, 2014 at 7:16 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Sat 2014-07-26 08:52:34, Markus Gutschke wrote:
> >> Sorry for the delay. Remotely debugging kernels over a shared and
> >> flaky 1MBps terrestrial wireless connection is quite a new experience
> >> to me.
> >>
> >> In any case, I was able to collect all the data that you asked for. I
> >> then used "pm-suspend" to put the machine to sleep and asked a helper
> >> to physically press the power button to wake the computer back up. My
> >> helper told me that it crashed just as before, and they had to
> >> power-cycle the machine to bring it back to life.
> >>
> >> Please let me know, what other data I can get for you. And thank you
> >> very much for putting up with my slow turn-around. I should have much
> >> better response time again in about two to three weeks when I return
> >> to civilization.
> >
> > Was this solved, somehow?
> >
> > If not, can we revert the patch that causes it?
> >                                                                 Pavel
> >
> > --
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


