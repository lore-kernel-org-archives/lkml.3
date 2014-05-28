Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaE1Uey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:34:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39305 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaE1Uex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:34:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20140516140607.GA23902@ubuntu-hedt>
	<20140516185749.GA5131@kroah.com>
	<1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
	<20140516201841.GC23902@ubuntu-hedt>
	<87mwedfh7c.fsf@x220.int.ebiederm.org>
	<20140520142103.GC137220@ubuntu-hedt>
	<87y4xubxmm.fsf@x220.int.ebiederm.org>
	<20140521223319.GF29211@ubuntumail>
	<87ioow9ls9.fsf@x220.int.ebiederm.org>
	<20140528092655.GD19433@ubuntu-mba51>
	<20140528131259.GA31213@mail.hallyn.com>
Date: Wed, 28 May 2014 13:33:51 -0700
In-Reply-To: <20140528131259.GA31213@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 28 May 2014 15:12:59 +0200")
Message-ID: <87tx89od74.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+xQzTPpHrGvszMgY2w5VdY2dFyZb5a+10=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:
>> I was aware of FUSE but hadn't ever looked at it much. Looking at it
>> now, this isn't going to satisfy any of the use cases I know about,
>> which are wanting to use filesystems supported in-kernel (isofs, ext*).
>> I don't see that any of these have a FUSE implementation, and I think we
>> gain more from figuring out how to use in-kernel filesystems in
>> containers than trying to find a way to shoehorn selected filesystems
>> into FUSE.
>
> That's why I was wondering how much work it would be to auto-generate
> fuse fs support from the in-kernel source.

So at a quick look I have found fuseext2, fuseiso and mountlo-0.5 (which
claims to have supported all the in-kernel filesystems with the help of
user mode linux).

Give that the first two are just an apt-get install away fuse really
looks like the shortest path to being able to mount an iso, do other
interesting things.

We probably want something more but only when performance becomes a
bottle-neck.

Eric

