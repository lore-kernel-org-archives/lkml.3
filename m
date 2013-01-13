Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3AMT65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 14:58:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39931 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab3AMT6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 14:58:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Schlichter <thomas.schlichter@web.de>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Andreas =?ISO-8859-1?Q?M=FCller?= <goo@stapelspeicher.org>,
        Julius Werner <jwerner@chromium.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: fix new C-states not functional after AC disconnect
Date: Sun, 13 Jan 2013 21:04:45 +0100
Message-ID: <11530988.U26HMGnFLa@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50F2C79E.5000302@linaro.org>
References: <2099093.cPXO6Nhn9v@netbook> <50F2C79E.5000302@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 13, 2013 03:41:34 PM Daniel Lezcano wrote:
> On 01/13/2013 01:34 PM, Thomas Schlichter wrote:
> > Hi,
> > 
> > there is a long-standing regression about new C-states not working after 
> > disconnecting AC power from a laptop if the cpuidle driver "acpi-idle" is 
> > used. It was reported here:
> > 
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=42870  (March 5th 2012)
> > [2] https://bugzilla.kernel.org/show_bug.cgi?id=43349  (June 7th 2012)
> > [3] https://lkml.org/lkml/2012/10/16/518   (October 19th 2012)
> > 
> > In [1] Andreas proposed a patch that initialized the missing power_usage 
> > values from within acpi_idle in the same way as cpuidle does.
> > In [2] I proposed a patch to use the power values provided by ACPI to 
> > initialize the power_usage variables.
> > In [3] Julius proposed a patch to call the initialization function 
> > set_power_states()  not only once, but always when the C-states change.
> > 
> > Currently, Daniel Lezcano seems to be working on an intrusive change of not 
> > using the power_usage value at all for choosing a C-state:
> > 
> > [4] https://lkml.org/lkml/2012/12/14/155
> > 
> > As I could not find any of these patches in any git trees to be merged for 
> > 3.8, I propose an other, least intrusive patch for the time being. It is 
> > attached an initializes _all_ power_usage values in the first place.
> > 
> > As this is a real power consumption regression since 3.2, I really ask you to 
> > apply anything and push it to stable, too!
> 
> Rafael, is possible to apply the patch [1/2] I previously sent ?
> 
> https://patchwork.kernel.org/patch/1878691/

I need to talk about this with Len.  That should happen tomorrow if everything
goes well.

> So we get this bug fixed.
> 
> I will resend the patch [2/2] as soon as possible.

OK

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
