Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3LNNH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:07:58 -0500
Received: from mx2.bahnhof.se ([213.80.101.12]:62963 "EHLO mx2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab3LNNH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:07:57 -0500
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Dec 2013 08:07:57 EST
X-Spam-Score: 0.109
Message-ID: <52AC536D.70901@shipmail.org>
Date: Sat, 14 Dec 2013 13:47:41 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Daniel Vetter <daniel@ffwll.ch>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC] dma-buf: Implement test module
References: <1386858989-1487-1-git-send-email-treding@nvidia.com> <52AA0FC4.3090606@vmware.com> <CAKMK7uGOt2CYCgyE5rnXE3wJJjJiRpoQMB_-+_+m_qhk3TH8QQ@mail.gmail.com> <20131214123709.GE17467@mithrandir>
In-Reply-To: <20131214123709.GE17467@mithrandir>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 01:37 PM, Thierry Reding wrote:
> On Thu, Dec 12, 2013 at 11:30:23PM +0100, Daniel Vetter wrote:
>> On Thu, Dec 12, 2013 at 8:34 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>>> On 12/12/2013 03:36 PM, Thierry Reding wrote:
>>>> This is a simple test module that can be used to allocate, export and
>>>> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
>>>> systems that lack a real second driver.
>>>>
>>>>
>>> Looks nice. I wonder whether this could be extended to create a "streaming"
>>> dma-buf from a user space mapping. That could be used as a generic way to
>>> implement streaming (user) buffer objects, rather than to add explicit
>>> support for those in, for example, TTM.
>> Atm there's no way to get gpus to unbind their dma-buf mappings, so
>> their essentially pinned forever from first use on.
> Shouldn't this work by simply calling the GEM_CLOSE IOCTL on the handle
> returned by drmPrimeFDToHandle()? I mean that should drop the last
> reference on the GEM object and cause it to be cleaned up (which should
> include detaching the DMA-BUF).

Actually, while the GEM prime implementation appears to pin an exported 
dma-buf on first attach, from the dma-buf documentation it seems 
sufficient to pin it on map or cpu access.

But what I assume Daniel is referring to is that there is no way for 
exporters to tell importers to force unmap() the dma-buf, so that it can be
unpinned?

Daniel, maybe you could elaborate a bit on this?

Thomas

>
> Thierry
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


