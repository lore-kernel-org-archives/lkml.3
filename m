Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaJNUBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:01:49 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58856 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbaJNUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:01:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael j Theall <mtheall@us.ibm.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
	<1413296756-25071-5-git-send-email-seth.forshee@canonical.com>
	<OFD40DA8DF.F78EA39D-ON86257D71.0057C4DC-86257D71.0064055D@us.ibm.com>
Date: Tue, 14 Oct 2014 13:01:02 -0700
In-Reply-To: <OFD40DA8DF.F78EA39D-ON86257D71.0057C4DC-86257D71.0064055D@us.ibm.com>
	(Michael j. Theall's message of "Tue, 14 Oct 2014 13:12:26 -0500")
Message-ID: <878ukis9oh.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/zfDr764M6os8cVALv+C+Ckp20t6WnnIQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4993]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michael j Theall <mtheall@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 398 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 2.9 (0.7%), b_tie_ro: 1.96 (0.5%), parse: 1.09 (0.3%),
	extract_message_metadata: 27 (6.8%), get_uri_detail_list: 3.4 (0.8%),
	tests_pri_-1000: 9 (2.2%), tests_pri_-950: 1.27 (0.3%), tests_pri_-900: 1.06
	(0.3%), tests_pri_-400: 23 (5.9%), check_bayes: 22 (5.6%), b_tokenize: 6
	(1.5%), b_tok_get_all: 7 (1.9%), b_comp_prob: 2.2 (0.5%), b_tok_touch_all:
	2.5 (0.6%), b_finish: 0.64 (0.2%), tests_pri_0: 325 (81.8%), tests_pri_500:
	4.0 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs only	with a mount option
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael j Theall <mtheall@us.ibm.com> writes:

> Seth Forshee <seth.forshee@canonical.com> wrote on 10/14/2014 09:25:55 AM:
>
>> From: Seth Forshee <seth.forshee@canonical.com>
>> To: Miklos Szeredi <miklos@szeredi.hu>
>> Cc: fuse-devel@lists.sourceforge.net, "Serge H. Hallyn" 
>> <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, Seth 
>> Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" 
>> <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org
>> Date: 10/14/2014 09:27 AM
>> Subject: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs
>> only with a mount option
>> 
>> Allowing unprivileged users to provide arbitrary xattrs via fuse
>> mounts bypasses the normal restrictions on setting xattrs. Such
>> mounts should be restricted to reading and writing xattrs in the
>> user.* namespace.
>> 
>
> Can you explain how the normal restrictions on setting xattrs are 
> bypassed?

If the fuse server is not run by root.  Which is a large part of the
point of fuse.

> My filesystem still needs security.* and system.*, and it looks like
> xattr_permission already prevents non-privileged users from accessing
> trusted.*

If the filesystem is mounted with nosuid (typical of a non-privileged
mount of fuse) then the security.* attributes are ignored.

>> It's difficult though to tell whether a mount is being performed
>> on behalf of an unprivileged user since fuse mounts are ususally
>> done via a suid root helper. Thus a new mount option,
>> privileged_xattrs, is added to indicated that xattrs from other
>> namespaces are allowed. This option can only be supplied by
>> system-wide root; supplying the option as an unprivileged user
>> will cause the mount to fail.
>
> I can't say I'm convinced that this is the right direction to head.

With respect to defaults we could keep the current default if you
have the global CAP_SYS_ADMIN privilege when the mount takes place
and then avoid breaking anything.

Eric
