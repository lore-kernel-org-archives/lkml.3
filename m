Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3JGA2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:28:04 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49927 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3JGA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <20131006235702.GA21738@srcf.ucam.org>
References: <20131004161226.GA22784@srcf.ucam.org>
	<CAMP44s0tqKBgUTzFnbTMqDVVWLcaDC5VKd9mq_w+T_Yu19KXqQ@mail.gmail.com>
	<20131006203353.GA19795@srcf.ucam.org>
	<CAMP44s0N5xqD2W7-r-j1k3efo1k0qY2gCeqn+tbHsvOsrqOJgg@mail.gmail.com>
	<20131006204518.GA20077@srcf.ucam.org>
	<CAMP44s0GkVyw+PRYKqq7=MXFFtgUO9xCq6jTsoQV-rSRmC23yg@mail.gmail.com>
	<20131006205928.GA20296@srcf.ucam.org>
	<CAMP44s33CByGsRz7vsNAoOLnbEMY+fz73NzHJq07BzSuCEGJUg@mail.gmail.com>
	<20131006233106.GA21562@srcf.ucam.org>
	<CAMP44s1-vCgOkE_h1ZEmCA2WiQyLTOvnis2MOjdu8kdDB39kFg@mail.gmail.com>
	<20131006235702.GA21738@srcf.ucam.org>
Date: Sun, 6 Oct 2013 19:27:48 -0500
Message-ID: <CAMP44s3+GdeN6ZFxi6dKZ_1kyTgmgjTf4ET=pJnkSwoirZQMjw@mail.gmail.com>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 6, 2013 at 6:57 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Oct 06, 2013 at 06:36:57PM -0500, Felipe Contreras wrote:
>> On Sun, Oct 6, 2013 at 6:31 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > On Sun, Oct 06, 2013 at 06:27:28PM -0500, Felipe Contreras wrote:
>> >> From acpi_osi_dmi_table:
>> >>
>> >> /*
>> >> * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
>> >> * Linux ignores it, except for the machines enumerated below.
>> >> */
>> >
>> > Which was a mistake. We learn from mistakes rather than repeating them.
>>
>> According to you.
>
> Cool. Look at that file and, without resorting to git blame, tell me
> why each of those entries is there.

If my original comment was kept, I could tell you why the three
entries I added were there.

---
/*
* The following machines have broken backlight support when reporting
* the Windows 2012 OSI, so disable it until their support is fixed.
*/
{
.callback = dmi_disable_osi_win8,
.ident = "ASUS Zenbook Prime UX31A",
.matches = {
    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
    DMI_MATCH(DMI_PRODUCT_NAME, "UX31A"),
},
},
{
.callback = dmi_disable_osi_win8,
.ident = "Dell Inspiron 15R SE",
.matches = {
    DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
    DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7520"),
},
},
{
.callback = dmi_disable_osi_win8,
.ident = "Lenovo ThinkPad Edge E530",
.matches = {
    DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
    DMI_MATCH(DMI_PRODUCT_VERSION, "3259A2G"),
},
},

/*
* BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
* Linux ignores it, except for the machines enumerated below.
*/
---

It is clear as day.

> If your answer is "Just use git
> blame", then that's fine up until the point where someone reformats the
> list or decides to change the order and now it's still *possible* it's
> just really annoying

That's not my answer.

> so why not just add the comments? They're cheap
> and you could have done it trivially in the time it's taken you to reply
> to this thread.

Because it's the wrong thing to do. Adding four lines of comments for
each one of the nine entries is a waste of code, it's completely
unnecessary, and doesn't bring any advantage that a single comment, on
top of the list doesn't.

This patch brings real benefits to real users, and does so without
introducing any problem to the format of this list that wasn't already
there. There is no reason not to apply it.

If _you_ want to add comments for each entry in the list you can do so
after this patch is applied.

-- 
Felipe Contreras
