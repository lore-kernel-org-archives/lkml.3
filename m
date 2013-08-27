Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3H0OQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:16:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31224 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3H0OQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:16:43 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-67-521cb4c8c28b
Message-id: <521CB4C5.2050804@samsung.com>
Date: Tue, 27 Aug 2013 17:16:37 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Sarah Sharp <sarah.a.sharp@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xhci:prevent "callbacks suppressed" when debug is not
 enabled
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
 <70b3564625bbda6247cc5627041344fef8a762ae.1376582695.git.d.kasatkin@samsung.com>
 <20130816001716.GA7367@kroah.com> <20130816172635.GA7975@xanatos>
 <20130816173000.GA8210@xanatos>
 <CACE9dm9Rw55HdwsKRYvecCFCAO137uU4iv5yLnEMzc-0pRZCsg@mail.gmail.com>
 <20130816174516.GA20389@kroah.com>
In-reply-to: <20130816174516.GA20389@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xy7ontsgEGcw4bG3xZWmdRfPi9WwW
	l3fNYbO4tus+q0XziVPMDqweO2fdZfdYvOclk8e8k4Ee++euYff4vEkugDWKyyYlNSezLLVI
	3y6BK+PpyW0sBaslK6Yv3cbWwHhSsIuRk0NCwERiye+fTBC2mMSFe+vZQGwhgaWMErPXRHUx
	cgHZjUwSn2a/Y4dw5jJKdC9YzA5SxSugJdG7px2sg0VAVWLRz1Vgk9gE9CQ2NP8AqxEViJBY
	ueQBK0S9oMSPyfdYQGwRAQ2Jl0dvsYAMZQbZduNhFzNIQhio4dbPVlaIM5qZJWbfNgexOQX0
	JT68bwZbxiygI7G/dRqULS+xec1bZoh6VYnutWvZIN5RlDg9+RzzBEbhWUh2z0LSPgtJ+wJG
	5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIZHxZQfj4mNWhxgFOBiVeHgtNssECbEmlhVX
	5h5ilOBgVhLh3b0CKMSbklhZlVqUH19UmpNafIiRiYNTqoGRufDYD62Z/wNnNFkW3b+S777I
	76JPtOAd/vt5NvnKyf+7zrtvF4s31DuWN8lq9z7blvqwkrMPNrdzxR2qUanunTjz4et58xfm
	KCic3XH71sGjTLMvhD/bYKgisVl1a7jF36Bft7k2h064ks357fP0hrlpOSK5B6ZNNTM3eGfM
	tjP5wgavs8qrlFiKMxINtZiLihMBvpNdiGoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/13 20:45, Greg KH wrote:
> On Fri, Aug 16, 2013 at 08:38:12PM +0300, Dmitry Kasatkin wrote:
>> On Fri, Aug 16, 2013 at 8:30 PM, Sarah Sharp <sarah.a.sharp@intel.com> wrote:
>>> On Fri, Aug 16, 2013 at 10:26:35AM -0700, Sarah Sharp wrote:
>>>> On Thu, Aug 15, 2013 at 05:17:16PM -0700, Greg KH wrote:
>>>>> On Thu, Aug 15, 2013 at 07:04:55PM +0300, Dmitry Kasatkin wrote:
>>>>>> When debug is not enabled and dev_dbg() will expand to nothing,
>>>>>> log might be flooded with "callbacks suppressed". If it was not
>>>>>> done on purpose, better to use dev_dbg_ratelimited() instead.
>>>>>>
>>>>>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>>>>>> ---
>>>>>>  drivers/usb/host/xhci-ring.c | 6 ++----
>>>>>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>>>>
>>>>> Sarah, does this patch conflict with the trace debug patches being
>>>>> worked on?  I'll hold off on applying it for now, let me know if it's ok
>>>>> or not.
>>>> It doesn't conflict with the trace debug patches, because those only
>>>> effect debugging with xhci_dbg with the host device, not dev_dbg with
>>>> the USB device.  This should apply fine to usb-next.
>>> At another glance, the patch removes two if blocks, but doesn't
>>> re-indent the rest of the lines:
>>>
>>>> @@ -3060,8 +3060,7 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>>>>        * to set the polling interval (once the API is added).
>>>>        */
>>>>       if (xhci_interval != ep_interval) {
>>>> -             if (printk_ratelimit())
>>>> -                     dev_dbg(&urb->dev->dev, "Driver uses different interval"
>>>> +             dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
>>>>                                       " (%d microframe%s) than xHCI "
>>>>                                       "(%d microframe%s)\n",
>>>>                                       ep_interval,
>>> That should probably be fixed.
>> It actually looks correct when patch is applied.
>>
>> But it depends what you mean of course.
>> It looks like it was before:
>> dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
>>                                        " (%d microframe%s) than xHCI "
>>                                        "(%d microframe%s)\n",
>>                                        ep_interval,
>>                                         ep_interval == 1 ? "" : "s",
>>
>> Or may be you mean:
>> dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
>>                                " (%d microframe%s) than xHCI "
>>                                "(%d microframe%s)\n",
>>                                ep_interval,
>>                                ep_interval == 1 ? "" : "s",
> No, it should look like:
>
> 		dev_dbg_ratelimited(&urb->dev->dev,
> 				    "Driver uses different interval (%d microframe%s) than xHCI (%d microframe%s)\n",
> 				     ep_interval, ep_interval == 1 ? "" : "s",

Hello. Sorry I was distracted so much from the kernel.

But putting string to one line make it much over 80 chars.
Is that considered OK?

- Dmitry

> and the rest of that call indented the same way.
>
> thanks,
>
> greg k-h
>

