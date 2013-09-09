Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3IIGwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:52:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58516 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3IIGww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:52:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kaluza <jkaluza@redhat.com>
Cc: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, eparis@redhat.com, rgb@redhat.com
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
	<1377614400-27122-3-git-send-email-jkaluza@redhat.com>
Date: Sun, 08 Sep 2013 23:52:44 -0700
In-Reply-To: <1377614400-27122-3-git-send-email-jkaluza@redhat.com> (Jan
	Kaluza's message of "Tue, 27 Aug 2013 16:39:59 +0200")
Message-ID: <878uz6bi6b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1956zg2NCySV16xWLYsINdE1Pq9l9RVmSc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2311]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Kaluza <jkaluza@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] Send comm and cmdline in SCM_PROCINFO
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kaluza <jkaluza@redhat.com> writes:

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Whatever the benefits of the other pieces of information sending the
process command line is absolutely wrong.  It is a just a random string
from user space and there is absolutely no benefit in sending it in a
kernel verified way.  The process can just as easily pass the
information in userspace directly.

Furthermore the implementation of scm_get_current_procinfo is so far
from idiomatic for reading information about the current process that I
think it is fair to call it broken.

Eric
