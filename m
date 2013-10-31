Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab3JaBTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:19:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48401 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3JaBTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:19:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <8761sexu2l.fsf@xmission.com> <20131030224444.GA9092@kroah.com>
Date: Wed, 30 Oct 2013 18:19:27 -0700
In-Reply-To: <20131030224444.GA9092@kroah.com> (Greg Kroah-Hartman's message
	of "Wed, 30 Oct 2013 15:44:44 -0700")
Message-ID: <87a9hqp78g.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX187WWzQwZtAgA0M2GjiMf9KXb88NHnW1+8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: WTF: driver-core-next contains recursive directory removal!
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Oct 30, 2013 at 03:38:58PM -0700, Eric W. Biederman wrote:
>> 
>> Greg what is  going on?  I just looked and Tejuns ill-conceived recursive
>> directory deletion code has been merged into your driver-core-next tree.
>> 
>> That code is semantically broken.  I reviewed it and I gave the reasons
>> why it was wrong.  You came up to me and mentioned at LPC that you
>> agreed with my reasons.  And yet I just looked in driver-core-next and
>> there the code is in all of it's broken glory.
>
> Because I tested it out, and there were no such problems.

The biggest and worst issue is the semantics are total unmaintable
garbage and there has never been a single counter argument to that.

Recursive delete is WRONG.

Further there was no follow up converstion on the list about this trash
to say you had tested it.  Or anything else.

Even the partial recursive delete we currently have has been responsible
for broken users of sysfs so I don't see how adding additional checks is
going to do anything but paper over real bugs in real uses of sysfs.

Will you please remove that garbage from your tree. 

Eric


