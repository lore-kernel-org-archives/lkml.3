Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaHLI0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:26:22 -0400
Received: from mga14.intel.com ([192.55.52.115]:12813 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaHLI0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:26:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="371256492"
Message-ID: <1407831975.2339.52.camel@rzhang1-toshiba>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
From: Zhang Rui <rui.zhang@intel.com>
To: markus@gutschke.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 12 Aug 2014 16:26:15 +0800
In-Reply-To: <CALGCz1o3_h1AY+7=5KG-5tqb3giUN7eJdymCNeRKg=RkG+g2qw@mail.gmail.com>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	 <1407206650.10148.28.camel@rzhang1-toshiba>
	 <CALGCz1pSpzDVb8sQx=QFKjdR4fi566h42p2nRkFx+RXairbgFQ@mail.gmail.com>
	 <3611647.fAl6g4h0i8@vostro.rjw.lan>
	 <CALGCz1rdyqeK8c_Rtmu88umaZA-pV_2_Q7JcY-kFBwg+QRzArA@mail.gmail.com>
	 <CALGCz1o3_h1AY+7=5KG-5tqb3giUN7eJdymCNeRKg=RkG+g2qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-09 at 03:14 -0700, Markus Gutschke wrote:
> I am back and have physical access to the machine now.
> 
great!

> I re-ran the test just to be sure, and I can confirm that "platform"
> does in fact result in a crash.
> 
what about "devices"?
I mean

# echo devices > /sys/power/pm_test

and see if that triggers the crash.

> Furthermore, I ran the test that Rui asked for. I suspended, resumed,
> and upon crashing power-cycled the machine ASAP. "dmesg" suggests that
> the problem is with LNXSYBUS:00 That doesn't tell me much, but
> hopefully it makes sense to you guys.
> 
[    0.930093]   Magic number: 10:810:122
[    0.930185] acpi LNXSYBUS:00: hash matches

This looks weird, ACPI will do nothing for LNXSYBUS devices during
resume.
Rafael, any thought on this?

thanks,
rui

