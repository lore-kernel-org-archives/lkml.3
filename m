Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3IKK13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:27:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:13717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab3IKK12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:27:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,883,1371106800"; 
   d="scan'208";a="358889271"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel@ffwll.ch>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Yves-Alexis Perez <corsac@debian.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Lee Chun-Yi <jlee@novell.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8
In-Reply-To: <1378889140.945.0.camel@x230.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <522D88C3.7000808@intel.com> <5155010.Y1gov7SKhP@vostro.rjw.lan> <87eh8wail7.fsf@intel.com> <1889567.vxI8heiC3B@vostro.rjw.lan> <20130911013206.GA556@mint-spring.sh.intel.com> <87hadrycf4.fsf@intel.com> <1378889140.945.0.camel@x230.lan>
User-Agent: Notmuch/0.16+64~g94fe857 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 11 Sep 2013 13:29:29 +0300
Message-ID: <87d2ofy7li.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Matthew Garrett <matthew.garrett@nebula.com> wrote:
> On Wed, 2013-09-11 at 11:45 +0300, Jani Nikula wrote:
>
>> Before plunging forward, have you observed any difference between the
>> boot modes? We have reports [1] that the backlight behaviour is
>> different with UEFI vs. UEFI+CSM or legacy boot. So I'm wondering if the
>> acpi_gbl_osi_data >= ACPI_OSI_WIN_8 check in patch 2/2 is the whole
>> story.
>> 
>> Further, if we tell the BIOS we're Windows 8 to use the tested BIOS code
>> paths, what guarantees do we have of UEFI+CSM or legacy boots working?
>
> We have no evidence of Windows behaving differently based on the exposed
> firmware type.

By "behaving differently", do you mean internally adapting to the boot
mode, or exhibiting different behaviour to the user?

We have evidence of the firmware behaving differently (VBT, backlight)
based on the boot mode, all else being equal. We don't adapt to that,
and we fail. I don't know if we should adapt, or do things differently
altogether. I don't even know if Windows 8 works on all boot modes on
the machines in question.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
