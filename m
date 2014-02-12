Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaBLJ1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:27:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:21971 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaBLJ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:26:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,831,1384329600"; 
   d="scan'208";a="473886150"
Date: Wed, 12 Feb 2014 11:34:30 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / video: Add HP EliteBook Revolve 810 to the
 blacklist
Message-ID: <20140212093430.GB5018@intel.com>
References: <1391425156-27821-1-git-send-email-mika.westerberg@linux.intel.com>
 <52F43716.7020008@intel.com>
 <20140207102523.GO18029@intel.com>
 <52FADD1F.90209@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FADD1F.90209@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:31:59AM +0800, Aaron Lu wrote:
> On 02/07/2014 06:25 PM, Mika Westerberg wrote:
> > On Fri, Feb 07, 2014 at 09:29:58AM +0800, Aaron Lu wrote:
> >> On 02/03/2014 06:59 PM, Mika Westerberg wrote:
> >>> On HP EliteBook Revolve 810 the ACPI backlight device doesn't work as
> >>> expected. For example when resuming from system sleep, it seems to lose
> >>> backlight settings.
> >>>
> >>> Forcing Intel driver fixes the problem so add this machine the ACPI
> >>> video detect blacklist.
> >>
> >> For reference's purpose, can you please file a bug to kernel bugzilla
> >> under the ACPI/Power-Video category and attach the acpidump and dmesg
> >> there? Thanks.
> > 
> > Done, the bug is here:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=70231
> > 
> > I noticed that using only the acpi_video0 for tuning backlight works but if
> > I use intel_backlight directly, on resume I get values from acpi_video0
> > instead. I'm not really familiar how this is supposed to work, though so
> > please let me know if I'm missing something.
> 
> Thanks for the report, as communicated on the bug page, your system is
> already blacklisted for win8 by commit:
> 
> commit 2d4054d8422462cb2771fdb4eb1925df55d2b320
> Author:	Takashi Iwai <tiwai@suse.de>  Fri Dec 20 00:09:12 2013
> Committer:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>  Fri Dec 20 22:50:56 2013
> 
> ACPI: Blacklist Win8 OSI for some HP laptop 2013 models
> 
> And the fact that acpi_video interface works made it not appropriate to
> add your system into the video_detect_dmi_table. You can just use acpi_video
> interface and everything should work fine.

OK, thanks for the investigation Aaron.

I have few questions, though.

 1) Is it always right thing to do to use acpi_video0 over anything else?
 In my case that device first disapeared and then reappeared so I got kind
 of confused about that. I'm going to tune my scripts to use acpi_video0 as
 you suggested.

 2) What should we do with this commit? It is already in mainline so I
 guess revert is the sane thing to do.

I should have asked/investigated this more before submitting the patch.
Sorry about that.
