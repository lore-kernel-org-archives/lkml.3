Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaDYTiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:38:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40371 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaDYTiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:38:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
Date: Fri, 25 Apr 2014 12:37:29 -0700
In-Reply-To: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 25 Apr 2014 08:58:15 -0700")
Message-ID: <87ha5h42va.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/cd3ByQEg+WwOIk3Ef2yDcuc04om5TXMs=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1395]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: pid ns feature request
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> Unless I'm missing some trick, it's currently rather painful to mount
> a namespace /proc.  You have to actually be in the pid namespace to
> mount the correct /proc instance, and you can't unmount the old /proc
> until you've mounted the new /proc.  This means that you have to fork
> into the new pid namespace before you can finish setting it up.

Yes.  You have to be inside just about all namespaces before you can
finish setting them up.

I don't know the context in which needed to be inside the pid namespace
is a burden.

> Would it make sense to add a mount option to procfs to request a mount
> for pid_ns_for_children instead of task_active_pid_ns?

This is about the using setns and unshare?

Adding a proc amount option that takes a pid namespace file descriptor
would be the general solution, and might be worth implementing.

Getting a pid namespace file descriptors when there are no pids might be
a challenge.

Eric
