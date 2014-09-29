Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaI2Xcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:32:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42141 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaI2Xcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:32:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrey Wagin <avagin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <CANaxB-z_h1zDU6Sdj2uAKrK5b_-W4ZWXF4=ti54Rb5QrWPjibQ@mail.gmail.com>
Date: Mon, 29 Sep 2014 16:32:22 -0700
In-Reply-To: <CANaxB-z_h1zDU6Sdj2uAKrK5b_-W4ZWXF4=ti54Rb5QrWPjibQ@mail.gmail.com>
	(Andrey Wagin's message of "Mon, 29 Sep 2014 13:10:50 +0400")
Message-ID: <87a95i57g9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18MAyBri5HQfF3+aQldota00ugJhKyadwM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3775]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrey Wagin <avagin@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2252 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.4 (0.2%), b_tie_ro: 2.4 (0.1%), parse: 0.72 (0.0%),
	extract_message_metadata: 12 (0.5%), get_uri_detail_list: 1.06 (0.0%),
	tests_pri_-1000: 5.0 (0.2%), tests_pri_-950: 1.29 (0.1%), tests_pri_-900:
	1.19 (0.1%), tests_pri_-400: 16 (0.7%), check_bayes: 15 (0.7%), b_tokenize:
	3.9 (0.2%), b_tok_get_all: 4.9 (0.2%), b_comp_prob: 2.0 (0.1%),
	b_tok_touch_all: 1.97 (0.1%), b_finish: 0.73 (0.0%), tests_pri_0: 2200
	(97.7%), tests_pri_500: 9 (0.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: Does MNT_LOCKED work as expected?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Wagin <avagin@gmail.com> writes:

> Hi All,
>
> I think I found a case, when MNT_LOCKED (5ff9d8a65ce8 "vfs: Lock in
> place mounts from more privileged users") doesn't help to hide
> overmounted parts from unprivileged users.

> The problem exists for mounts, which are not overmounted entirely. In
> such cases we can open a directory from a target mount, which is not
> overmounted. Then we do pivot_root to move all mounts in a temporary
> directory. At the final step we deatch all mounts from the temporary
> directory. After that all children mounts are umounted from the target
> mount and we can use our file descriptor to open files, which have
> been overmount before.
>
> Here is a example https://github.com/avagin/userns_vs_mntns.

I am looking at this now to make certain I am understand what you are
seeing but so far it looks like lazy unmounts allow you to bypass
MNT_LOCKED :(

Grumble.

Eric
