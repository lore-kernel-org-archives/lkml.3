Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3I0APV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 20:15:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37789 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3I0APT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 20:15:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH v3 0/4] Fix Win8 backlight issue
Date: Fri, 27 Sep 2013 02:26:35 +0200
Message-ID: <3910636.aGHp6YakQl@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CADDKRnA7Eqox6s6t315c=OaEpAgRcX62_4rF8XuXaNRAipOqcQ@mail.gmail.com>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com> <87eh8clvun.fsf@intel.com> <CADDKRnA7Eqox6s6t315c=OaEpAgRcX62_4rF8XuXaNRAipOqcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 09:49:03 AM Jörg Otte wrote:
> 2013/9/25 Jani Nikula <jani.nikula@linux.intel.com>:
> > On Wed, 25 Sep 2013, Jörg Otte <jrg.otte@gmail.com> wrote:
> >> 2013/9/25 Jani Nikula <jani.nikula@linux.intel.com>:
> >>> On Wed, 25 Sep 2013, Aaron Lu <aaron.lu@intel.com> wrote:
> >>>> On Wed, Sep 25, 2013 at 10:29:37AM +0200, Jörg Otte wrote:
> >>>>> Backlight can't be modified with this patch set - neither with
> >>>>> function keys nor with the gui. It is a step backward to v3.11-rc1
> >>>
> >>> So both hotkeys and GUI work in v3.11-rc1? And v3.12-rc2?
> >>
> >> In  v3.11-rc1 it didn't work.
> >> Since a later rc (I don't remember exactly which) it did work.
> >> In v3.12-rc1/2 it does work.
> >> In v3.12-rc2 + Aaron's patch set it again doesn't work.
> >>
> >>>
> >>>> Thanks for the test.
> >>>>
> >>>> Please check /sys/class/backlight, is there only one link file
> >>>> intel_backlight?
> >>>
> >>> Indeed, are there others? fujitsu-laptop perhaps? If yes, try
> >>> CONFIG_FUJITSU_LAPTOP=n or an appropriate module blacklist.
> >>>
> >>> Just checking, you do have CONFIG_BACKLIGHT_CLASS_DEVICE=y?
> >>
> >> There is only one intel_backlight link.
> >> Yes, I have CONFIG_BACKLIGHT_CLASS_DEVICE=y
> >>
> >>> Embarrassingly there was a bug in i915 fixed just recently where the
> >>> backlight device wasn't registered for
> >>> CONFIG_BACKLIGHT_CLASS_DEVICE=m...
> >>>
> >>>> If so, please cd inside and try modify the brightness file using echo
> >>>> with some values in the range of 0 - max_brightness, does the
> >>>> backlight level change when you echo a new value? I guess it doesn't,
> >>>> or you wouldn't notice problem. If indeed so, perhaps file a bug at
> >>>> http://bugzilla.kernel.org, Drivers/Video(DRI-Intel)? I suppose Jani
> >>>> and Daniel can help fix your problem.
> >>>
> >>> Yup, please check the above, and report back.
> >>
> >> - echo 0..max_brightness > brightness does not work.
> >
> > Thanks for the info.
> >
> > How about v3.12-rc2 without Aaron's patches? Does intel_backlight also
> > not work there? How about the acpi_video0 (which I presume is present)
> > sysfs interface?
> >
> 
> Without Aaron's patches intel_backlight also does not work.
> But acpi_video0 does (and takes precedence I think).

So can you please open a bug entry at bugzilla.kernel.org against i915?

The fact that ACPI video works for you doesn't mean that intel_backlight
shouldn't, I suppose?

Rafael

