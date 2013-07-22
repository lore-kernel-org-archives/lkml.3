Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3GVNVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:21:40 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:43679 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3GVNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:21:38 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <5728692.GlhGgHY92H@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	<CAAG0J9-OgVe3Y0uo0bKr2TTcn3YUna1C_5NixBSsft3+cbKKWw@mail.gmail.com>
	<5728692.GlhGgHY92H@vostro.rjw.lan>
Date: Mon, 22 Jul 2013 14:21:37 +0100
Message-ID: <CAAG0J98T2gY9A8sbDOjfR_jqy9xQOh1Y65uSRbOsf4Tk9ZgcHg@mail.gmail.com>
Subject: Re: Linux 3.11-rc2
From: James Hogan <james@albanarts.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2013 14:02, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, July 22, 2013 12:08:40 AM James Hogan wrote:
>> On 21 July 2013 20:53, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> >  (b) we had a late change to how ACPI backlight handling is done on
>> > certain machines, and while this kind of thing really shouldn't be
>> > done outside the merge window, I ended up pulling it anyway. But I'd
>> > *really* like to have people test this thing particularly on laptops
>> > with intel-based graphics. It should only matter (and hopefully
>> > improve things) for the newer ones with BIOSes designed for Windows 8,
>> > but hey, the more testing, the better. Backlight handling has beenin
>> > painful before, so I'm mentioning this explicitly.
>>
>> 8c5bd7a "ACPI / video / i915: No ACPI backlight if firmware expects
>> Windows 8" breaks backlight control for me because
>> /sys/class/backlight/acpi_video0 disappears, and
>> /sys/class/backlight/intel_backlight doesn't seem to have any effect.
>>
>> Note that acpi_video0 only worked because I was applying "[PATCH]
>> drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight" [1], so
>> strictly speaking mainline already didn't work.
>
> James, sorry for breaking things for you.  The patch you're mentioning is going
> to hit the mainline at one point anyway I suppose.
>
> In the meantime I received a report from Steven Newbury that these changes
> broke things for him too, so we need to revert commits 8c5bd7a and efaa14c.
> The other two commits in the series should be benign.

Feel free to Cc me on updated versions of the patches if you'd like me to test.

Cheers
James
