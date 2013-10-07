Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3JGCOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 22:14:01 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:64385 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3JGCN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 22:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <20131007012704.GA22371@srcf.ucam.org>
References: <20131006205928.GA20296@srcf.ucam.org>
	<CAMP44s33CByGsRz7vsNAoOLnbEMY+fz73NzHJq07BzSuCEGJUg@mail.gmail.com>
	<20131006233106.GA21562@srcf.ucam.org>
	<CAMP44s1-vCgOkE_h1ZEmCA2WiQyLTOvnis2MOjdu8kdDB39kFg@mail.gmail.com>
	<20131006235702.GA21738@srcf.ucam.org>
	<CAMP44s3+GdeN6ZFxi6dKZ_1kyTgmgjTf4ET=pJnkSwoirZQMjw@mail.gmail.com>
	<20131007003247.GA21999@srcf.ucam.org>
	<CAMP44s1knbxW5C_tRSqopRLd+b2fXfuH=E3_L4EdOAUG4RMVhg@mail.gmail.com>
	<20131007005355.GA22211@srcf.ucam.org>
	<CAMP44s0jCvzrBDuiGe=q=tJyQGSGt47aAeJJyPgEtrQB_qXq1Q@mail.gmail.com>
	<20131007012704.GA22371@srcf.ucam.org>
Date: Sun, 6 Oct 2013 21:13:57 -0500
Message-ID: <CAMP44s20+KbtZKD52oBsMsV_SA7t7u_vCFRcxzCZ9UwH-LXcYA@mail.gmail.com>
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

On Sun, Oct 6, 2013 at 8:27 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Oct 06, 2013 at 08:01:34PM -0500, Felipe Contreras wrote:
>> On Sun, Oct 6, 2013 at 7:53 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > No, it demonstrably doesn't. The comments that do exist refer to only a
>> > subset of the entries underneath them.
>>
>> That's not true.
>>
>> /*
>> * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
>> * Linux ignores it, except for the machines enumerated below.
>> */
>
> You appear to have missed the continuation of that comment directly
> underneath which lists a subset of the devices covered by the quirks.

What of it? The comment I'm referring to applies to *ALL* the entries
below, not a subset of them. All the entries below use
dmi_enable_osi_linux().

>> > Having a per-entry comment is significantly clearer.
>>
>> That is your opinion, it's not a demonstrable fact.
>
> Say one of the machines turns out to need the quirk for two different
> reasons. How do we document that?

  /* 0) The following... disable Windows 2012 OSI */
  a
  b
  /* 1) This particular... whatever */
  c
  d
  /* 2) The following... enable OSI Linux */

Is it not clear that the comment 1) applies only to c? If it's not
clear for you we can reorder:

  /* 0) The following... disable Windows 2012 OSI */
  a
  b
  d
  /* 1) This particular... whatever */
  c
  /* 2) The following... enable OSI Linux */

> Look, how about you add the comments
> and I'll do a patch that adds documentation to the existing entries? I'm
> not asking you to make up for other people's past mistakes, I'm asking
> you not to perpetuate them.

I will consider that *after* your patch lands. In the meantime I still
maintain that a single comment is better, and I think my patch should
land instead:

http://article.gmane.org/gmane.linux.acpi.devel/64243

>> And just to be clear, you are saying that in the following code, you
>> have no idea which statements correspond to which sections. Am I
>> correct?
>
> No, that's not what I'm saying. But I'm now going to a bar and drink
> instead of having to justify why *clearly documenting this code* is a
> worthwhile thing to do.

This is a rhetorical trick, by "clearly documenting this code" you
actually mean "format it in exactly the way I want". My way of
documenting this code[1] is also clear.

Ultimately it doesn't matter, because the fixes for the Intel driver
are supposed to come soon, and this blacklist should be short-lived,
thus this list is not going to be reordered, moved, or will have the
need for secondary comments.

Look, how about you set aside your objection to this patch so it can
go forward and fix real issues for real users, and deal with the
comments that are already missing anyway later?

[1] http://article.gmane.org/gmane.linux.acpi.devel/64243

-- 
Felipe Contreras
