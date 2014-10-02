Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaJBTdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:33:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37493 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaJBTdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:33:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
References: <542D5726.8070308@6wind.com>
	<1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412257690-31253-2-git-send-email-nicolas.dichtel@6wind.com>
Date: Thu, 02 Oct 2014 12:33:22 -0700
In-Reply-To: <1412257690-31253-2-git-send-email-nicolas.dichtel@6wind.com>
	(Nicolas Dichtel's message of "Thu, 2 Oct 2014 15:48:07 +0200")
Message-ID: <87tx3mmflp.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/4hqNOLXqzCTN+TEeJKIxbFDz3oGGHlAw=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2975]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Nicolas Dichtel <nicolas.dichtel@6wind.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 189 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.6 (1.4%), b_tie_ro: 1.83 (1.0%), parse: 0.81 (0.4%),
	extract_message_metadata: 15 (7.8%), get_uri_detail_list: 0.69 (0.4%),
	tests_pri_-1000: 7 (3.6%), tests_pri_-950: 1.40 (0.7%), tests_pri_-900: 1.18
	(0.6%), tests_pri_-400: 15 (8.1%), check_bayes: 14 (7.5%), b_tokenize: 4.8
	(2.5%), b_tok_get_all: 4.3 (2.3%), b_comp_prob: 1.65 (0.9%), b_tok_touch_all:
	1.76 (0.9%), b_finish: 0.57 (0.3%), tests_pri_0: 139 (73.6%), tests_pri_500:
	3.6 (1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH net-next v3 1/4] netns: add genl cmd to add and get peer netns ids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:

> With this patch, a user can define an id for a peer netns by providing a FD or a
> PID. These ids are local to netns (ie valid only into one netns).
>
> This will be useful for netlink messages when a x-netns interface is
> dumped.

You have a "id -> struct net *" table but you don't have a 
"struct net * -> id" table which looks like it will impact the
performance of peernet2id at scale.

Eric
