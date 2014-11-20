Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbaKTRig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:38:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbaKTRif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:38:35 -0500
Date: Thu, 20 Nov 2014 12:38:21 -0500
From: Dave Jones <davej@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        WANG Chao <chaowang@redhat.com>, Baoquan He <bhe@redhat.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120173821.GB9550@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	WANG Chao <chaowang@redhat.com>, Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>
References: <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141118220254.GA2571@redhat.com>
 <20141119144105.GB108701@redhat.com>
 <20141119150333.GB2953@redhat.com>
 <20141119153852.GA16146@redhat.com>
 <20141119162806.GD2953@redhat.com>
 <20141120161055.GA8309@redhat.com>
 <20141120164809.GA22216@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120164809.GA22216@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 11:48:09AM -0500, Vivek Goyal wrote:
 
 > Can we try following and retry and see if some additional messages show
 > up on console and help us narrow down the problem.
 > 
 > - Enable verbose boot messages. CONFIG_X86_VERBOSE_BOOTUP=y
 > 
 > - Enable early printk in second kernel. (earlyprintk=ttyS0,115200).
 > 
 >   You can either enable early printk in first kernel and reboot. That way
 >   second kernel will automatically have it enabled. Or you can edit
 >   "/etc/sysconfig/kdump" and append earlyprintk=<> to KDUMP_COMMANDLINE_APPEND. 
 >   You will need to restart kdump service after this.
 > 
 > - Enable some debug output during runtime from kexec purgatory. For that one
 >   needs to pass additional arguments to /sbin/kexec. You can edit
 >   /etc/sysconfig/kdump file and modify "KEXEC_ARGS" to pass additional
 >   arguments to /sbin/kexec during kernel load. I use following for my
 >   serial console.
 > 
 >   KEXEC_ARGS="--console-serial --serial=0x3f8 --serial-baud=115200"
 > 
 >   You will need to restart kdump service.

The only serial port on this machine is usb serial, which doesn't have io ports.

>From my reading of the kexec man page, it doesn't look like I can tell
it to use ttyUSB0.

And because it relies on usb being initialized, this probably isn't
going to help too much with early boot.

earlyprintk=tty0 didn't show anything extra after the sysrq-c oops.
likewise, =ttyUSB0

I'm going to try bisecting the problem I'm debugging again, so I'm not
going to dig into this much more today.

	Dave

