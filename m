Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaDYVS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:18:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60272 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaDYVSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:18:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
	<87ha5h42va.fsf@x220.int.ebiederm.org>
	<CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
	<87tx9h2m2w.fsf@x220.int.ebiederm.org>
	<CALCETrU_SE=7QH-rDOqOsB5T4v+VEGL_3ZYRPgt6QWHB5BEGdg@mail.gmail.com>
Date: Fri, 25 Apr 2014 14:17:46 -0700
In-Reply-To: <CALCETrU_SE=7QH-rDOqOsB5T4v+VEGL_3ZYRPgt6QWHB5BEGdg@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 25 Apr 2014 13:46:23 -0700")
Message-ID: <87oazpyupx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX195mVktTqqfKQm167J7SR7KRhZvRnEwJd4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0742]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: pid ns feature request
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Apr 25, 2014 at 1:25 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Fri, Apr 25, 2014 at 12:37 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>
>>>>> Unless I'm missing some trick, it's currently rather painful to mount
>>>>> a namespace /proc.  You have to actually be in the pid namespace to
>>>>> mount the correct /proc instance, and you can't unmount the old /proc
>>>>> until you've mounted the new /proc.  This means that you have to fork
>>>>> into the new pid namespace before you can finish setting it up.
>>>>
>>>> Yes.  You have to be inside just about all namespaces before you can
>>>> finish setting them up.
>>>>
>>>> I don't know the context in which needed to be inside the pid namespace
>>>> is a burden.
>>>
>>> I'm trying to sandbox myself.  I unshare everything, setup up new
>>> mounts, pivot_root, umount the old stuff, fork, and wait around for
>>> the child to finish.
>>>
>>> This doesn't work: the parent can't mount the new /proc, and the child
>>> can't either because it's too late.
>>>
>>> The only solution I can think of without kernel changes is to fork the
>>> child (pid 1) before pivot_root, which makes everything more
>>> complicated.  I suppose I can unshare, fork immediately, have the
>>> child set up all the mounts, and then wake the parent, but this is an
>>> annoying bit of extra complexity for no obvious gain.
>>
>> Or perhaps just use clone and clone flags.
>>
>> What are you doing with the parent process?  What value does it serve?
>
> I'm not entirely sure.  I'm hacking on this thing:
>
> https://github.com/amluto/sandstorm/tree/userns
>
> which isn't really my code.  But there's an inner sandbox and an outer
> sandbox, and only the inner sandbox is in a pid namespace.
>
> I suppose what what I'm doing is a bit strange.

A bit.   But doing strange things is good.

Right now most of my energy is focused on closely the last of the design
issues.  So I don't have much energy for new namespace related features
right now.

Eric
