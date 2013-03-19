Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab3CSA35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:29:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41052 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3CSA3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:29:54 -0400
Message-ID: <5147B0EC.2020907@zytor.com>
Date: Mon, 18 Mar 2013 17:27:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, kdump: Set crashkernel_low automatically
References: <514783B4.2030401@zytor.com> <1363641957-5247-1-git-send-email-yinghai@kernel.org> <51479AAD.7040209@zytor.com> <CAE9FiQXFabEpW0SpJZ+88zMZmQvExTzXU7+MOqBRx-JD61aJPg@mail.gmail.com>
In-Reply-To: <CAE9FiQXFabEpW0SpJZ+88zMZmQvExTzXU7+MOqBRx-JD61aJPg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 04:26 PM, Yinghai Lu wrote:
> 
> now only have:
> swiotlb overflow buffer
> 
>         v_overflow_buffer = alloc_bootmem_low_pages_nopanic(
>                                                 PAGE_ALIGN(io_tlb_overflow));
> 
> and
>      /*
>       * When the IOMMU overflows we return a fallback buffer. This
> sets the size.
>      */
>      static unsigned long io_tlb_overflow = 32*1024;
> 
> so it is 32K, and I round it to 8M.
> 

So put that into prose, understandable by someone who hasn't followed
this discussion (say, five years from now), and make that part of the
commit.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

