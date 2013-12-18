Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3LRMcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:32:03 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59981 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3LRMb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:31:59 -0500
MIME-Version: 1.0
In-Reply-To: <1894234.3Ripn7cUXR@vostro.rjw.lan>
References: <201201281445.49377.rjw@sisk.pl>
	<8515354.2dTerOA9sd@vostro.rjw.lan>
	<CA+5PVA4g_gG_1w5R_2BQU328BJ59Cq8xiv_BXomXz3FDhFSCzw@mail.gmail.com>
	<1894234.3Ripn7cUXR@vostro.rjw.lan>
Date: Wed, 18 Dec 2013 07:31:59 -0500
X-Google-Sender-Auth: yZz5inbMnnKhazBa1LOa9XHqiaM
Message-ID: <CA+5PVA7vqMqLzQtiB7cHWbiHEbGizOK1db5xBBX1T8Vq66PHqQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 8:16 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, December 17, 2013 08:00:55 PM Josh Boyer wrote:
>> On Tue, Dec 17, 2013 at 7:52 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > On Tuesday, December 17, 2013 11:04:46 AM Josh Boyer wrote:
>> >> On Tue, Dec 17, 2013 at 11:03 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> >> > On Fri, May 25, 2012 at 3:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> On Friday, May 25, 2012, Josh Boyer wrote:
>> >> >>> On Fri, Feb 17, 2012 at 3:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >>> >> commit b94887bbc0621e1e8402e7f0ec4bc3adf46c9a6e
>> >> >>> >> Author: Rafael J. Wysocki <rjw@sisk.pl>
>> >> >>> >> Date:   Fri Feb 17 12:42:08 2012 -0500
>> >> >>> >>
>> >> >>> >>     Freeze all filesystems during system suspend and (kernel-driven)
>> >> >>> >>     hibernation by calling freeze_supers() for all superblocks and thaw
>> >> >>> >>     them during the subsequent resume with the help of thaw_supers().
>> >> >>> >>
>> >> >>> >>     This makes filesystems stay in a consistent state in case something
>> >> >>> >>     goes wrong between system suspend (or hibernation) and the subsequent
>> >> >>> >>     resume (e.g. journal replays won't be necessary in those cases).  In
>> >> >>> >>     particular, this should help to solve a long-standing issue that, in
>> >> >>> >>     some cases, during resume from hibernation the boot loader causes the
>> >> >>> >>     journal to be replied for the filesystem containing the kernel image
>> >> >>> >>     and/or initrd causing it to become inconsistent with the information
>> >> >>> >>     stored in the hibernation image.
>> >> >>> >>
>> >> >>> >>     The user-space-driven hibernation (s2disk) is not covered by this
>> >> >>> >>     change, because the freezing of filesystems prevents s2disk from
>> >> >>> >>     accessing device special files it needs to do its job.
>> >> >>> >>
>> >> >>> >>     This change is based on earlier work by Nigel Cunningham.
>> >> >>> >>
>> >> >>> >>     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> >> >>> >>
>> >> >>> >>     Rebased to 3.3-rc3 by Josh Boyer <jwboyer@redhat.com>
>> >> >>>
>> >> >>> Did this patch ever wind up going anywhere?  Fedora has it sitting in
>> >> >>> our tree with a comment that says "rebase" and I don't see it in the
>> >> >>> linux-next tree at all.
>> >> >>>
>> >> >>> Did if fall through the cracks or was it NAKed somewhere?
>> >> >>
>> >> >> No, it wasn't in principle. There were some comments I haven't addressed yet.
>> >> >
>> >> > Dredging up a really old thread, sorry.
>> >> >
>> >> > We're still carrying this patch along in Fedora.  Should we drop it at
>> >> > this point, or is it still eventually going to head upstream?
>> >>
>> >> Fixed Rafael's email address.  (Double sorry.)
>> >
>> > No biggie.
>> >
>> > I just hadn't got sufficient response for that patch at the time it was
>> > submitted, so I guess it would be good to resubmit it.  Please feel free to
>> > do that if you want.
>>
>> You want me to resend a patch you authored back to you?  I mean, I can
>> do that but it seems a bit strange.  All I did was rebase what you
>> wrote to a newer kernel version.
>
> Well, you can send it to me in private then and I'll resubmit. :-)

Done.  Thanks.

josh
