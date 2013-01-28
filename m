Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3A1QTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:19:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36627 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3A1QTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:19:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
References: <87ehh8it9s.fsf@xmission.com> <87txq4hedl.fsf@xmission.com>
	<51062AB5.9060203@parallels.com> <51062DA8.1060804@parallels.com>
	<87k3qxu3kp.fsf@xmission.com> <51063558.1010402@parallels.com>
Date: Mon, 28 Jan 2013 08:19:03 -0800
In-Reply-To: <51063558.1010402@parallels.com> (Lord Glauber Costa of Sealand's
	message of "Mon, 28 Jan 2013 12:22:48 +0400")
Message-ID: <87k3qxs2ko.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Z6tSIYzen77XAjZP70y+Nkzj453wZnr4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1185]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
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

> On 01/28/2013 12:14 PM, Eric W. Biederman wrote:
>> Lord Glauber Costa of Sealand <glommer@parallels.com> writes:
>> 
>>> I just saw in a later patch of yours that your concern here seems not
>>> limited to backed ram by tmpfs, but with things like the internal
>>> structures for userns , to avoid patterns in the form: 'for (;;)
>>> unshare(...)'
>>>
>>> Humm, it does seem sensible. The kernel memory controller aims to
>>> prevent exactly things like that. But they all exist already before
>>> userns: there are destructive patterns like that with sockets, dentries,
>>> processes, and pretty much every other resource in the kernel. So
>>> Although the recommendation per-se makes sense, I am wondering if it is
>>> worth it to mention anything in the user_ns config?
>> 
>> The config might be overkill.  However I have already gotten bug reports
>> about there being no limits.
>> 
>> So someone needs to stop and connect the dots and say: 
> Absolutely, and I am all for it
>
>> "If you care this is what you can do." 
>
> How about we say it, then?
>
> The current text in quite cryptic in this aspect, in the sense that it
> doesn't give enough information for standard people about what are the
> problems involved.
>
> Of course, maybe the Kconfig text is not the best place for having all
> the info: but don't we have some place in Documentation/ where we could
> put this, and then refer people there from Kconfig ?

At this point I have written the best text I can.

Please feel free to look at my tree at:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-next

and send me an patch on top of that to improve the wording.

At this point I have done my best to connect the dots for people who
care, that the memory control group is what they need to limit what
people can do with user namespaces.

My hope is that there is at least a passing mention in the next user
namespace article on lwn.

For two pieces of software that were designed to complement each other
I find it a bit surprising how many people (including myself) need the
connection made that memory control groups and user namespaces should go
together.

Eric
