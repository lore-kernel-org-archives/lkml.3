Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbaFUDUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 23:20:44 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64845 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaFUDUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 23:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140620200918.e1700629.akpm@linux-foundation.org>
References: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
	<20140619052128.GV5015@mwanda>
	<CAPDOMVgwT2=iWAHOhgHSBY1B+KoWHQgCdK4idD2miwB=_eMs5Q@mail.gmail.com>
	<alpine.DEB.2.10.1406210143030.5170@nanos>
	<CAPDOMVihML8uWwBWRTPGG_abHxrW++xP9_Po7B0_KQZmDfHv-Q@mail.gmail.com>
	<20140620193819.e379a55b.akpm@linux-foundation.org>
	<CAPDOMVhr27nDZ8PD3Cw0SUCUMu6Vg3scekX2gAOOi_aP60aXSQ@mail.gmail.com>
	<20140620200918.e1700629.akpm@linux-foundation.org>
Date: Fri, 20 Jun 2014 23:20:41 -0400
Message-ID: <CAPDOMVjkSX1XTpG6dj9rt0qgqoziTeQkBt9eotR3S3qvtLuSgA@mail.gmail.com>
Subject: Re: [PATCH] Check for Null return of function of affs_bread in
 function affs_truncate
From: Nick Krause <xerofoify@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, viro@zeniv.linux.org.uk,
        fabf@skynet.be, kirill.shutemov@linux.intel.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think that it's a good idea , in that case I
would recommend either leaving this bug open
or close it as there doesn't seem to be a good
way of testing this.
Cheers Nick

On Fri, Jun 20, 2014 at 11:09 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 20 Jun 2014 22:55:07 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>
>> On Fri, Jun 20, 2014 at 10:38 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Fri, 20 Jun 2014 22:25:47 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>> >
>> >> If you have any ideas about what is better
>> >> please let me known.
>> >
>> > I think the proposed patch was not a good one - it will cause truncate
>> > to silently return, probably leaving the fs in an inconsistent state.
>> > Neither the user nor the running application know this happened so they
>> > will just keep on modifying the filesystem, possibly mangling it
>> > further.
>> >
>> > The code as it stands at present is better - if bread() fails we'll get
>> > a nice solid oops and the current app will be terminated (at least).
>> > As we're in truncate it's quite possible that the entire fs will get
>> > wedged up due to now-permanently-held i_mutex, which is even better.
>> >
>> >
>> > As for the best fix, umm, hard.  We're pretty screwed if we cannot read
>> > that block at this code site.  Perhaps emit loud printks, forcibly turn
>> > the fs read-only then return -EIO/-ENOMEM/etc from the truncate.  Such
>> > a change would require runtime testing, with some form of developer fault
>> > injection.
>>
>> Fair enough if somebody is running this file system I would be
>> happy to have someone test my code in order to fix this.
>
> (top-posting repaired - please don't top-post!)
>
> It's going to be hard to find such a person.  As mkfs.affs doesn't
> appear to exist (?) your best bet would be to find someone who has an
> Amiga, get them to create a new fs for you (via loopback-on-file) then
> gzip the underlying file and send it to you.  You can then use that fs
> image file as many times as you want via loopback or straight onto a
> disk.  Make sure the image file is zeroed out first so it compresses
> well.
>
> Or something like that.
