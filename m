Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaHLUjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 16:39:12 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61096 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaHLUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 16:39:10 -0400
Message-ID: <53EA7B69.9060800@colorfullife.com>
Date: Tue, 12 Aug 2014 22:39:05 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        1vier1@web.de, serge@hallyn.com, containers@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] ipc namespace: copy settings from parent namespace
References: <1407828557-31995-1-git-send-email-manfred@colorfullife.com> <1407828557-31995-2-git-send-email-manfred@colorfullife.com> <1407828557-31995-3-git-send-email-manfred@colorfullife.com> <1407828557-31995-4-git-send-email-manfred@colorfullife.com> <877g2ec7tg.fsf@x220.int.ebiederm.org>
In-Reply-To: <877g2ec7tg.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 08/12/2014 12:37 PM, Eric W. Biederman wrote:
> Manfred Spraul <manfred@colorfullife.com> writes:
>
> Sigh. Patches for new code during the merge window.  It is a really
> rotten time to look at new things.
>
>> Right now, each new IPC namespace starts with the kernel default values.
>> This means that changes that were made to the limits get overwritten.
>>
>> With this patch, a new namespace inherits the settings from the parent
>> namespace, which is less surprising.
> In principle I agree.
>
> In practice I have to ask what have you done to survey applications
> that use the ipc namespace to see if they will break with this change in
> semantics.
I know this is the wrong answer, but:
What I find are problems caused by the current behavior.

See e.g.:
https://bugzilla.redhat.com/show_bug.cgi?id=1004724

Some background:
The e.g. sysvshm limits were not updated for many years and many
applications only ran properly if sysvshm limits are increased.
(now the defaults are large, but only since ~3.15)

Increasing is simple: sysctl kernel.shmmax=<>, but somehow this
must happen inside the container.

Right now, the most common approach seems to be the solution from the 
bugzilla above:
Just marc /proc as read-write and do it manually.

With the patch, the kernel would propagate the value from parent to child.

--
     Manfred
