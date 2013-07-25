Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3GYOwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:52:06 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44737 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3GYOwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <2218913.HKGjJcYT1G@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	<CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
	<9012759.Alzqtdvh5b@vostro.rjw.lan>
	<2218913.HKGjJcYT1G@vostro.rjw.lan>
Date: Thu, 25 Jul 2013 16:52:01 +0200
Message-ID: <CADDKRnAwipzeYsrx7vyTYToPvQkhCg1PgxzCWqvbW_w+Qd9Oeg@mail.gmail.com>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Aaron Lu <aaron.lu@intel.com>, Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/25 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
>> On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
>> > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > >
>> > > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
>> >
>> > Yes, but let's wait a while. Not because I think we'll fix the problem
>> > (hey, miracles might happen), but because I think it would be useful
>> > to couple the reverts with information about the particular machines
>> > that broke (and the people who reported it). So that when we
>> > inevitably try again, we can perhaps get some testing effort with
>> > those machines/people.
>> >
>> > It doesn't seem to be a show-stopped for a large number of people, so
>> > there's no huge hurry. I'd suggest doing the revert just in time for
>> > rc3, but waiting until then to gather info about people who see
>> > breakage.
>> >
>> > Sound like a plan?
>>
>> Yes, it does.
>
> OK, time to revert I guess.
>
> James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended patch
> fixes the backlight for you.
>

Problems, problems :-) I tried to apply on top of 3.11-rc2:

jojo@ahorn:/data/kernel/linux$ git log --pretty=oneline | head -5
3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b Linux 3.11-rc2
ea45ea70b6131fa0b006f5b687b9b1398b24f681 Merge tag 'acpi-video-3.11'
of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
90db76e829479ef2ba1fed8f2552846015469831 Merge tag 'ext4_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
dda5690defe4af62ee120f055e98e40d97e4c760 ext3: fix a BUG when opening
a file with O_TMPFILE flag
e94bd3490f4ef342801cfc76b33d8baf9ccc9437 ext4: fix a BUG when opening
a file with O_TMPFILE flag

jojo@ahorn:/data/kernel/linux$ git apply --check
/data/kernel/acpi-backlight-revert.patch
error: patch failed: drivers/acpi/video.c:897
error: drivers/acpi/video.c: patch does not apply
error: patch failed: drivers/gpu/drm/i915/i915_dma.c:1648
error: drivers/gpu/drm/i915/i915_dma.c: patch does not apply
error: patch failed: include/acpi/video.h:17
error: include/acpi/video.h: patch does not apply
error: patch failed: drivers/acpi/video_detect.c:235
error: drivers/acpi/video_detect.c: patch does not apply
error: patch failed: include/linux/acpi.h:191
error: include/linux/acpi.h: patch does not apply
error: patch failed: drivers/acpi/internal.h:169
error: drivers/acpi/internal.h: patch does not apply
