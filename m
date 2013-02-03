Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3BCNlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:41:37 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56291 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3BCNld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:41:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        jmorris@namei.org, axboe@kernel.dk
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Date: Sun, 03 Feb 2013 05:41:16 -0800
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Sat, 2 Feb 2013 17:20:01 -0800")
Message-ID: <87a9rltszn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/rYl/3ZYQmx5j/KwAhooWklU0ojdrKivQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,

So my first response after looking at the ipc patch is ick.

Why the deep percpu magic?
Why don't associate idr_preload with an idr structure.

When reading code with idr_preload I get this deep down creepy feeling.
What is this magic that is going on?

Can't we just put the preload list_head into struct idr make
idr_preload and idr_preload_end take an idr argument?

Maybe we can have a special structure we put on the stack that has
the list_head and the preload state instead.

The way this works just weirds me out and I really really don't like it.

I would rather continue to use the existing functions as problematic as
they are as I don't need a course in deep magic to make sense of them.

> 	idr_preload(GFP_KERNEL);
> 	spin_lock(lock);
>
> 	id = idr_alloc(idr, ptr, lower_limit, upper_limit, GFP_NOWAIT);
>
> 	spin_unlock(lock);
> 	idr_preload_end();
> 	if (id < 0)
> 		return id;

Eric
