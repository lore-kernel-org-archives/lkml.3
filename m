Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaK2Dfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 22:35:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59583 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaK2Dfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 22:35:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
Date: Fri, 28 Nov 2014 21:34:09 -0600
In-Reply-To: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Fri, 28 Nov 2014 15:05:01 -0800")
Message-ID: <87mw7aof2m.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18M5DavvoWsAeoj0/tyG0SKJoykj5x3AwI=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4230]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 398 ms - load_scoreonly_sql: 0.09 (0.0%),
	signal_user_changed: 3.5 (0.9%), b_tie_ro: 2.6 (0.7%), parse: 0.63 (0.2%),
	extract_message_metadata: 11 (2.7%), get_uri_detail_list: 0.81 (0.2%),
	tests_pri_-1000: 4.7 (1.2%), tests_pri_-950: 1.25 (0.3%), tests_pri_-900:
	1.04 (0.3%), tests_pri_-400: 15 (3.7%), check_bayes: 14 (3.4%), b_tokenize:
	3.8 (1.0%), b_tok_get_all: 5.0 (1.2%), b_comp_prob: 1.35 (0.3%),
	b_tok_touch_all: 1.81 (0.5%), b_finish: 0.57 (0.1%), tests_pri_0: 352 (88.5%),
	 tests_pri_500: 7 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> Pid reuse is common, which means that it's difficult or impossible
> to read information about a pid from /proc without races.

Sigh.

What we need are not race free pids, but a file descriptor based process
management api.  Possibly one that starts by handing you a proc
directory.

Which probably means that we need a proc file we can write to and send
signals to a process, and another proc file we can select on and wait
for the process to exit.

Making pids bigger just looks like bandaid.

Remember evovle things in the direction of an object capability system
things wind up being more maintainable.

Eric
