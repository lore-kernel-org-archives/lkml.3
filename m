Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKESyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:54:02 -0500
Received: from ozlabs.org ([103.22.144.67]:38924 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaKESx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:53:59 -0500
Date: Thu, 6 Nov 2014 05:53:57 +1100
From: Anton Blanchard <anton@samba.org>
To: Don Zickus <dzickus@redhat.com>
Cc: uobergfe@redhat.com, drjones@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Confusing behaviour with /proc/sys/kernel/nmi_watchdog
Message-ID: <20141106055357.530e1458@kryten>
In-Reply-To: <20141105145356.GL135937@redhat.com>
References: <20141105093420.1c7500d8@kryten>
	<20141105145356.GL135937@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Don,

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
> 
> I believe Andrew answered the question for you, it's a WIP and we have
> patches to clean that up.

Thanks, yes good to see it being worked on.

> I don't see ppc64 watchdog support in arch/powerpc, is that something
> you are working with on implementing?

I've submitted it over on linuxppc-dev:

http://patchwork.ozlabs.org/patch/406802/

Anton
