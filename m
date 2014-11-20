Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbaKTPQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:16:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54094 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbaKTPQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:16:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
Date: Thu, 20 Nov 2014 09:14:50 -0600
In-Reply-To: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
	(Josh Triplett's message of "Sat, 15 Nov 2014 23:08:32 -0800")
Message-ID: <87egsxnbth.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18nm1w+bzcyf9RI9UuGesBZQk1pLilfvxA=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4966]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Josh Triplett <josh@joshtriplett.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 740 ms - load_scoreonly_sql: 0.19 (0.0%),
	signal_user_changed: 18 (2.5%), b_tie_ro: 17 (2.3%), parse: 1.07 (0.1%),
	extract_message_metadata: 49 (6.6%), get_uri_detail_list: 1.25 (0.2%),
	tests_pri_-1000: 26 (3.5%), tests_pri_-950: 13 (1.8%), tests_pri_-900: 1.82
	(0.2%), tests_pri_-400: 63 (8.4%), check_bayes: 60 (8.1%), b_tokenize: 7
	(1.0%), b_tok_get_all: 33 (4.5%), b_comp_prob: 2.5 (0.3%), b_tok_touch_all:
	1.90 (0.3%), b_finish: 0.69 (0.1%), tests_pri_0: 544 (73.4%), tests_pri_500:
	20 (2.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] Add supplementary UIDs, and getusers/setusers system calls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> writes:

> Analogous to the supplementary GID list, the supplementary UID list
> provides a set of additional user credentials that a process can act as.
> A process with CAP_SETUID can set its UID list arbitrarily; a process
> without CAP_SETUID can only reduce its UID list.
>
> This allows each user to have a set of UIDs that they can then use to
> further sandbox individual child processes without first escalating to
> root to change UIDs.  For instance, a PAM module could give each user a
> block of UIDs to work with.

A couple of quick comments on this patch.

1) user namespaces already allow you to do this.

2) After having looked at the group case I am afraid this intersects in
   an unfortunate way with user namespaces.

3) This intersects in a very unfortunate way with setresuid.
   Applications that today know they are dropping all privileges
   won't be dropping all privielges with this change.  Which sounds like
   a recipe for a security exploit to me.

Eric
