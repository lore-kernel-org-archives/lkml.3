Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3ARWYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:24:37 -0500
Received: from mout.web.de ([212.227.17.12]:57559 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3ARWYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:24:36 -0500
From: Thomas Schlichter <thomas.schlichter@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Andreas =?ISO-8859-1?Q?M=FCller?= <goo@stapelspeicher.org>,
        Julius Werner <jwerner@chromium.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: fix new C-states not functional after AC disconnect
Date: Fri, 18 Jan 2013 23:24:22 +0100
Message-ID: <2839069.gCgKnczmus@netbook>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc4-00001-gfc300f4-dirty; KDE/4.9.4; i686; ; )
In-Reply-To: <1755809.pcSThauESZ@netbook>
References: <2099093.cPXO6Nhn9v@netbook> <11530988.U26HMGnFLa@vostro.rjw.lan> <1755809.pcSThauESZ@netbook>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2155860.WxWkS2UFC8"
Content-Transfer-Encoding: 7Bit
X-Provags-ID: V02:K0:/MiXOxdVzbuy1D+cG4JnMt2a821e5GxJ5wp48rDbe41
 lo3o3K+or/gK4KY3o0NgUEtCijL6QCPF141JBVfEN1z6A74N+2
 S92iUXOgf914sA0QuLjZGECEzoNHbSwh0rLC6e/7+zIgEKjr1O
 rIBuX3o77w67P6l8GMw6DN7FTopdhwVlYS/7wbi3R7Bcr6xmpS
 65N1szI4N34UoEwQUOT1ZBksx77yb9T3Q51mkRCBeg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2155860.WxWkS2UFC8
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Dear Rafael,

I just recognized that I did not really describe the problem that my patch 
fixes. Therefore I attached the output of following command after disconnecting 
the AC power without and with my patch:

  grep -r "" /sys/devices/system/cpu/cpu0/cpuidle/

One can clearly see that some information is missing and the C3 state is not 
used.

Kind regards,
  Thomas

Am Freitag, 18. Januar 2013, 21:34:29 schrieb Thomas Schlichter:
> Dear Rafael,
> 
> thank you for applying Daniel's patch. I tested 3.8-rc4 and found that one
> patch ist still missing to fix the problem of not usable C-state after
> disconnect. I had it attached with my last e-mail as patch 1. For your
> conveniency, I have attached it here again.
> 
> With that patch the problem is fixed for me. So please consider applying
> this, too.
> 
> Kind regards,
>   Thomas
> 
> Am Sonntag, 13. Januar 2013, 21:04:45 schrieb Rafael J. Wysocki:
> > On Sunday, January 13, 2013 03:41:34 PM Daniel Lezcano wrote:
> > > On 01/13/2013 01:34 PM, Thomas Schlichter wrote:
> > > > Hi,
> > > > 
> > > > there is a long-standing regression about new C-states not working
> > > > after
> > > > disconnecting AC power from a laptop if the cpuidle driver "acpi-idle"
> > > > is
> > > > used. It was reported here:
> > > > 
> > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=42870  (March 5th
> > > > 2012)
> > > > [2] https://bugzilla.kernel.org/show_bug.cgi?id=43349  (June 7th 2012)
> > > > [3] https://lkml.org/lkml/2012/10/16/518   (October 19th 2012)
> > > > 
> > > > In [1] Andreas proposed a patch that initialized the missing
> > > > power_usage
> > > > values from within acpi_idle in the same way as cpuidle does.
> > > > In [2] I proposed a patch to use the power values provided by ACPI to
> > > > initialize the power_usage variables.
> > > > In [3] Julius proposed a patch to call the initialization function
> > > > set_power_states()  not only once, but always when the C-states
> > > > change.
> > > > 
> > > > Currently, Daniel Lezcano seems to be working on an intrusive change
> > > > of
> > > > not
> > > > using the power_usage value at all for choosing a C-state:
> > > > 
> > > > [4] https://lkml.org/lkml/2012/12/14/155
> > > > 
> > > > As I could not find any of these patches in any git trees to be merged
> > > > for
> > > > 3.8, I propose an other, least intrusive patch for the time being. It
> > > > is
> > > > attached an initializes _all_ power_usage values in the first place.
> > > > 
> > > > As this is a real power consumption regression since 3.2, I really ask
> > > > you to apply anything and push it to stable, too!
> > > 
> > > Rafael, is possible to apply the patch [1/2] I previously sent ?
> > > 
> > > https://patchwork.kernel.org/patch/1878691/
> > 
> > I need to talk about this with Len.  That should happen tomorrow if
> > everything goes well.
> > 
> > > So we get this bug fixed.
> > > 
> > > I will resend the patch [2/2] as soon as possible.
> > 
> > OK
> > 
> > Thanks,
> > Rafael
--nextPart2155860.WxWkS2UFC8
Content-Disposition: inline; filename="cpuidle_3.8-rc4.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="cpuidle_3.8-rc4.txt"

/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc:ACPI HLT
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1
/sys/devices/system/cpu/cpu0/cpuidle/state1/time:147579
/sys/devices/system/cpu/cpu0/cpuidle/state1/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage:42
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency:1
/sys/devices/system/cpu/cpu0/cpuidle/state2/desc:ACPI IOPORT 0x4014
/sys/devices/system/cpu/cpu0/cpuidle/state2/name:C2
/sys/devices/system/cpu/cpu0/cpuidle/state2/time:36250374
/sys/devices/system/cpu/cpu0/cpuidle/state2/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state2/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state2/usage:2867
/sys/devices/system/cpu/cpu0/cpuidle/state2/latency:1
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc:<null>
/sys/devices/system/cpu/cpu0/cpuidle/state3/name:<null>
/sys/devices/system/cpu/cpu0/cpuidle/state3/time:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency:0

--nextPart2155860.WxWkS2UFC8
Content-Disposition: inline; filename="cpuidle_3.8-rc4_patched.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="cpuidle_3.8-rc4_patched.txt"

/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc:ACPI HLT
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1
/sys/devices/system/cpu/cpu0/cpuidle/state1/time:4644
/sys/devices/system/cpu/cpu0/cpuidle/state1/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage:35
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency:1
/sys/devices/system/cpu/cpu0/cpuidle/state2/desc:ACPI IOPORT 0x4014
/sys/devices/system/cpu/cpu0/cpuidle/state2/name:C2
/sys/devices/system/cpu/cpu0/cpuidle/state2/time:44430
/sys/devices/system/cpu/cpu0/cpuidle/state2/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state2/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state2/usage:52
/sys/devices/system/cpu/cpu0/cpuidle/state2/latency:1
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc:ACPI IOPORT 0x4016
/sys/devices/system/cpu/cpu0/cpuidle/state3/name:C3
/sys/devices/system/cpu/cpu0/cpuidle/state3/time:25798363
/sys/devices/system/cpu/cpu0/cpuidle/state3/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage:1826
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency:146

--nextPart2155860.WxWkS2UFC8--

