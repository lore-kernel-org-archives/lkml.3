Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaL3FmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:42:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33281 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaL3FmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:42:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
References: <1419330039-29207-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<1419330039-29207-3-git-send-email-chenhanxiao@cn.fujitsu.com>
Date: Mon, 29 Dec 2014 23:39:26 -0600
In-Reply-To: <1419330039-29207-3-git-send-email-chenhanxiao@cn.fujitsu.com>
	(Chen Hanxiao's message of "Tue, 23 Dec 2014 18:20:38 +0800")
Message-ID: <87k3191ysx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Rc8qZtwCQ9zlax0M4yUVETopNlzKfAgc=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  1.0 XM_Doc_Oz_Body BODY: Dr. Oz body dropper
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 767 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.9 (0.5%), b_tie_ro: 2.8 (0.4%), parse: 1.25 (0.2%),
	extract_message_metadata: 20 (2.6%), get_uri_detail_list: 2.5 (0.3%),
	tests_pri_-1000: 8 (1.0%), tests_pri_-950: 1.18 (0.2%), tests_pri_-900: 1.02
	(0.1%), tests_pri_-400: 21 (2.8%), check_bayes: 20 (2.6%), b_tokenize: 7
	(0.9%), b_tok_get_all: 7 (0.9%), b_comp_prob: 1.86 (0.2%), b_tok_touch_all:
	2.5 (0.3%), b_finish: 0.68 (0.1%), tests_pri_0: 701 (91.5%), tests_pri_500: 5
	(0.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [resend][PATCH v9 2/3] /proc/PID/status: show all sets of pid according to ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Hanxiao <chenhanxiao@cn.fujitsu.com> writes:

> If some issues occurred inside a container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
>
> This patch adds four fields: NStgid, NSpid, NSpgid and NSsid:
> a) In init_pid_ns, nothing changed;
>
> b) In one pidns, will tell the pid inside containers:
>   NStgid: 21776   5       1
>   NSpid:  21776   5       1
>   NSpgid: 21776   5       1
>   NSsid:  21729   1       0
>   ** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.
>
> c) If pidns is nested, it depends on which pidns are you in.
>   NStgid: 5       1
>   NSpid:  5       1
>   NSpgid: 5       1
>   NSsid:  1       0
>   ** Views from level 1
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
>
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

At a quick review and read through this looks good.  Once I finish
clearing the security bug fixes from my tree I will see about picking this
up.

Eric


> ---
> v9: rebased on 3.19-rc1
> No change from v4-v8
> v3: add another two fielsd: NSpgid and NSsid.
> v2: add two new fields: NStgid and NSpid.
>     keep fields of Tgid and Pid unchanged for back compatibility.
>
>  fs/proc/array.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index bd117d0..35205d4 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -208,6 +208,22 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
>  	put_cred(cred);
>  
> +	seq_puts(m, "\nNStgid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_tgid_nr_ns(p, pid->numbers[g].ns));
> +	seq_puts(m, "\nNSpid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_pid_nr_ns(p, pid->numbers[g].ns));
> +	seq_puts(m, "\nNSpgid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_pgrp_nr_ns(p, pid->numbers[g].ns));
> +	seq_puts(m, "\nNSsid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_session_nr_ns(p, pid->numbers[g].ns));
>  	seq_putc(m, '\n');
>  }
