Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3GVMwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:52:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60729 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab3GVMwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:52:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>
Subject: Re: Linux 3.11-rc2
Date: Mon, 22 Jul 2013 15:02:22 +0200
Message-ID: <5728692.GlhGgHY92H@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAAG0J9-OgVe3Y0uo0bKr2TTcn3YUna1C_5NixBSsft3+cbKKWw@mail.gmail.com>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <CAAG0J9-OgVe3Y0uo0bKr2TTcn3YUna1C_5NixBSsft3+cbKKWw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 12:08:40 AM James Hogan wrote:
> On 21 July 2013 20:53, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >  (b) we had a late change to how ACPI backlight handling is done on
> > certain machines, and while this kind of thing really shouldn't be
> > done outside the merge window, I ended up pulling it anyway. But I'd
> > *really* like to have people test this thing particularly on laptops
> > with intel-based graphics. It should only matter (and hopefully
> > improve things) for the newer ones with BIOSes designed for Windows 8,
> > but hey, the more testing, the better. Backlight handling has beenin
> > painful before, so I'm mentioning this explicitly.
> 
> 8c5bd7a "ACPI / video / i915: No ACPI backlight if firmware expects
> Windows 8" breaks backlight control for me because
> /sys/class/backlight/acpi_video0 disappears, and
> /sys/class/backlight/intel_backlight doesn't seem to have any effect.
> 
> Note that acpi_video0 only worked because I was applying "[PATCH]
> drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight" [1], so
> strictly speaking mainline already didn't work.

James, sorry for breaking things for you.  The patch you're mentioning is going
to hit the mainline at one point anyway I suppose.

In the meantime I received a report from Steven Newbury that these changes
broke things for him too, so we need to revert commits 8c5bd7a and efaa14c.
The other two commits in the series should be benign.

Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?

Rafael (who's having a particularly bad day today)

