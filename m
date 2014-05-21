Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaEUWBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:01:33 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37169 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaEUWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:01:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20140515140856.GA17453@kroah.com>
	<20140515174254.GM21073@ubuntumail> <20140515221551.GB13306@kroah.com>
	<20140516014959.GD22591@ubuntumail> <20140516043532.GA14149@kroah.com>
	<20140516140607.GA23902@ubuntu-hedt> <20140516185749.GA5131@kroah.com>
	<1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
	<20140516201841.GC23902@ubuntu-hedt>
	<87mwedfh7c.fsf@x220.int.ebiederm.org>
	<20140520142103.GC137220@ubuntu-hedt>
Date: Wed, 21 May 2014 15:00:33 -0700
In-Reply-To: <20140520142103.GC137220@ubuntu-hedt> (Seth Forshee's message of
	"Tue, 20 May 2014 09:21:03 -0500")
Message-ID: <87y4xubxmm.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18vRyFSOMYpE5NNXgKfd7uW3FXvK1UJGqo=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0218]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seth Forshee <seth.forshee@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> Ultimately the technical challenge is how do we create a block device
>> that is safe for a user who does not have any capabilities to use, and
>> what can we do with that block device to make it useful.
>
> Yes, and I'd like to get started solving those challenges. But I also
> don't think we can address these two points (support partition blkdevs,
> help prevent more priveleged users from using a namespace's loop
> devices) sufficiently while having an implementation completely
> contained within the loop driver as Greg is requesting.

My key take away from the conversation is that we should reduce the
scope of what is being done to something that makes sense and the
propblems are immediately visible.

Part of me would like to suggest that fuse and it's ability to imitate
device nodes might be a more appropriate solution, to something that
just needs block device access and nothing else.

For purposes of discussion let's call it unprivloopfs.  That can reuse
code from the loop device or not as appropriate.  Not supporting
paritioning I think is a very reasonable first step until it is shown
that we can make good use of partitioning support, and there are not
better ways of solving the problem.

I expect the most productive thing to talk about is what is your
immediate goal?  Mounting a filesystem?  Building an iso?

We have a long history with the namespace support of punting on issues
and not solving them until a long term maintainable solution becomes
clear.  Let's do what we can to make the problem and the solution clear.

Eric
