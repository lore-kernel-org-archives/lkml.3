Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaHFS01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:26:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48828 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaHFS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:26:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        linux-kernel@vger.kernel.org
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<87bns5cakh.fsf@x220.int.ebiederm.org>
	<20140806143500.GA23127@mail.hallyn.com>
Date: Wed, 06 Aug 2014 11:22:25 -0700
In-Reply-To: <20140806143500.GA23127@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 6 Aug 2014 16:35:00 +0200")
Message-ID: <871tsttr4u.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/0Hr9SWhFNcx0KFuq5L20/QUMbJy8LzU8=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1581]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 2/4] proc: Implement /proc/thread-self to point at the directory of the current thread
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Eric,
>
> I've not had a chance to test these, but apart from two trivial
> comments below these look good to me, and I appreciate the feature.
> So with the two fixes (if needed),
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

>> +static int proc_thread_self_readlink(struct dentry *dentry, char __user *buffer,
>> +			      int buflen)
>> +{
>> +	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
>> +	pid_t tgid = task_tgid_nr_ns(current, ns);
>> +	pid_t pid = task_pid_nr_ns(current, ns);
>> +	char tmp[PROC_NUMBUF + 6 + PROC_NUMBUF];
>
> In the extreme case you're not adding space for a \0 ?  (Unless
> PROC_NUMBUF includes that)

PROC_NUMBUF has enough space for a sign for the maximum of 10 digits
for a newline and a terminating \0.  So yes PROC_NUMBUF includes the
space for a terminating \0.

Eric
