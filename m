Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbaFQMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:13:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbaFQMN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:13:57 -0400
Message-ID: <53A030E9.7010701@redhat.com>
Date: Tue, 17 Jun 2014 14:13:29 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>	<CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>	<53A01049.6020502@redhat.com>	<CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>	<53A012C8.7060109@redhat.com> <CANq1E4QinvVA-O=dX4N819jVK3xSihJcpz9juFj+A3qv0MXODg@mail.gmail.com>
In-Reply-To: <CANq1E4QinvVA-O=dX4N819jVK3xSihJcpz9juFj+A3qv0MXODg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 12:10 PM, David Herrmann wrote:

>>> The file might have holes, therefore, you'd have to allocate backing
>>> pages. This might hit a soft-limit and fail. To avoid this, use
>>> fallocate() to allocate pages prior to mmap()
>>
>> This does not work because the consuming side does not know how the
>> descriptor was set up if sealing does not imply that.
>
> The consuming side has to very seals via F_GET_SEALS. After that, it
> shall do a simple fallocate() on the whole file if it wants to go sure
> that all pages are allocated. Why shouldn't that be possible? Please
> elaborate.

Hmm.  You permit general fallocate even for WRITE seals.  That's really 
unexpected.

The inode_newsize_ok check in shmem_fallocate can result in SIGXFSZ, 
which doesn't seem to be what's intended here.

Will the new pages attributed to the process calling fallocate, or to 
the process calling memfd_create?

-- 
Florian Weimer / Red Hat Product Security Team
