Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaHUNsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:48:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44794 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaHUNsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:48:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list\@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
	<87vbpm4f4y.fsf@x220.int.ebiederm.org>
	<20140821131257.GA4264@infradead.org>
Date: Thu, 21 Aug 2014 08:43:14 -0500
In-Reply-To: <20140821131257.GA4264@infradead.org> (Christoph Hellwig's
	message of "Thu, 21 Aug 2014 06:12:57 -0700")
Message-ID: <87y4uix8jx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18BxdxA1xc8fluxYhn5jNogl0yHZQIQifg=
X-SA-Exim-Connect-IP: 107.0.249.3
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4982]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Christoph Hellwig <hch@infradead.org>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Aug 20, 2014 at 09:53:49PM -0700, Eric W. Biederman wrote:
>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>> 
>> > On Wed, Aug 6, 2014 at 2:57 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> >
>> > This commit breaks libvirt-lxc.
>> > libvirt does in lxcContainerMountBasicFS():
>> 
>> The bugs fixed are security issues, so if we have to break a small
>> number of userspace applications we will.  Anything that we can
>> reasonably do to avoid regressions will be done.
>
> Can you explain the security issues in detail?  Breaking common
> userspace like libvirt-lxc with just a little bit of handwaiving is
> entirely unacceptable.

The biggies ability for an unprivileged user to clear nosuid, nodev,
read-only, noexec with remount.

Apparently part of what libvirt-lxc clearing all mount flags except for
read-only on some filesystem it remounts read-only.  Which if root
mounted the filesystem with nosuid, nodev, or noexec is not supportable.

So if it isn't the implicit setting of nodev on mount but not on remount
causing problems (which I have the trivial fix for) there is a strong
chance I need to break libvirt-lxc.

I am several bugs deep already where fixing one bug reveals yet another
bug.  It is possible there is something else that that I have not
discovered that I am missing.  I am more to happy to investigate to see
if it possible to avoid breaking libvirt-lxc.

Apologies for being a little vague being at the conference I only have
access to email about an hour a day.

Eric
