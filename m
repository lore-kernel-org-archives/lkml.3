Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009Ab3BTAVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:21:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:23901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab3BTAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:21:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,698,1355126400"; 
   d="scan'208";a="264809570"
Message-ID: <1361319657.2264.0.camel@rzhang1-mobl4>
Subject: Re: regression in linux 3.7 - fan speed at 100% after
 suspend/resume at 100%
From: Zhang Rui <rui.zhang@intel.com>
To: Salvatore Sisinni <s.sisinni@gmail.com>
Cc: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        eduardo.valentin@ti.com
Date: Wed, 20 Feb 2013 08:20:57 +0800
In-Reply-To: <CADuOw61+kM6o-zK=7ZTZQSDU8-y-_NcmAaVJFnaSzNBXuqzggg@mail.gmail.com>
References: <50BDF345.60804@gmail.com>
	 <1354630272.2480.4.camel@rzhang1-mobl4> <50BEF830.6020206@gmail.com>
	 <50D1CF9D.2090709@infracom.it>
	 <CADuOw61+kM6o-zK=7ZTZQSDU8-y-_NcmAaVJFnaSzNBXuqzggg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 18:54 +0100, Salvatore Sisinni wrote:
> Hello Rui,
> 
> same problem here with kernel-3.7.8-202.fc18.x86_64
> but fan speed after resume with kernel-3.6.10-4.fc18.x86_64  seems ok
> acpidump and sys/class/thermal/  details are attached
> 
Hmmm,
can you please check if the problem still exists in the -next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git

thanks,
rui
> Kind Regards
> Salvatore
> 
> On Wed, Dec 19, 2012 at 3:30 PM, Roberto Oppedisano
> <roberto.oppedisano@infracom.it> wrote:
> > Hi,
> >     any news about this issue ? I'm still seeing the problem with the
> > released 3.7 (and also with 3.7.1).
> > Let me know if you need more info or testing.
> >
> > Kind regards
> > R
> >
> > Il 05/12/2012 08:30, Roberto Oppedisano ha scritto:
> >>
> >> Hello Rui
> >>
> >> Il 04/12/2012 15:11, Zhang Rui ha scritto:
> >>>
> >>> Hi, Roberto,
> >>>
> >>> please attach the acpidump output.
> >>
> >>
> >> attached.
> >>
> >>> On Tue, 2012-12-04 at 13:57 +0100, Roberto Oppedisano wrote:
> >>>>
> >>>> Hello,
> >>>>       with recent kernels after a suspend/resume cycle on my laptop (HP
> >>>> 6730b) the fans stays at full speed.
> >>>
> >>> does the fan keep running at full speed after resume?
> >>
> >>
> >> yes, the fan never stops and runs always at full speed.
> >>
> >>
> >>> please attach the output of "grep . /sys/class/thermal/*/*" before
> >>> suspend and when the fan is running at full speed.
> >>> please attach the same stuff in a good kernel.
> >>
> >>
> >> See attached files.
> >> 3.6.9 is the good kernel where the fan behaves correctly.
> >> 3.7.0+git is the bad one.
> >>
> >> Kind regards
> >> R
> >>
> >>>
> >>>
> >>> thanks,
> >>> rui
> >>>
> >>>
> >>>> I've bisected down to this commit:
> >>>>
> >>>> ce119f83257aae29b84a5bfad0669e8348437b18 is the first bad commit
> >>>> commit ce119f83257aae29b84a5bfad0669e8348437b18
> >>>> Author: Zhang Rui <rui.zhang@intel.com>
> >>>> Date:   Wed Jun 27 14:13:04 2012 +0800
> >>>>
> >>>>       Thermal: Introduce simple arbitrator for setting device cooling
> >>>> state
> >>>>
> >>>>       This fixes the problem that a cooling device may be referenced by
> >>>>       by multiple trip points in multiple thermal zones.
> >>>>
> >>>>       With this patch, we have two stages for updating a thermal zone,
> >>>>       1. check if a thermal_instance needs to be updated or not
> >>>>       2. update the cooling device, based on the target cooling state
> >>>>          of all its instances.
> >>>>
> >>>>       Note that, currently, the cooling device is set to the deepest
> >>>>       cooling state required.
> >>>>
> >>>>       Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> >>>>       Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>>>       Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
> >>>>
> >>>> :040000 040000 8469b057ee5b33bdb264624db35c951d0ecdb66b
> >>>> d7288437cff3c7437e59144c46c04c78669a597b M      drivers
> >>>> :040000 040000 397296161d55c825f07501470130928d226497cc
> >>>> f715fd1770dd33fd333c5fa339e740537b2a916f M      include
> >>>>
> >>>> I tried to revert it but there are rejects so I cold not try current
> >>>> kernel with simply this commit removed.
> >>>>
> >>>> As a side note when the fan is at full speed a see an anomaly on thermal
> >>>> indicator #4
> >>>>
> >>>> $ grep 0 /sys/devices/virtual/thermal/thermal_zone*/temp
> >>>> /sys/devices/virtual/thermal/thermal_zone0/temp:59000
> >>>> /sys/devices/virtual/thermal/thermal_zone1/temp:63000
> >>>> /sys/devices/virtual/thermal/thermal_zone2/temp:48000
> >>>> /sys/devices/virtual/thermal/thermal_zone3/temp:27900
> >>>> /sys/devices/virtual/thermal/thermal_zone4/temp:100000
> >>>>
> >>>> while the others seem to report normal value. Attached the output of
> >>>> dmesg on this laptop.
> >>>>
> >>>> More info/testing on request.
> >>>>
> >>>> Kind regards
> >>>> R
> >>>
> >>>
> >>>
> >>
> >
> >
> > --
> > Roberto Oppedisano
> > Infracom Italia S.p.A.
> > Ingegneria d'offerta
> > Tel. +39 0459692691
> > Mob. +39 3487419534
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >


