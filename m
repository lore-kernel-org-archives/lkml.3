Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaJHAVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:21:30 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48253 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaJHAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:21:27 -0400
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
	<87siizla5p.fsf@x220.int.ebiederm.org>
	<CALCETrV-B=ahQ9mDdZkSQTGD1zmHcFQA0OyQxxwFC9Ei8Vsp4Q@mail.gmail.com>
Date: Tue, 07 Oct 2014 17:20:13 -0700
In-Reply-To: <CALCETrV-B=ahQ9mDdZkSQTGD1zmHcFQA0OyQxxwFC9Ei8Vsp4Q@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 7 Oct 2014 16:44:45 -0700")
Message-ID: <87vbnvif9e.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19YetbSOYycQFDi5NQsJJARYInrc2q6R5I=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3413]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 292 ms - load_scoreonly_sql: 0.09 (0.0%),
	signal_user_changed: 5.0 (1.7%), b_tie_ro: 3.4 (1.2%), parse: 1.42 (0.5%),
	extract_message_metadata: 19 (6.6%), get_uri_detail_list: 4.2 (1.4%),
	tests_pri_-1000: 5 (1.8%), tests_pri_-950: 1.04 (0.4%), tests_pri_-900: 0.85
	(0.3%), tests_pri_-400: 22 (7.6%), check_bayes: 21 (7.2%), b_tokenize: 6
	(2.1%), b_tok_get_all: 8 (2.7%), b_comp_prob: 2.3 (0.8%), b_tok_touch_all:
	2.6 (0.9%), b_finish: 0.85 (0.3%), tests_pri_0: 227 (77.7%), tests_pri_500: 7
	(2.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Oct 7, 2014 at 4:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Tue, Oct 7, 2014 at 3:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>
>>>>> On Tue, Oct 7, 2014 at 2:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>>
>>>>>> I am squinting and looking this way and that but while I can imagine
>>>>>> someone more clever than I can think up some unique property of rootfs
>>>>>> that makes it a little more exploitable than just mounting a ramfs,
>>>>>> but since you have to be root to exploit those properties I think the
>>>>>> game is pretty much lost.
>>>>>
>>>>> Yes.  rootfs might not be empty, it might have totally insane
>>>>> permissions, and it's globally shared, which makes it into a wonderful
>>>>> channel to pass things around that shouldn't be passed around.
>>>>
>>>> But if only root with proc mounted can reach it...  I don't know.
>>>
>>> It doesn't have to be global root.  It could be userns root.
>>>
>>>> There might be a case for setting MNT_LOCKED when we overmount "/"
>>>> as root but I don't yet see it.
>>>>
>>>>> Can non-root do this?  You'd need to be in a userns with a "/" that
>>>>> isn't MNT_LOCKED.  Can this happen on any normal setup?
>>>>>
>>>>> FWIW, I think we should unconditionally MNT_LOCKED the root on userns
>>>>> unshare, even if it's the only mount.
>>>>
>>>> To the best of my knowledge MNT_LOCKED is set uncondintially on userns
>>>> unshare.
>>>
>>> Only if list_empty(&old->mnt_expire), whatever that means, I think.
>>
>> An autofs or nfs automounted mount.  Can those ever become root?
>
> Dunno.
>
> I thought that this code was what set MNT_LOCKED for things that
> should be locked:

It does.

>     /* Don't allow unprivileged users to reveal what is under a mount */
>     if ((flag & CL_UNPRIVILEGED) && list_empty(&old->mnt_expire))
>         mnt->mnt.mnt_flags |= MNT_LOCKED;
>
> Now I'm confused.  Shouldn't that be checking for submounts?  Is that
> what it's doing?

As it copies each mount (mostly submounts) it sets MNT_LOCKED.

> Anyway, I think that this should unconditionally set MNT_LOCKED on the
> thing that mounted on rootfs.

As I read the code mnt_set_expiry is only for nfs, cifs, and afs
submounts (and perhaps proc should use them). So as they are generated
mnt_expiry should never start on the root of filesystem of the mount tree.

Furthermore mnt_expiry is cleared when a mount is moved, and when
it is bind mounted, or propagated.

pivot_root does look as though it may be missing the proper mnt_expiry
handling list_del_init(&old->mnt_expire), but pivot_root does have
proper MNT_LOCKED handling.

Looking that test was slightly off and it should be:
	if ((flag & CL_UNPRIVILEGED) &&
	    (!(flag & CL_EXPIRE) || list_empty(&old->mnt_expire))
		mnt->mnt.mnt_flags |= MNT_LOCKED;

So on that note we might clear CL_EXPIRE when CL_UNPRIVILEGED is set
in copy_tree but I don't see that as being really needed.

Eric
