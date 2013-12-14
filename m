Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3LNNLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:11:09 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52214 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab3LNNLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:11:06 -0500
Message-ID: <52AC58E3.5030209@vmware.com>
Date: Sat, 14 Dec 2013 14:10:59 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>
CC: Thomas Hellstrom <thomas@shipmail.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: Re: [RFC] dma-buf: Implement test module
References: <1386858989-1487-1-git-send-email-treding@nvidia.com> <52AA0FC4.3090606@vmware.com> <CAKMK7uGOt2CYCgyE5rnXE3wJJjJiRpoQMB_-+_+m_qhk3TH8QQ@mail.gmail.com> <20131214123709.GE17467@mithrandir> <52AC536D.70901@shipmail.org> <CAF6AEGtSOebnVCfffEtYJQwYXkFNWWx_c2QB3a66K5c3aZStQw@mail.gmail.com>
In-Reply-To: <CAF6AEGtSOebnVCfffEtYJQwYXkFNWWx_c2QB3a66K5c3aZStQw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 02:02 PM, Rob Clark wrote:
> On Sat, Dec 14, 2013 at 7:47 AM, Thomas Hellstrom <thomas@shipmail.org> wrote:
>> On 12/14/2013 01:37 PM, Thierry Reding wrote:
>>> On Thu, Dec 12, 2013 at 11:30:23PM +0100, Daniel Vetter wrote:
>>>> On Thu, Dec 12, 2013 at 8:34 PM, Thomas Hellstrom <thellstrom@vmware.com>
>>>> wrote:
>>>>> On 12/12/2013 03:36 PM, Thierry Reding wrote:
>>>>>> This is a simple test module that can be used to allocate, export and
>>>>>> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
>>>>>> systems that lack a real second driver.
>>>>>>
>>>>>>
>>>>> Looks nice. I wonder whether this could be extended to create a
>>>>> "streaming"
>>>>> dma-buf from a user space mapping. That could be used as a generic way
>>>>> to
>>>>> implement streaming (user) buffer objects, rather than to add explicit
>>>>> support for those in, for example, TTM.
>>>> Atm there's no way to get gpus to unbind their dma-buf mappings, so
>>>> their essentially pinned forever from first use on.
>>> Shouldn't this work by simply calling the GEM_CLOSE IOCTL on the handle
>>> returned by drmPrimeFDToHandle()? I mean that should drop the last
>>> reference on the GEM object and cause it to be cleaned up (which should
>>> include detaching the DMA-BUF).
>>
>> Actually, while the GEM prime implementation appears to pin an exported
>> dma-buf on first attach, from the dma-buf documentation it seems sufficient
>> to pin it on map or cpu access.
>>
>> But what I assume Daniel is referring to is that there is no way for
>> exporters to tell importers to force unmap() the dma-buf, so that it can be
>> unpinned?
> yeah, or some way for importers to opportunistically keep around a
> mapping rather than map/unmap on each use..
>
> maybe we need something shrinker-ish for dmabuf?

Yes, I think that's needed for both the memory-shortage case where we 
want to unpin, and I guess it would desirable for
iommu space management as well.

/Thomas

>
> BR,
> -R
>
>
