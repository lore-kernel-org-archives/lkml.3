Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaHEDqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:46:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51413 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaHEDqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:46:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name>
Date: Mon, 04 Aug 2014 20:42:11 -0700
In-Reply-To: <1407010227-2269-1-git-send-email-kirill@shutemov.name> (Kirill
	A. Shutemov's message of "Sat, 2 Aug 2014 23:10:27 +0300")
Message-ID: <87d2cfzjos.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18/8kJFM5AUjK5/ENUA/SM3D3UJ2h9XqwA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4786]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Kirill A. Shutemov" <kirill@shutemov.name>
X-Spam-Relay-Country: 
Subject: Re: [PATCH, RESEND] procfs: silence lockdep warning about read vs. exec seq_file
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Testcase:
>
>   cat /proc/self/maps >/dev/null
>   chmod +x /proc/self/net/packet
>   exec /proc/self/net/packet
>
> It triggers lockdep warning:

> I don't know why we allow "chmod +x" on some proc files, notably net-related.
> Is it a bug?

It looks like we simply did not remove the ability to make those files
executable when we realized executable proc files could be a problem.

I expect that part of proc could use an audit where someone figures out
what makes sense.  It does appear that chmod XXX /proc/generic_file
is explicitly supported.  So we would have to be delicate with any
changes in that area to avoid creating userspace regressions.

Eric
