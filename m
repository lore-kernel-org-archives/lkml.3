Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3GUXIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 19:08:43 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:63590 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3GUXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 19:08:42 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
Date: Mon, 22 Jul 2013 00:08:40 +0100
Message-ID: <CAAG0J9-OgVe3Y0uo0bKr2TTcn3YUna1C_5NixBSsft3+cbKKWw@mail.gmail.com>
Subject: Re: Linux 3.11-rc2
From: James Hogan <james@albanarts.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 July 2013 20:53, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>  (b) we had a late change to how ACPI backlight handling is done on
> certain machines, and while this kind of thing really shouldn't be
> done outside the merge window, I ended up pulling it anyway. But I'd
> *really* like to have people test this thing particularly on laptops
> with intel-based graphics. It should only matter (and hopefully
> improve things) for the newer ones with BIOSes designed for Windows 8,
> but hey, the more testing, the better. Backlight handling has beenin
> painful before, so I'm mentioning this explicitly.

8c5bd7a "ACPI / video / i915: No ACPI backlight if firmware expects
Windows 8" breaks backlight control for me because
/sys/class/backlight/acpi_video0 disappears, and
/sys/class/backlight/intel_backlight doesn't seem to have any effect.

Note that acpi_video0 only worked because I was applying "[PATCH]
drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight" [1], so
strictly speaking mainline already didn't work.

Cheers
James

[1] http://lkml.org/lkml/2013/7/19/748
