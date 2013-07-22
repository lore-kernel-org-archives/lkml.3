Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3GVN1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:27:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60797 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3GVN1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:27:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>
Subject: Re: Linux 3.11-rc2
Date: Mon, 22 Jul 2013 15:37:42 +0200
Message-ID: <8019054.MeLu41uqLm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3298830.Snx2ykMFY6@merkaba>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <5728692.GlhGgHY92H@vostro.rjw.lan> <3298830.Snx2ykMFY6@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 03:15:38 PM Martin Steigerwald wrote:
> Am Montag, 22. Juli 2013, 15:02:22 schrieb Rafael J. Wysocki:
> > On Monday, July 22, 2013 12:08:40 AM James Hogan wrote:
> > > On 21 July 2013 20:53, Linus Torvalds <torvalds@linux-foundation.org> 
> wrote:
> > > >  (b) we had a late change to how ACPI backlight handling is done on
> > > > 
> > > > certain machines, and while this kind of thing really shouldn't be
> > > > done outside the merge window, I ended up pulling it anyway. But I'd
> > > > *really* like to have people test this thing particularly on laptops
> > > > with intel-based graphics. It should only matter (and hopefully
> > > > improve things) for the newer ones with BIOSes designed for Windows 8,
> > > > but hey, the more testing, the better. Backlight handling has beenin
> > > > painful before, so I'm mentioning this explicitly.
> > > 
> > > 8c5bd7a "ACPI / video / i915: No ACPI backlight if firmware expects
> > > Windows 8" breaks backlight control for me because
> > > /sys/class/backlight/acpi_video0 disappears, and
> > > /sys/class/backlight/intel_backlight doesn't seem to have any effect.
> > > 
> > > Note that acpi_video0 only worked because I was applying "[PATCH]
> > > drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight" [1], so
> > > strictly speaking mainline already didn't work.
> > 
> > James, sorry for breaking things for you.  The patch you're mentioning is
> > going to hit the mainline at one point anyway I suppose.
> 
> Dunno whether thats related, but after locking screen today and screen blanker 
> kicking in (just a blank screen), I was not able to reactivate the display 
> again by typing a key or so unless I closed the laptop display lid, let the 
> machine suspend (to ram) and opened it again.
> 
> Plain 3.11-rc2 on ThinkPad T520:

Well, please try to revert commits efaa14c and 8c5bd7a (in this order) and see
if that helps.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
