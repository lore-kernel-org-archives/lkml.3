Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaCPD6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 23:58:00 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:45282 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaCPD56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 23:57:58 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTy+fSIS82hQ==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
Date: Sun, 16 Mar 2014 03:57:48 +0000
User-Agent: KMail/1.13.7 (Linux/3.13-6.slh.1-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20140314211456.GA23213@amd.pavel.ucw.cz> <201403150217.50526.s.L-H@gmx.de> <532471EC.1070107@intel.com>
In-Reply-To: <532471EC.1070107@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403160357.53858.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Saturday 15 March 2014, Lan Tianyu wrote:
> On 03/14/2014 10:17 PM, Stefan Lippers-Hollmann wrote:
> > Hi
> >
> > On Saturday 15 March 2014, Rafael J. Wysocki wrote:
> >> On Friday, March 14, 2014 06:14:12 PM Ilia Mirkin wrote:
> >>> On Fri, Mar 14, 2014 at 6:11 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >>>> On Fri 2014-03-14 17:29:41, Ilia Mirkin wrote:
> >>>>> On Fri, Mar 14, 2014 at 5:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
[...]
> Hi Stefan:
> 	I just glance wmbattery code. I find the code in the acpi.c is already 
> using the new sysfs battery interfaces, right?

By default, wmbattery appears to default to using upower as abstraction
level, instead of querying sysfs itself directly.

http://git.kitenet.net/?p=wmbattery.git;a=blob;f=autoconf/makeinfo.in;hb=HEAD

which sets USE_UPOWER=1 by default.

If USE_UPOWER=0 is set explicitly for the build, it reverts back to 
direct sysfs parsing - and yes, it does appear to adhere to the current
sysfs API properly.

The last remains, and the ability to parse procfs (which hasn't been 
default for quite some time already, in favour of using hal as 
abstraction layer) has finally been removed in

http://git.kitenet.net/?p=wmbattery.git;a=commitdiff;h=833eb63a5ce4f2fb712a201b1db4f2db1700fddb

The switch from procfs parsing to hal (by default at least) in turn 
happened with

http://git.kitenet.net/?p=wmbattery.git;a=commitdiff;h=63c3d1a0b11e8ade1a5612bb5baa3d92e153bbbe

in 2008 (before Debian squeeze/ oldstable). I have not investigated if 
hal then read from procfs or sysfs, but wmbattery at least didn't read
from procfs itself, unless explicitly told to do so (USE_HAL=0) during 
the build since mid 2008.

The current version of wmbattery however will never try to access 
/proc/acpi, the current version no longer knows of its existence.

[Again, I'm not familiar with wmbattery myself and have never run it]

Regards
	Stefan Lippers-Hollmann
