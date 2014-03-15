Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaCOCR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 22:17:56 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:59711 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaCOCRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 22:17:55 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTyOPSIUj7WA==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
Date: Sat, 15 Mar 2014 02:17:47 +0000
User-Agent: KMail/1.13.7 (Linux/3.13-6.slh.1-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Lan Tianyu <tianyu.lan@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20140314211456.GA23213@amd.pavel.ucw.cz> <CAKb7Uvh1TaNLmi0YVBPmCD571ZU_sM1DpbYUSA8xQZnS5xUbCA@mail.gmail.com> <1677000.FsvVVRjEvo@vostro.rjw.lan>
In-Reply-To: <1677000.FsvVVRjEvo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403150217.50526.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Saturday 15 March 2014, Rafael J. Wysocki wrote:
> On Friday, March 14, 2014 06:14:12 PM Ilia Mirkin wrote:
> > On Fri, Mar 14, 2014 at 6:11 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > > On Fri 2014-03-14 17:29:41, Ilia Mirkin wrote:
> > >> On Fri, Mar 14, 2014 at 5:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
[...]
> > wmbattery
> > 
> > They have attempted to use the sysfs api, but apparently that
> > integration was done with an older version of that API. There's also
> > some attempt to get it to work with upower, but I couldn't figure out
> > how to make that work either on my (up-to-date gentoo) box. (TBH I
> > didn't spend more than an hour or two on it, so it may not be
> > impossible.)
> 
> Tianyu, can you please have a look at this?

Disclaimer, I've never used wmbattery so far.

The current upstream version (2.42, released in early december 2013) 
of wmbattery[1] no longer reads from /proc/acpi/ at all. Apparently
it changed to using upower by default, with non-default fall-backs for
reading from sysfs. 

The only change required for building upower with wmbattery 2.42 
appears to be a new build-dependency on libupower-glib-dev (at least 
on Debian, built from the upower source package). Given that this 
version is present in Debian testing and unstable, I'd assume that it's
supposed to work using upower, although I haven't confirmed that myself.

Judging from the Gentoo ebuild, you probably just have to add 
"sys-power/upower" to the RDEPEND variable and make sure to build
wmbattery 2.42; this is untested.

Regards
	Stefan Lippers-Hollmann

[1]	Homepage: http://kitenet.net/~joey/code/wmbattery/
	Vcs-Git: git://git.kitenet.net/wmbattery
