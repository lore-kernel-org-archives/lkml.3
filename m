Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3FKWcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:32:50 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42375 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab3FKWct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:32:49 -0400
Message-ID: <1370989954.21540.4.camel@misato.fc.hp.com>
Subject: Re: cpu hotplug:  possible_cpus broken (again?) next-20130607
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, youquan.song@intel.com
Cc: Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 16:32:34 -0600
In-Reply-To: <27437213.QrmAtijARn@vostro.rjw.lan>
References: <51B79BE5.80804@sr71.net> <1637965.BN0HgQKvFj@vostro.rjw.lan>
	 <51B7A1F8.6080507@sr71.net> <27437213.QrmAtijARn@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 00:34 +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 11, 2013 03:17:28 PM Dave Hansen wrote:
> > On 06/11/2013 03:05 PM, Rafael J. Wysocki wrote:
> > > On Tuesday, June 11, 2013 02:51:33 PM Dave Hansen wrote:
> > >> possible_cpus looks broken again.  I'm booting with:
> > >>
> > >>  maxcpus=10 possible_cpus=160
> > >>
> > >> But I only get 0-9 in sysfs:
> > >>
> > >>> # ls /sys/devices/system/cpu/
> > >>> cpu0  cpu2  cpu4  cpu6  cpu8  cpufreq  kernel_max  offline  possible  probe    uevent
> > >>> cpu1  cpu3  cpu5  cpu7  cpu9  cpuidle  modalias    online   present   release
> > > 
> > > Can you please test the acpi-hotplug branch of the linux-pm.git tree?
> > 
> > That branch seems to work happily.
> 
> In that case the problem may have been reintroduced by a merge conflict fix in
> linux-next.

I believe the problem was introduced by the following change.  From the
description, though, this is exactly what this patch was trying to
change...  Adding Youguan to the list.

commit 3e275a5ba367ab74b3a4e49114307baed989fcac
Author: Youquan Song <youquan.song@intel.com>
Date:   Fri Jun 7 10:07:08 2013 +1000

    drivers/base/cpu.c: fix maxcpus boot option


Thanks,
-Toshi
    



