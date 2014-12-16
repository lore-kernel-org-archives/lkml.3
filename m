Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaLPEnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:43:03 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60793 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaLPEnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:43:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20141216142109.4a67e8b0@canb.auug.org.au>
Date: Mon, 15 Dec 2014 22:40:37 -0600
In-Reply-To: <20141216142109.4a67e8b0@canb.auug.org.au> (Stephen Rothwell's
	message of "Tue, 16 Dec 2014 14:21:09 +1100")
Message-ID: <878ui8urzu.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+3D7zguAK1TtYioarHROCxK8MTwQyKvrQ=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
X-Spam-Timing: total 278 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.6 (0.9%), b_tie_ro: 1.92 (0.7%), parse: 0.52 (0.2%),
	extract_message_metadata: 9 (3.2%), get_uri_detail_list: 0.67 (0.2%),
	tests_pri_-1000: 3.7 (1.3%), tests_pri_-950: 1.00 (0.4%), tests_pri_-900:
	0.81 (0.3%), tests_pri_-400: 13 (4.7%), check_bayes: 12 (4.4%), b_tokenize:
	3.1 (1.1%), b_tok_get_all: 4.3 (1.5%), b_comp_prob: 1.18 (0.4%),
	b_tok_touch_all: 1.94 (0.7%), b_finish: 0.59 (0.2%), tests_pri_0: 151 (54.1%),
	 tests_pri_500: 94 (33.9%), poll_dns_idle: 86 (31.1%), rewrite_mail: 0.00
	(0.0%)
Subject: Re: linux-next: manual merge of the userns tree with the vfs tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> Today's linux-next merge of the userns tree got a conflict in
> kernel/user_namespace.c between commits 3c0411846118 ("switch the rest
> of proc_ns_operations to working with &...->ns") and 64964528b24e
> ("make proc_ns_operations work with struct ns_common * instead of void
> *") from the vfs tree and commits 273d2c67c3e1 ("userns: Don't allow
> setgroups until a gid mapping has been setablished") and 9cc46516ddf4
> ("userns: Add a knob to disable setgroups on a per user namespace
> basis") from the userns tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The fix is fine.

It might be a hair better if to_user_ns was below the code I added,
but it doesn't affect functionality so it doesn't matter.

Eric

