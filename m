Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab3DBDvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758500Ab3DBDvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:51:15 -0400
Message-ID: <515A5506.1000809@redhat.com>
Date: Tue, 02 Apr 2013 11:48:22 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lin Feng <linfeng@cn.fujitsu.com>
CC: David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Amos Kong <akong@redhat.com>
Subject: Re: THP: AnonHugePages in /proc/[pid]/smaps is correct or not?
References: <383590596.664138.1364803227470.JavaMail.root@redhat.com> <alpine.DEB.2.02.1304011512490.17714@chino.kir.corp.google.com> <515A4BD1.1020407@redhat.com> <515A5329.6020805@cn.fujitsu.com>
In-Reply-To: <515A5329.6020805@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 11:40 AM, Lin Feng wrote:
> Hi Zhouping,
>
> On 04/02/2013 11:09 AM, Zhouping Liu wrote:
>> I don't understand clearly the last sentence 'you'll probably only get 100% hugepages only 1/512th of the time.'
>> could you please explain more details about 'only 1/512th of the time'?
> IIUC, thp size is 2M so it may be comprised of 512 normal page(size 4k).
> Since your test code is not 2M aligned(not using  posix_memalign()) so
> the start address of the mapped vma will be random, such as
> 2M*i+4k*1, 2M*i+4k*2...2M*i+k4*511, there is 512 possibilities.
>
> The only chance you get thp happens when the first map just starts at 2M*i,
> and the consequent maps also benefit from this.

Feng, it's easy to understand now, thanks for your detailed explanation :)

Zhouping
