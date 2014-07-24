Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbaGXBzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:55:10 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52581 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbaGXBzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:55:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kamal Mostafa <kamal@canonical.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
	<1406067727-19683-77-git-send-email-kamal@canonical.com>
	<20140722231257.GT4453@dastard> <1406149558.3612.37.camel@fourier>
Date: Wed, 23 Jul 2014 18:51:23 -0700
In-Reply-To: <1406149558.3612.37.camel@fourier> (Kamal Mostafa's message of
	"Wed, 23 Jul 2014 14:05:58 -0700")
Message-ID: <87iomnle1w.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/ds1wuMSkLPofjJZGWZRg+IPb40ufT/wo=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4500]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Kamal Mostafa <kamal@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3.8 076/116] xfs: ioctl check for capabilities in the current user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamal Mostafa <kamal@canonical.com> writes:

> On Wed, 2014-07-23 at 09:12 +1000, Dave Chinner wrote:
>> On Tue, Jul 22, 2014 at 03:21:27PM -0700, Kamal Mostafa wrote:
>> > 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
>> > 
>> > ------------------
>> > 
>> > From: Dwight Engen <dwight.engen@oracle.com>
>> > 
>> > commit fd5e2aa8653665ae1cc60f7aca1069abdbcad3f6 upstream.
>> > 
>> > Use inode_capable() to check if SUID|SGID bits should be cleared to match
>> > [...]
>> 
>> Why are you backporting this to 3.8? namespace support didn't come
>> along until much later, so grabbing one patch out of themiddle of a
>> patch series to allow userns support in XFS is likely to cause
>> problems because there's no supporting code in XFS it.
>> 
>> Please don't randomly cherry pick userns support patches that change
>> permission checks back into kernels that don't have userns support.
>
> Yup, that's why we ask for reviews all right!  I've dropped these from
> the 3.8-stable queue:
>
>     fs,userns: Change inode_capable to capable_wrt_inode_uidgid

The fs,userns: Chage inode_capable to capable_wrt_inode_uidgid is
appropriate for 3.8.  I think that one is applicable all of the way
back to 3.4

I don't know if xfs in 3.8 called inode_capable in xfs and if it didn't
you can remove that hunk.  To keep things very simple you could just
skip the rename of inode_capable to capable_wrt_uidgid and just
include the one line change to add kgid_has_mapping.

But that bug fix is very much applicable to older kernels.

Eric
