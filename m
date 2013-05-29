Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3E2FWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:22:34 -0400
Received: from etrn.xmission.com ([198.60.22.17]:56885 "EHLO etrn.xmission.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab3E2FWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:22:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
References: <20130527202751.GA19250@redhat.com>
Date: Tue, 28 May 2013 22:22:12 -0700
In-Reply-To: <20130527202751.GA19250@redhat.com> (Oleg Nesterov's message of
	"Mon, 27 May 2013 22:27:51 +0200")
Message-ID: <87fvx61htn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19yw9jwRgcCB0VVTSI80HAr1FZ+EPdu0s0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1427]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/3] proc: first_tid() fix/cleanup
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Hello.
>
> next_thread() should be avoided, probably next_tid() is the
> only "valid" user.
>
> But now we have another reason to avoid (and probably even kill)
> it, we are going to replace or fix while_each_thread(), almost
> every lockless usage is wrong.
>
> I was going to send more changes, but this initial series nearly
> killed me. And I think first_tid() needs another cleanup, ->f_pos
> truncation doesn't look nice, tomorrow.

I have made some comments but overall this looks like a good set of
cleanups.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

As for f_pos truncation if you want you can safely check
if f_pos is greater than PID_MAX_LIMIT as we will never more
threads than we have pids.

Eric
