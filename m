Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3J3W5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:57:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58386 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3J3W5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:57:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <8761sexu2l.fsf@xmission.com> <20131030224444.GA9092@kroah.com>
Date: Wed, 30 Oct 2013 15:57:37 -0700
In-Reply-To: <20131030224444.GA9092@kroah.com> (Greg Kroah-Hartman's message
	of "Wed, 30 Oct 2013 15:44:44 -0700")
Message-ID: <87vc0etli6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19j5cWxfVMdQZnL//Xu70sN1PWGXm2NZcA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0296]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: WTF: driver-core-next contains recursive directory removal!
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> I don't think there's an issue here, otherwise both Tejun and I would
> have found some issues during testing, same for all of the other
> linux-next users for the past few weeks.

There issues were subtle and hard to detect especially without
instrumenting the code during pci hotplug to look for them.  Memory
leaks, use after free, and needing pci hotplug to reproduce them made
the kinds of bugs I saw when I was working with it easy to go unnoticed
in light testing.

Beyond that the code has the deep issue that the code breaks normal
filesystem expectations in a way that is certain to confuse filesystem
people like Al Viro.

And yes that code being at all recursive is one of the things that Viro
objected to when you had him review sysfs before merging my cleanups
long ago.

Recursive removal is absolutely unnecessary, and it hides bugs, and
makes the code unnecessarily complex for no good reason.

Eric
