Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbaLKCRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:17:04 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40943 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:17:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
References: <alpine.DEB.2.11.1412091504490.16275@nanos>
Date: Wed, 10 Dec 2014 20:14:44 -0600
In-Reply-To: <alpine.DEB.2.11.1412091504490.16275@nanos> (Thomas Gleixner's
	message of "Tue, 9 Dec 2014 15:08:58 +0100 (CET)")
Message-ID: <877fxzexuz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+GdQuY0YuTfEAQpxLZKVpr0CDGdk7EByo=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4712]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 939 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 6 (0.7%), b_tie_ro: 4.6 (0.5%), parse: 1.59 (0.2%),
	extract_message_metadata: 16 (1.7%), get_uri_detail_list: 1.98 (0.2%),
	tests_pri_-1000: 7 (0.7%), tests_pri_-950: 1.47 (0.2%), tests_pri_-900: 1.17
	(0.1%), tests_pri_-400: 19 (2.0%), check_bayes: 18 (1.9%), b_tokenize: 6
	(0.6%), b_tok_get_all: 6 (0.7%), b_comp_prob: 1.88 (0.2%), b_tok_touch_all:
	2.1 (0.2%), b_finish: 0.70 (0.1%), tests_pri_0: 253 (27.0%), tests_pri_500:
	628 (66.9%), poll_dns_idle: 600 (63.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [GIT pull] x86 mpx support for 3.19
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> Linus,
>
> please pull the latest x86-mpx-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mpx-for-linus
>
> This enables support for x86 MPX:
>
>   MPX is a new debug feature for bound checking in user space. It
>   requires kernel support to handle the bound tables and decode the
>   bound violating instruction in the trap handler.

I some really dumb questions.

Given that mpx is both architecture and cpu specific why use prctl?
I would think arch_prctl would be a much more appropriate place to
expose this logic.

Why don't you have a call to let an application query to see if mpx
management is enabled?  I am trying to imagine how checkpoint/restart is
going to be supported for mpx applications.  If I can't even query if
mpx is enabled I don't have a clue how we could save this state and
duplicate it in another process on another machine.

> +Adding new prctl commands
> +-------------------------
> +
> +Two new prctl commands are added to enable and disable MPX bounds tables
> +management in kernel.
> +
> +155	#define PR_MPX_ENABLE_MANAGEMENT	43
> +156	#define PR_MPX_DISABLE_MANAGEMENT	44
> +
> +Runtime library in userspace is responsible for allocation of bounds
> +directory. So kernel have to use XSAVE instruction to get the base
> +of bounds directory from BNDCFG register.
> +
> +But XSAVE is expected to be very expensive. In order to do performance
> +optimization, we have to get the base of bounds directory and save it
> +into struct mm_struct to be used in future during PR_MPX_ENABLE_MANAGEMENT
> +command execution.
> +


Eric
