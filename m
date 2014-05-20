Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaETAF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:05:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45331 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaETAFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:05:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20140515040032.GA6702@kroah.com>
	<1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	<20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	<20140515221551.GB13306@kroah.com> <20140516014959.GD22591@ubuntumail>
	<20140516043532.GA14149@kroah.com>
	<20140516140607.GA23902@ubuntu-hedt> <20140516185749.GA5131@kroah.com>
	<1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
	<20140516201841.GC23902@ubuntu-hedt>
Date: Mon, 19 May 2014 17:04:55 -0700
In-Reply-To: <20140516201841.GC23902@ubuntu-hedt> (Seth Forshee's message of
	"Fri, 16 May 2014 15:18:41 -0500")
Message-ID: <87mwedfh7c.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1//plrXY38ZdSkMLZ/kDFOjoA+35PBxomg=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4180]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Seth Forshee <seth.forshee@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> What I set out for was feature parity between loop devices in a secure
> container and loop devices on the host. Since some operations currently
> check for system-wide CAP_SYS_ADMIN, the only way I see to accomplish
> this is to push knowledge of the user namespace farther down into the
> driver stack so the check can instead be for CAP_SYS_ADMIN in the user
> namespace associated with the device.
>
> That said, I suspect our current use cases can get by without these
> capabilities. Really though I suspect this is just deferring the
> discussion rather than settling it, and what we'll end up with is little
> more than a fancy way for userspace to ask the kernel to run mknod on
> its behalf.

A fancy way to ask the kernel to run mknod on its behalf is what
/dev/pts is.

When I suggested this I did not mean you should forgo making changes to
allow partitions and the like.  What I itended is that you should find a
way to make this safe for users who don't have root capabilities.

Which possibly means that mount needs to learn how to keep a more
privileged user from using your new loop devices.

To get to the point where this is really and truly usable I expect to be
technically daunting.

Ultimately the technical challenge is how do we create a block device
that is safe for a user who does not have any capabilities to use, and
what can we do with that block device to make it useful.

Only when the question is can this kernel functionality which is
otherwise safe confuse a preexisting setuid application do namespace
or container bits significantly come into play.

Eric
