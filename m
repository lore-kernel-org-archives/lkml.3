Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbbAUDjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:39:45 -0500
Received: from ozlabs.org ([103.22.144.67]:40997 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbbAUDjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:39:44 -0500
Date: Wed, 21 Jan 2015 14:39:42 +1100
From: Anton Blanchard <anton@samba.org>
To: Andrew Jones <drjones@redhat.com>
Cc: uobergfe@redhat.com, dzickus@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Confusing behaviour with /proc/sys/kernel/nmi_watchdog
Message-ID: <20150121143942.1549e9c9@kryten>
In-Reply-To: <20141105102645.GA3046@hawk.usersys.redhat.com>
References: <20141105093420.1c7500d8@kryten>
	<20141105102645.GA3046@hawk.usersys.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> On Wed, Nov 05, 2014 at 09:34:20AM +1100, Anton Blanchard wrote:
> > commit 9919e39a1738 ("kvm: ensure hard lockup detection is disabled
> > by default") provided a way for the kernel to disable the hard
> > lockup detector at runtime.
> > 
> > I'm using it on ppc64 but notice some weird behaviour with the
> > nmi_watchdog procfs variable. At boot, that the hard lockup
> > detector appears to be enabled even when we disable it via
> > watchdog_enable_hardlockup_detector(false):
> > 
> > # cat /proc/sys/kernel/nmi_watchdog 
> > 1
> > 
> > I have to echo 0 to it then echo 1 again to enable it.
> > 
> > Anton
> 
> Hi Anton,
> 
> Yes, the nmi watchdog proc variables are currently a bit
> confusing. Uli has posted a series to clear all that up
> though. Please see
> 
> https://lkml.org/lkml/2014/10/17/340

Any progress on this? I'm rebasing our hardware NMI patch for ppc64 and
notice the strange behaviour is still in mainline.

Anton
