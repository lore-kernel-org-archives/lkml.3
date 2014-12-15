Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbaLORdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:33:35 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:41887 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaLORdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:33:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Huang Ying <ying.huang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
References: <1418613661.5745.164.camel@intel.com>
Date: Mon, 15 Dec 2014 11:31:10 -0600
In-Reply-To: <1418613661.5745.164.camel@intel.com> (Huang Ying's message of
	"Mon, 15 Dec 2014 11:21:01 +0800")
Message-ID: <87iohcx1k1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ey+51poD0uyFx8x/BBdLZvepiwJrckVQ=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Huang Ying <ying.huang@intel.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 220 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 4.8 (2.2%), b_tie_ro: 2.5 (1.1%), parse: 0.68 (0.3%),
	extract_message_metadata: 11 (5.2%), get_uri_detail_list: 1.16 (0.5%),
	tests_pri_-1000: 5 (2.5%), tests_pri_-950: 1.27 (0.6%), tests_pri_-900: 1.03
	(0.5%), tests_pri_-400: 17 (7.8%), check_bayes: 16 (7.2%), b_tokenize: 4.1
	(1.9%), b_tok_get_all: 6 (2.6%), b_comp_prob: 1.65 (0.7%), b_tok_touch_all:
	2.1 (1.0%), b_finish: 0.64 (0.3%), tests_pri_0: 171 (77.8%), tests_pri_500:
	4.0 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [LKP] [userns] BUG: unable to handle kernel NULL pointer dereference at (null)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

> FYI, we noticed the below changes on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> commit bbea5f5532501fdd67f46442ba7b1122d7ff3123 
> ("userns: Add a knob to disable setgroups on a per user namespace basis")

Thank you.

I am quite puzzled by this failure.  There was an similar failure when
/proc/[pid]/setgroups was read (if I recall correctly).  I don't see how
that change could result at failures during open or failures during
boot.  I added a new file to proc which any reasonable system should
leave alone.  Are you by chance running trinity during boot?

If the reproducer gave me any clue about which file that was opened or
which code path this happened on I would be bery interested.  If for no
other reason that to confirm that I have fixed the issue.

I have rewritten the implementation of /proc/[pid]/setgroups so it is
simpler and more robust and does not have any errors I can detect.

Thank you very much for picking up my for-testing branch and beating up
on it.

Eric
