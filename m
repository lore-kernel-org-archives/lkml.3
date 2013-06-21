Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423744Ab3FUTKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:10:51 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42645 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423726Ab3FUTKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130621185056.GA23473@kroah.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<20130621165142.GA32125@kroah.com>
	<51C48745.9030304@zytor.com>
	<CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
	<20130621185056.GA23473@kroah.com>
Date: Fri, 21 Jun 2013 12:10:48 -0700
X-Google-Sender-Auth: xdy0UzjGF0AHh6tdEMMqHZWSOHI
Message-ID: <CAE9FiQVt7Fa5oTYR+yLsehboPMo86vEDsRUaqNLQD9fizD5=Fg@mail.gmail.com>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Nathan Zimmer <nzimmer@sgi.com>,
        Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:50 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jun 21, 2013 at 11:44:22AM -0700, Yinghai Lu wrote:
>> On Fri, Jun 21, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 06/21/2013 09:51 AM, Greg KH wrote:
>> >
>> > I suspect the cutoff for this should be a lot lower than 8 TB even, more
>> > like 128 GB or so.  The only concern is to not set the cutoff so low
>> > that we can end up running out of memory or with suboptimal NUMA
>> > placement just because of this.
>>
>> I would suggest another way:
>> only boot the system with boot node (include cpu, ram and pci root buses).
>> then after boot, could add other nodes.
>
> What exactly do you mean by "after boot"?  Often, the boot process of
> userspace needs those additional cpus and ram in order to initialize
> everything (like the pci devices) properly.

I mean for Intel cpu have cpu and memory controller and IIO.
every IIO is one peer pci root bus.
So scan root bus that are not with boot node later.

in this way we can keep all numa etc on the place when online ram, cpu, pci...

For example if we have 32 sockets system, most time for boot is with *BIOS*
instead of OS. In those kind of system boot is like this way:
only first two sockets get booted from bios to OS.
later use hot add every other two sockets.

that will also make BIOS simpler, and it need to support hot-add for
services purpose anyway.

Yinghai
