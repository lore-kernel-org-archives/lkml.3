Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422843Ab3FUCF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 22:05:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:3450 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965573Ab3FUCF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 22:05:28 -0400
X-Spam-Score: -100.8
Message-ID: <51C3B4B4.90603@asianux.com>
Date: Fri, 21 Jun 2013 10:04:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/itimer.c: beautify code, not need check 'value',
 so save one instruction, simpler and easier for readers.
References: <51C2E6F9.80107@asianux.com> <alpine.DEB.2.02.1306201458100.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306201458100.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly, I guess:

  since you can spend your time resource to reply, that means "you also
think this patch is valuable, but the comments need improving"

Is it correct ?


On 06/20/2013 09:42 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
> 
> kernel/itimer.c: beautify code, not need check 'value', so 
>           save one instruction, simpler and easier for readers.
> 
> That's an essay and not a proper subject line for a patch. 
> 
> See Documentation/SubmittingPatches and look at the other patch
> subject lines in git log.
> 

How about "kernel/itimer.c: remove the checking 'value' statement".

Or please provide your samples for the subject.


>> > Since copy_to_user() will check 'value', we do not need check it outside
>> > again,  so can save one comparing instruction at least.
> copy_to_user() does not check value, it will fault due to a NULL
> pointer dereference and execute the exception fixup. 
> 

Change it to:

Since copy_to_user() will process "bad address" internally, we need not
check 'value' again, then can save one comparing instruction at least.


> That's a massive difference which wants to be documented and argued
> why it's ok to do so.
> 
> Aside of that, please line break the changelog lines around 78
> characters.
> 

I use Thunderbird mail client, enable world wrap, is it OK ?


>> > Also can let code simpler and easier for readers: if checking parameter
>> > 'value', it will easily lead readers to think about why not return
>> > -EINVAL instead of -EFAULT, when checking parameter failed.
> So you are seriously claiming, that the check for !value makes people
> think that the return value should be -EINVAL?
> 
> That's hillarious.
> 

That seems not a quite polite word, is it ?  ;-)


> Can you please start to think about, why YOU thought that returning
> -EINVAL is the proper return value for that case?
> 

If you check the parameter, and find it invalid, and want to return with
failure, every one can assume you want to return -EINVAL.

Hmm... in some of embedded system which NOMMU, 'NULL' does not means
"bad address" (at least can write).


> Simply because in your rush to submit patches according to your self
> defined contribution plan, you fail to sit down and carefully study
> the code and the according documentation (man page). Instead of that
> you see some random snippet of code which looks wrong to you and you
> send out patches without care. After someone points out your failure
> you claim that the code is misleading to readers.
> 
> The code is not misleading to careful readers, it's only misleading to
> sloppy readers.
> 

Do you mean this patch can not make the code simpler and clearer ?

I guess, that is not your meaning, so how about this improving:

"after remove the code, also can let it simpler and clearer for readers"

Is it OK ?

> And I'm neither accepting sloppy patches nor am I accepting sloppy
> changelogs which make false claims.
> 

That is one of the reason for why we need reviewer, the work flow need
be "providing patch --> review --> apply".


BTW: Can you guess how many my patches have been applied by upstream,
since this year ?  That seems most of appliers are very polite, I wish
that will include you. ;-)


Thanks.
-- 
Chen Gang

Asianux Corporation
