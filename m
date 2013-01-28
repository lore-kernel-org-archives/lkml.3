Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3A1IOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:14:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42671 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3A1IOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:14:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
References: <87ehh8it9s.fsf@xmission.com> <87txq4hedl.fsf@xmission.com>
	<51062AB5.9060203@parallels.com> <51062DA8.1060804@parallels.com>
Date: Mon, 28 Jan 2013 00:14:30 -0800
In-Reply-To: <51062DA8.1060804@parallels.com> (Lord Glauber Costa of Sealand's
	message of "Mon, 28 Jan 2013 11:50:00 +0400")
Message-ID: <87k3qxu3kp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/KK7gQiU7Csgq75dOHpnnNAMeEieBbkI4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1356]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lord Glauber Costa of Sealand <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 3/6] userns: Recommend use of memory control groups.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lord Glauber Costa of Sealand <glommer@parallels.com> writes:

> I just saw in a later patch of yours that your concern here seems not
> limited to backed ram by tmpfs, but with things like the internal
> structures for userns , to avoid patterns in the form: 'for (;;)
> unshare(...)'
>
> Humm, it does seem sensible. The kernel memory controller aims to
> prevent exactly things like that. But they all exist already before
> userns: there are destructive patterns like that with sockets, dentries,
> processes, and pretty much every other resource in the kernel. So
> Although the recommendation per-se makes sense, I am wondering if it is
> worth it to mention anything in the user_ns config?

The config might be overkill.  However I have already gotten bug reports
about there being no limits.

So someone needs to stop and connect the dots and say: "If you care this
is what you can do."  Especially since the familiar old limits that can
kind of sort of prevent memory abuses are not generally available with
user namespaces.

Eric

