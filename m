Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbbA1VNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:13:55 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:45267 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbbA1Uwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:52:42 -0500
MIME-Version: 1.0
In-Reply-To: <20150128112339.164c55fd@recife.lan>
References: <1422449643-7829-1-git-send-email-sumit.semwal@linaro.org> <20150128112339.164c55fd@recife.lan>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 28 Jan 2015 19:00:46 +0530
Message-ID: <CAO_48GH3CVPeGUfDTuOgGfYmBnc1CvwVc5GYS6O3=275o0SwCw@mail.gmail.com>
Subject: Re: [PATCH v3] dma-buf: cleanup dma_buf_export() to make it easily extensible
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        rmk+kernel@arm.linux.org.uk, Dave Airlie <airlied@linux.ie>,
        kgene@kernel.org, daniel.vetter@intel.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        inki.dae@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On 28 January 2015 at 18:53, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Wed, 28 Jan 2015 18:24:03 +0530
> Sumit Semwal <sumit.semwal@linaro.org> escreveu:
>
>> +/**
>> + * helper macro for exporters; zeros and fills in most common values
>> + */
>> +#define DEFINE_DMA_BUF_EXPORT_INFO(a)        \
>> +     struct dma_buf_export_info a = { .exp_name = KBUILD_MODNAME }
>> +
>
> I suspect that this will let the other fields not initialized.
>
> You likely need to do:
>
> #define DEFINE_DMA_BUF_EXPORT_INFO(a)   \
>         struct dma_buf_export_info a = {        \
>         .exp_name = KBUILD_MODNAME;             \
>         .fields = 0;                            \
> ...
> }
I suspected the same, but Daniel kindly referred to the C99 standard,
which states:
" If there are fewer initializers in a brace-enclosed list than there
are elements or members
of an aggregate, or fewer characters in a string literal used to
initialize an array of known
size than there are elements in the array, the remainder of the
aggregate shall be
initialized implicitly the same as objects that have static storage duration."

So I think we're well covered there?
>
> Regards,
> Mauro



-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
