Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaIAJOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:14:48 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47236 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752129AbaIAJOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:14:46 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Shilpa Bhat'" <shilpa.bhat@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH v2] cpufreq: powernv: Set the cpus to nominal frequency
 during reboot/kexec
Thread-Topic: [PATCH v2] cpufreq: powernv: Set the cpus to nominal frequency
 during reboot/kexec
Thread-Index: AQHPxaQPxbooF0QdhUi7t4xjUtVeYJvr/BDw
Date: Mon, 1 Sep 2014 09:12:43 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174849AD@AcuExch.aculab.com>
References: <1409234816-10802-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <CAKohpokbYkL=cYQ+9-59vPhBmbAWqhrEz7RBPj5-edDB25DPgw@mail.gmail.com>
 <1409548719.13507.13.camel@localhost.localdomain>
In-Reply-To: <1409548719.13507.13.camel@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s819Er0n004136

From: Shilpa Bhat
> Hi Viresh,
> On Fri, 2014-08-29 at 05:33 +0530, Viresh Kumar wrote:
> > On 28 August 2014 19:36, Shilpasri G Bhat
> > <shilpa.bhat@linux.vnet.ibm.com> wrote:
> > >
> > > Changes v1->v2:
> > > Invoke .target() driver callback to set the cpus to nominal frequency
> > > in reboot notifier, instead of calling cpufreq_suspend() as suggested
> > > by Viresh Kumar.
> > > Modified the commit message.
> >
> > This changelog will get commited, is this what you want?
> 
> > > +       if (unlikely(rebooting) && new_index != get_nominal_index())
> > > +               return -EBUSY;
> >
> > Have you placed the unlikely only around 'rebooting' intentionally or
> > should it cover whole if statement?
> >
> 
> Yes unlikely() should cover the whole if statement...

Actually it probably shouldn't.
You need to look at the generated code with each different set of 'unlikely()'
to see how gcc processes them.
In this case, if 'rebooting' is false you want to 'fall through' on a statically
predicted 'not taken' branch. You don't ever care about the second clause.
With an 'unlikely' covering the entire statement gcc could easily add a
forwards conditional branch (that will be mis-predicted) for the 'rebooting' test.

(Yes, I spent a lot of time getting gcc to generate branches that were
correctly statically predicted for some code where every cycle mattered.)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
