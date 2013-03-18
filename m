Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3CRX07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:26:59 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61430 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3CRX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <51479AAD.7040209@zytor.com>
References: <514783B4.2030401@zytor.com>
	<1363641957-5247-1-git-send-email-yinghai@kernel.org>
	<51479AAD.7040209@zytor.com>
Date: Mon, 18 Mar 2013 16:26:57 -0700
X-Google-Sender-Auth: ZBmM9jWzVi-GWHEgNNFNPJ9JOQQ
Message-ID: <CAE9FiQXFabEpW0SpJZ+88zMZmQvExTzXU7+MOqBRx-JD61aJPg@mail.gmail.com>
Subject: Re: [PATCH v3] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/18/2013 02:25 PM, Yinghai Lu wrote:
>> Current code does not set low range for crashkernel if the user
>> does not specify that.
>>
>> That cause regressions on system that does not support intel_iommu
>> properly.
>>
>> Chao said that his system does work well on 3.8 without extra parameter.
>> even iommu does not work with kdump.
>>
>> Set crashkernel_low automatically if the user does not specify that.
>>
>> For system that does support IOMMU with kdump properly, user could
>> specify crashkernel_low=0 to save that 72M low ram.
>>
>> -v3: add swiotlb_size() according to Konrad.
>>
>> Reported-by: WANG Chao <chaowang@redhat.com>
>> Tested-by: WANG Chao <chaowang@redhat.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Can we get a bit more of an explanation instead of "and etc 8M"?  At
> least a hint of what kind of objects would go in there...

now only have:
swiotlb overflow buffer

        v_overflow_buffer = alloc_bootmem_low_pages_nopanic(
                                                PAGE_ALIGN(io_tlb_overflow));

and
     /*
      * When the IOMMU overflows we return a fallback buffer. This
sets the size.
     */
     static unsigned long io_tlb_overflow = 32*1024;

so it is 32K, and I round it to 8M.
