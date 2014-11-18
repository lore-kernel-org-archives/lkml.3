Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaKRAbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:31:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:36426 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaKRAbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:31:47 -0500
Date: Tue, 18 Nov 2014 01:31:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: Stephane Eranian <eranian@google.com>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, kan.liang@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug
 workaround
In-Reply-To: <20141117235841.GD25157@pd.tnic>
Message-ID: <alpine.DEB.2.11.1411180115420.3909@nanos>
References: <1416251225-17721-1-git-send-email-eranian@google.com> <1416251225-17721-14-git-send-email-eranian@google.com> <20141117230232.GC25157@pd.tnic> <alpine.DEB.2.11.1411180025270.3909@nanos> <20141117235841.GD25157@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Borislav Petkov wrote:
> On Tue, Nov 18, 2014 at 12:38:14AM +0100, Thomas Gleixner wrote:
> > Well a bitmask is a pretty indescriptive item as well. Putting my user
> > hat on: Where is the documentation for the bits?
> 
> $ cat /sys/devices/system/cpu/bugs
> 0xXXXXXX - currently enabled workarounds are the set bits.
> bit 0: workaround for bug#blabla
> bit 1: workaround for bug#1
> bit 2: workaround for bug#2; remember to do <bla> before disabling workaround
> ...
> bits n-63 are reserved, cannot be set and RAZ.

You sure that 64 are enough?

You need to create stable but numbers, i.e. each bug gets a fixed but
number whethr it affects the machine or not. Otherwise you will drive
admins completely nuts.

> This will be issued when user cats the sysfs file.

That might work as well, though you want that to be:

  /sys/devices/system/cpu/bugs/

  /sys/devices/system/cpu/bugs/status

  /sys/devices/system/cpu/bugs/enable_workaround

  /sys/devices/system/cpu/bugs/disable_workaround

  The latter two take a bit number rather than a magic mask.

So while it looks less effort to implement and extend in the first
place I think, that a bit of infrastructure work will make the
explicit scheme I proposed before a no brainer to maintain and extend,
but I cannot judge what's more intuitive to use.

Thanks,

	tglx



