Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaLDK70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:59:26 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37155 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbaLDK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:59:25 -0500
Date: Thu, 4 Dec 2014 10:59:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20141204105908.GM11285@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201406182122.29623@pali>
 <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
 <201411242319.27481@pali>
 <CAL_JsqJuSa-zHTPynH3vAEOK1D2xYRYtVjZJ5zDR0UHAyGYXuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJuSa-zHTPynH3vAEOK1D2xYRYtVjZJ5zDR0UHAyGYXuA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 06:33:08PM -0600, Rob Herring wrote:
> On Mon, Nov 24, 2014 at 4:19 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> > There is no "/serial-number" property in kernel:
> >
> > $ ls -l -a /sys/bus/soc/devices/soc0/
> > drwxr-xr-x    3 0        0                0 Jan  1 00:00 .
> > drwxr-xr-x   18 0        0                0 Jan  1 00:00 ..
> > -r--r--r--    1 0        0             4096 Jan  1 00:00 family
> > -r--r--r--    1 0        0             4096 Jan  1 00:00 machine
> > drwxr-xr-x    2 0        0                0 Jan  1 00:00 power
> > -r--r--r--    1 0        0             4096 Jan  1 00:00 revision
> > lrwxrwxrwx    1 0        0                0 Jan  1 00:00
> > subsystem -> ../../bus/soc
> > -r--r--r--    1 0        0             4096 Jan  1 00:00 type
> > -rw-r--r--    1 0        0             4096 Jan  1 00:00 uevent
> 
> Wrong place. If you put /serial-number in your DT, then it will be in
> /proc/device-tree/serial-number.
> 
> If you want to wire that up to /proc/cpuinfo, I would be fine with that.

That would be fine for me too.  Then it's just a matter of how to copy
the contents of the ATAG into the DT (I assume it's possible in a
similar way to the memory and command line information.)  That's
something I know nothing about though.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
