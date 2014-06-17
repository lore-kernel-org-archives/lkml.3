Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaFQJyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaFQJyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:54:36 -0400
Message-ID: <53A01049.6020502@redhat.com>
Date: Tue, 17 Jun 2014 11:54:17 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com> <CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
In-Reply-To: <CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 05:33 PM, David Herrmann wrote:
> On Fri, Jun 13, 2014 at 5:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Isn't the point of SEAL_SHRINK to allow servers to mmap and read
>> safely without worrying about SIGBUS?
>
> No, I don't think so.
> The point of SEAL_SHRINK is to prevent a file from shrinking. SIGBUS
> is an effect, not a cause. It's only a coincidence that "OOM during
> reads" and "reading beyond file-boundaries" has the same effect:
> SIGBUS.
> We only protect against reading beyond file-boundaries due to
> shrinking. Therefore, OOM-SIGBUS is unrelated to SEAL_SHRINK.
>
> Anyone dealing with mmap() _has_ to use mlock() to protect against
> OOM-SIGBUS. Making SEAL_SHRINK protect against OOM-SIGBUS would be
> redundant, because you can achieve the same with SEAL_SHRINK+mlock().

I don't think this is what potential users expect because mlock requires 
capabilities which are not available to them.

A couple of weeks ago, sealing was to be applied to anonymous shared 
memory.  Has this changed?  Why should *reading* it trigger OOM?

-- 
Florian Weimer / Red Hat Product Security Team
