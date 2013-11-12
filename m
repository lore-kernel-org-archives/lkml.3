Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3KLVwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:52:11 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:4559 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:52:08 -0500
Date: Tue, 12 Nov 2013 14:52:00 -0700
From: jerry.hoemann@hp.com
To: Pekka Enberg <penberg@kernel.org>
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131112215200.GB22363@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <CAOJsxLEoN2uYR9V3bowv2O7F8L5t+kVrdehHW151cEcfgx-oJg@mail.gmail.com>
 <20131112175500.GA22363@anatevka.fc.hp.com>
 <CAOJsxLEU1SPd=1C8QPgrZGWeOuyOVkozuMR014xBpJTxyFviKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEU1SPd=1C8QPgrZGWeOuyOVkozuMR014xBpJTxyFviKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:48:51PM +0200, Pekka Enberg wrote:
> Hi Jerry,
> 
> On Tue, Nov 12, 2013 at 7:55 PM,  <jerry.hoemann@hp.com> wrote:
> > My change does not address platforms that have misbehaving firmware.
> > It just allows platforms that don't have this issue to avoid issues
> > that the call to efi_reserve_boot_services presents.
> 
> The problem I have with your patch is that it (1) relies on users to
> pass a kernel option and (2) leaves machines with "faulty firmware" out
> in the cold.  So I'm wondering if we can fix reserve_crashkernel() to
> deal with reality that there indeed are broken firmware out there?
> 
> If someone is able to come up with a convincing argument why crashkernel
> cannot be fixed on such machines, we'd need to start whitelisting known
> good firmwares, no?
> 
>                            Pekka


Hi Pekka,

I'm cc'ing Matthew Garrett who has the background in the original
problem that efi_reserve_boot_services was used to work around.

Matthew, sorry for not CC'ing you initially.

Also, a more specific message from Matthew from the earlier thread:

	https://lkml.org/lkml/2013/8/7/750

I was anticipating this extended argument to be used by distros
that support servers.  While technically still a problem on smaller
systems, the crash kernel size requirement for larger systems makes
the issue much more apparent.  Also, having this in distros could help
enforce proper behaving platforms going forward as companies will
want to get their platforms certified.

I don't believe the proposed change "hurts" the platforms that
efi_reserve_boot_services was added to protect.  They'll function
as they do now,  they just shouldn't add the new argument.

I've conducted a couple test previously: https://lkml.org/lkml/2013/9/18/457.

Moving reserve crash_kernel after efi_free_boot_services failed.
While moving it before efi_reserve_boot_services seems to work,
this would also move it before trim_platform_memory_ranges, which I was
concerned would break other platforms.


If we were to go to a list method,  i'd rather we tried to define
the blacklist of platforms that require the efi_reserve_boot_services
workaround.

In testing new platforms, its much easier to assume that the platform works.
Only if it doesn't work, and the platform hardware/firmware defects
can't be fixed, then we can black list it.

The issue on how to work around EFI bugs before has been discussed,
but I don't recall seeing a resolution.  If I missed this, point
me in right direction.  :)

thanks

Jerry


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

