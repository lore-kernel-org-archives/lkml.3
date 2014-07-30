Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaG3GZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:25:53 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51593 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaG3GZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:25:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Drysdale <drysdale@google.com>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
	<871tt796i0.fsf@x220.int.ebiederm.org>
	<CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA@mail.gmail.com>
	<87ha21qja0.fsf@x220.int.ebiederm.org>
	<CAHse=S_w4+AMuc=-XbAK_PiaD56_ks13R53RENMHif5KRN_Kiw@mail.gmail.com>
Date: Tue, 29 Jul 2014 23:22:01 -0700
In-Reply-To: <CAHse=S_w4+AMuc=-XbAK_PiaD56_ks13R53RENMHif5KRN_Kiw@mail.gmail.com>
	(David Drysdale's message of "Tue, 29 Jul 2014 11:58:21 +0100")
Message-ID: <87iomfgyd2.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX192xcS6SemSKnWGelvwlzrpmyt/Dy0Qhko=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;David Drysdale <drysdale@google.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have cut this down to just focus on O_BENEATH openat case.

David Drysdale <drysdale@google.com> writes:

> On Mon, Jul 28, 2014 at 10:13 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:

>> Nope.  What you can implement today if you want fine grained limitations
>> like this is to create a mount namespace with exactly the subdirectory
>> tree you want to allow access to and to return a file descriptor that
>> points into that mount namespace.  (When complete the only user of that
>> mount namespace would be your file descriptor).
>
> How does that solve the particular example I mentioned?  The DFD
> within the mount namespace will still allow any operation on any file
> that's already in the subdirectory -- or am I misunderstanding
> something?

The goal was to bound the DFD to the directory and all of it's
subdirectories such that openat(dfd, "../../..") would open
the dfd, and that further opens of other directories would also not
allow you to escape.

Since the mount namespace only contains the choosen directory and it's
subdirectories that works easily and trivially.

So while you can indeed perform any file operation on that dfd who
cares because none of those operations can get you anywhere you aren't
supposed to be.

My point was that you can as granular as you would like by binding a dfd
to a mount namespace instead of binding a process to a mount namespace,
and the code already exists and is being maintained.

So while things are not packaged in the form that has been requested it
looks to me as if the functionality for directories already exists
within the Linux kernel.

Eric
