Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaEQEcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:32:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50421 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaEQEcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:32:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@WittsEnd.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	<20140515013245.GA1764@kroah.com>
	<1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	<20140515031527.GA146352@ubuntu-hedt>
	<20140515040032.GA6702@kroah.com>
	<1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	<20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	<20140515221551.GB13306@kroah.com> <20140516014959.GD22591@ubuntumail>
	<20140516043532.GA14149@kroah.com>
Date: Fri, 16 May 2014 21:31:37 -0700
In-Reply-To: <20140516043532.GA14149@kroah.com> (Greg Kroah-Hartman's message
	of "Thu, 15 May 2014 21:35:32 -0700")
Message-ID: <87mwehgh5i.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18LuZfCm6Uty8IzRJP3XIzkPG+JPIG8BuQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3060]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
>> > I think having to pick and choose what device nodes you want in a
>> > container is a good thing.  Becides, you would have to do the same thing
>> > in the kernel anyway, what's wrong with userspace making the decision
>> > here, especially as it knows exactly what it wants to do much more so
>> > than the kernel ever can.
>> 
>> For 'real' devices that sounds sensible.  The thing about loop devices
>> is that we simply want to allow a container to say "give me a loop
>> device to use" and have it receive a unique loop device (or 3), without
>> having to pre-assign them.  I think that would be cleaner to do using
>> a pseudofs and loop-control device, rather than having to have a
>> daemon in userspace on the host farming those out in response to
>> some, I don't know, dbus request?
>
> I agree that loop devices would be nice to have in a container, and that
> the existing loop interface doesn't really lend itself to that.  So
> create a new type of thing that acts like a loop device in a container.
> But don't try to mess with the whole driver core just for a single type
> of device.

Yes. Something like devpts (without the newinstance option).  Built to
allow unprivileged users to create loopback devices.

There is still a huge kettle of fish in with verifying a filesystem is
safe from a hostile user that has acess to the block device while the
filesystem is mounted.

Having a few filesystems that are robust enough to trust with arbitrary
filesystem corruption would be very interesting.

I assume unprivileged and hostile users because if you trusted the real
root inside of your container this would not be an issue.

Eric
