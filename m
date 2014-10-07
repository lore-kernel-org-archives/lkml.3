Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaJGXmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:42:45 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34545 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbaJGXmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:42:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<20141007133039.GG7996@ZenIV.linux.org.uk>
	<20141007133339.GH7996@ZenIV.linux.org.uk>
	<87r3yjy64e.fsf@x220.int.ebiederm.org>
	<20141007204627.GI28519@ubuntumail>
	<87wq8bvbzg.fsf@x220.int.ebiederm.org>
	<20141007213257.GJ28519@ubuntumail>
	<87zjd7r1z9.fsf@x220.int.ebiederm.org>
	<CALCETrVZNDTa3jc2HJ+_9sab+MhdXQ-rgNPHqT8qbDmJGXByBg@mail.gmail.com>
	<87h9zfpkm3.fsf@x220.int.ebiederm.org>
	<CALCETrWqD7j8d+0GYZeUMhf5PnZKmV0DGoHu49qo3tGx0TUnhg@mail.gmail.com>
Date: Tue, 07 Oct 2014 16:42:10 -0700
In-Reply-To: <CALCETrWqD7j8d+0GYZeUMhf5PnZKmV0DGoHu49qo3tGx0TUnhg@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 7 Oct 2014 15:44:26 -0700")
Message-ID: <87siizla5p.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19JhcV9WlQt1tOtn6wjDR3OeiiqFOhHhfI=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3413]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 477 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 5 (1.0%), parse: 1.38 (0.3%), extract_message_metadata:
	12 (2.4%), get_uri_detail_list: 3 (0.5%), tests_pri_-1000: 10 (2.1%),
	tests_pri_-950: 2 (0.4%), tests_pri_-900: 1.55 (0.3%), tests_pri_-400: 36
	(7.5%), check_bayes: 34 (7.2%), tests_pri_0: 399 (83.7%), tests_pri_500: 6
	(1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Oct 7, 2014 at 3:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Tue, Oct 7, 2014 at 2:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>
>>>> I am squinting and looking this way and that but while I can imagine
>>>> someone more clever than I can think up some unique property of rootfs
>>>> that makes it a little more exploitable than just mounting a ramfs,
>>>> but since you have to be root to exploit those properties I think the
>>>> game is pretty much lost.
>>>
>>> Yes.  rootfs might not be empty, it might have totally insane
>>> permissions, and it's globally shared, which makes it into a wonderful
>>> channel to pass things around that shouldn't be passed around.
>>
>> But if only root with proc mounted can reach it...  I don't know.
>
> It doesn't have to be global root.  It could be userns root.
>
>> There might be a case for setting MNT_LOCKED when we overmount "/"
>> as root but I don't yet see it.
>>
>>> Can non-root do this?  You'd need to be in a userns with a "/" that
>>> isn't MNT_LOCKED.  Can this happen on any normal setup?
>>>
>>> FWIW, I think we should unconditionally MNT_LOCKED the root on userns
>>> unshare, even if it's the only mount.
>>
>> To the best of my knowledge MNT_LOCKED is set uncondintially on userns
>> unshare.
>
> Only if list_empty(&old->mnt_expire), whatever that means, I think.

An autofs or nfs automounted mount.  Can those ever become root?

Eric
