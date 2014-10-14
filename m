Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaJNVNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:13:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39118 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaJNVNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:13:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael j Theall <mtheall@us.ibm.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
	<1413296756-25071-5-git-send-email-seth.forshee@canonical.com>
	<OFD40DA8DF.F78EA39D-ON86257D71.0057C4DC-86257D71.0064055D@us.ibm.com>
	<878ukis9oh.fsf@x220.int.ebiederm.org>
	<20141014205955.GA10908@ubuntu-mba51>
Date: Tue, 14 Oct 2014 14:13:08 -0700
In-Reply-To: <20141014205955.GA10908@ubuntu-mba51> (Seth Forshee's message of
	"Tue, 14 Oct 2014 22:59:55 +0200")
Message-ID: <877g02pd7f.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18QXonrdQbV17HqHSrhlzQx+gGCJbhiB9Y=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4989]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMHurry_00 Hurry and Do Something
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Michael j Theall <mtheall@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 374 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 5 (1.4%), b_tie_ro: 4.5 (1.2%), parse: 0.66 (0.2%),
	extract_message_metadata: 18 (4.7%), get_uri_detail_list: 2.5 (0.7%),
	tests_pri_-1000: 9 (2.3%), tests_pri_-950: 1.03 (0.3%), tests_pri_-900: 0.85
	(0.2%), tests_pri_-400: 28 (7.4%), check_bayes: 26 (7.1%), b_tokenize: 7
	(1.8%), b_tok_get_all: 11 (3.0%), b_comp_prob: 3.6 (1.0%), b_tok_touch_all:
	2.5 (0.7%), b_finish: 0.59 (0.2%), tests_pri_0: 306 (81.8%), tests_pri_500:
	4.0 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs only with a mount option
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Tue, Oct 14, 2014 at 01:01:02PM -0700, Eric W. Biederman wrote:
>> Michael j Theall <mtheall@us.ibm.com> writes:
>> 
>> > Seth Forshee <seth.forshee@canonical.com> wrote on 10/14/2014 09:25:55 AM:
>> >
>> >> From: Seth Forshee <seth.forshee@canonical.com>
>> >> To: Miklos Szeredi <miklos@szeredi.hu>
>> >> Cc: fuse-devel@lists.sourceforge.net, "Serge H. Hallyn" 
>> >> <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, Seth 
>> >> Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" 
>> >> <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org
>> >> Date: 10/14/2014 09:27 AM
>> >> Subject: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs
>> >> only with a mount option
>> >> 
>> >> Allowing unprivileged users to provide arbitrary xattrs via fuse
>> >> mounts bypasses the normal restrictions on setting xattrs. Such
>> >> mounts should be restricted to reading and writing xattrs in the
>> >> user.* namespace.
>> >> 
>> >
>> > Can you explain how the normal restrictions on setting xattrs are 
>> > bypassed?
>> 
>> If the fuse server is not run by root.  Which is a large part of the
>> point of fuse.
>
> So the server could for example return trusted.* xattrs which were not
> set by a privileged user.
>
>> > My filesystem still needs security.* and system.*, and it looks like
>> > xattr_permission already prevents non-privileged users from accessing
>> > trusted.*
>> 
>> If the filesystem is mounted with nosuid (typical of a non-privileged
>> mount of fuse) then the security.* attributes are ignored.
>
> That I wasn't aware of. In fact I still haven't found where this
> restriction is implemented.

My memory may be have been incomplete.  What I was thinking of is
security/commoncap.c the MNT_NOSUID check in get_file_caps.

Upon inspection that appears limited to file capabilities, and while
there are a few other MNT_NOSUID checks under security the feel far from
complete.

Sigh.

This deserves a hard look because if MNT_NOSUID is not sufficient than
it may be possible for me to insert a usb stick with an extN filesystem
with the right labels having it auto-mounted nosuid and subvert the
security of something like selinux.

> Nonetheless, a userns mount could be done without nosuid (though that
> mount will also be unaccessible outside of that namespace).
>
>> >> It's difficult though to tell whether a mount is being performed
>> >> on behalf of an unprivileged user since fuse mounts are ususally
>> >> done via a suid root helper. Thus a new mount option,
>> >> privileged_xattrs, is added to indicated that xattrs from other
>> >> namespaces are allowed. This option can only be supplied by
>> >> system-wide root; supplying the option as an unprivileged user
>> >> will cause the mount to fail.
>> >
>> > I can't say I'm convinced that this is the right direction to head.
>> 
>> With respect to defaults we could keep the current default if you
>> have the global CAP_SYS_ADMIN privilege when the mount takes place
>> and then avoid breaking anything.
>
> Except that unprivileged mounts are normally done by a suid root helper,
> which is why I've required both global CAP_SYS_ADMIN and a mount option
> to get the current default behavior.

If nosuid is sufficient that may break existing setups for no good
reason.

Shrug.  I won't have much time for a bit but I figured I would highlight
the potential security hole in existing setups.  So someone with time
this week can look at that.

Eric

