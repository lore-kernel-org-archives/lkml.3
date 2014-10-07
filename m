Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaJGU6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:58:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54734 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaJGU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:58:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Vagin <avagin@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <1412683212-28077-1-git-send-email-avagin@openvz.org>
	<20141007132431.GF7996@ZenIV.linux.org.uk>
	<20141007134011.GA569@paralelels.com>
	<87vbnv3cl1.fsf_-_@x220.int.ebiederm.org>
	<20141007195307.GA23694@paralelels.com>
Date: Tue, 07 Oct 2014 13:58:01 -0700
In-Reply-To: <20141007195307.GA23694@paralelels.com> (Andrew Vagin's message
	of "Tue, 7 Oct 2014 23:53:07 +0400")
Message-ID: <87iojvvbqe.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1875u2h1Ss0X5D4M63nK66THb2VEnQlrnQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3732]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Vagin <avagin@parallels.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 302 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 4.7 (1.6%), b_tie_ro: 2.2 (0.7%), parse: 1.11 (0.4%),
	extract_message_metadata: 19 (6.2%), get_uri_detail_list: 1.43 (0.5%),
	tests_pri_-1000: 8 (2.6%), tests_pri_-950: 1.96 (0.6%), tests_pri_-900: 1.80
	(0.6%), tests_pri_-400: 23 (7.5%), check_bayes: 21 (7.0%), b_tokenize: 7
	(2.3%), b_tok_get_all: 6 (2.1%), b_comp_prob: 2.5 (0.8%), b_tok_touch_all:
	2.8 (0.9%), b_finish: 0.71 (0.2%), tests_pri_0: 234 (77.3%), tests_pri_500: 5
	(1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] umount:  Do not allow unmounting rootfs.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Vagin <avagin@parallels.com> writes:

> On Tue, Oct 07, 2014 at 12:27:06PM -0700, Eric W. Biederman wrote:
>> 
>> Which in practice is totally uninteresting.  Only the global root user can
>> do it, and it is just a stupid thing to do.
>> 
>> However that is no excuse to allow a silly way to oops the kernel.
>> 
>> We can avoid this silly problem by setting MNT_LOCKED on the rootfs
>> mount point and thus avoid needing any special cases in the unmount
>> code.
>
> I had this idea too, but it doesn't work.
>
> MNT_LOCKED isn't inherited, if the privileged user creates a new mount
> namespace.
>
> So "unshame -m ./nsenter" reproduces the same BUG.

Which broken tree do you have where MNT_LOCKED is not inherited?

That case fails to reproduce the BUG for me.

The semantics of MNT_LOCKED are that you aren't allowed to see what is
beneath.  So if you can get under there even by unsharing the mount
namespace it is an implementation bug in MNT_LOCKED.

Eric
