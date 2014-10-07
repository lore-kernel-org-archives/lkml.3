Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaJGUxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:53:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52163 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaJGUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:53:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Andrey Vagin <avagin@gmail.com>,
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
Date: Tue, 07 Oct 2014 13:52:35 -0700
In-Reply-To: <20141007204627.GI28519@ubuntumail> (Serge Hallyn's message of
	"Tue, 7 Oct 2014 20:46:27 +0000")
Message-ID: <87wq8bvbzg.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/T8KSgRkfiaKhwR/7bq8UIGEYsC/7i3ho=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2082]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 219 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.7 (1.2%), b_tie_ro: 1.88 (0.9%), parse: 0.61 (0.3%),
	extract_message_metadata: 14 (6.6%), get_uri_detail_list: 1.38 (0.6%),
	tests_pri_-1000: 8 (3.8%), tests_pri_-950: 1.00 (0.5%), tests_pri_-900: 0.84
	(0.4%), tests_pri_-400: 22 (10.2%), check_bayes: 21 (9.8%), b_tokenize: 4.9
	(2.2%), b_tok_get_all: 9 (3.9%), b_comp_prob: 1.71 (0.8%), b_tok_touch_all:
	3.7 (1.7%), b_finish: 0.60 (0.3%), tests_pri_0: 163 (74.6%), tests_pri_500:
	3.3 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Al Viro <viro@ZenIV.linux.org.uk> writes:
>> 
>> 2> On Tue, Oct 07, 2014 at 02:30:40PM +0100, Al Viro wrote:
>> >> On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
>> >> > Another problem is that rootfs can't be hidden from a container, because
>> >> > rootfs can't be moved or umounted.
>> >> 
>> >> ... which is a bug in mntns_install(), AFAICS.
>> >
>> > Ability to get to exposed rootfs, that is.
>> 
>> The container side of this argument is pretty bogus.  It only applies
>> if user namespaces are not used for the container.
>
> User namespaces are still far too restricted for many container use
> cases.  We can't say "we have user namespaces so now privileged
> containers can be ignored".  Yes you never should have handed the
> keys to a privileged container to an untrusted person, but we do
> still try to protect the host from accidental damage due to a
> privileged container.

What I meant is that it isn't about containers.   It is about something
root can do.  So this is not a "container" problem.

>> So it is only root (and not root in a container) who can get to the
>> exposed rootfs.
>> 
>> I have a vague memory someone actually had a real use in miminal systems
>> for being able to get back to the rootfs and being able to use rootfs as
>> the rootfs.  There was even a patch at that time that Andrew Morton was
>> carrying for a time to allow unmounting root and get at rootfs, and to
>> prevent the oops on rootfs unmount in some way.
>> 
>> So not only do I not think it is a bug to get back too rootfs, I think
>> it is a feature that some people have expressed at least half-way sane
>> uses for.
>
> They can still do that if they want, using chroot :)

It would take fchdir or fchroot and a directory file descriptor open on
rootfs.  Frequently there is no appropriate directory file descriptor.

Eric
