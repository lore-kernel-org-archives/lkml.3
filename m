Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaLKCh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:37:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:56414 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937AbaLKCh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:37:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,555,1413270000"; 
   d="scan'208";a="621949921"
Message-ID: <1418265472.12435.68.camel@rzhang1-toshiba>
Subject: Re: [PATCH v5] Thermal: introduce INT3406 thermal driver
From: Zhang Rui <rui.zhang@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Aaron Lu <aaron.lu@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Dec 2014 10:37:52 +0800
In-Reply-To: <CAOesGMj_uObbxLdpobEhP=nRPsFUJNCtq01RH7ZSECd5=1Ti6Q@mail.gmail.com>
References: <54868CF6.6020505@intel.com>
	 <CAOesGMirF-_H2ZzFR-VpwkEErZE2uQJSYx5EuePArQsEh=r_Kw@mail.gmail.com>
	 <20141211010226.GA26253@aaronlu.sh.intel.com>
	 <CAOesGMj_uObbxLdpobEhP=nRPsFUJNCtq01RH7ZSECd5=1Ti6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 18:15 -0800, Olof Johansson wrote:
> On Wed, Dec 10, 2014 at 5:02 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> > On Wed, Dec 10, 2014 at 11:53:25AM -0800, Olof Johansson wrote:
> >> Hi,
> >>
> >> [+daniel vetter]
> >>
> >> On Mon, Dec 8, 2014 at 9:47 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> >> > INT3406 ACPI device object resembles an ACPI video output device, but its
> >> > _BCM is said to be deprecated and should not be used. So we will make
> >> > use of the raw interface to do the actual cooling. Due to this, the
> >> > backlight core has some modifications. Also, to re-use some of the ACPI
> >> > video module's code, one function has been exported.
> >> >
> >> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> >> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> >> > ---
> >> > v5:
> >> > Add the missing file drivers/thermal/int340x_thermal/Kconfig
> >> > Remove the assignment of .owner field from the device_driver structure
> >>
> >>
> >> Did this patch show up in -next for the first time last night, or did
> >> some other change break this?
> >>
> >> It causes a panic in i915 when booting Minnowboard Max for me.
> >
> > Sorry for the trouble, I'm looking at this now.
> > Is there anything special about the Minnowboard Max? I'll try to
> > reproduce the issue here locally with a typical Intel desktop.
> 
> Another good question is why the code showed up in -next today. Code
> going in for 3.19 is supposed to have been baking there already, and
> it's too early to stage anything for 3.20.
> 
> Zhang?

well, my Linux machine happened to be broken when I was in travel in Oct
and Nov, so that I got the 3.19 material prepared a little late.
Thus I just took some fixes and driver specific patches and plan to push
my pull request next week.
For this one, it had been pushed to linux-next for 3.18, but was dropped
because of some Kconfig problem. So I thought it was safe to include
this one for 3.19.
sorry for bring the trouble here.

Now my intention is to see if we can have this problem fixed by this
Fri. If not, I will drop it for 3.19. is it okay for you?

thanks,
rui
> 
> > Is it the next/master branch?
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> 
> Yes. But I've confirmed that it happens with Zhang's next branch too
> without the rest of linux-next.
> 
> 
> -Olof


