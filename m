Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaHFWM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:12:57 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53527 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaHFWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:12:55 -0400
Message-ID: <53E2A85A.8030406@gmail.com>
Date: Wed, 06 Aug 2014 15:12:42 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tim Bird <tbird20d@gmail.com>, Brian Norris <computersforpeace@gmail.com>
CC: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/irq: lookup 'interrupts-extended' property first
References: <1403220823-19444-1-git-send-email-f.fainelli@gmail.com>	<CAGVrzcYfA8rCXGRW7g0JhT4GQKT8SQj+pMvCh25yoXLFGNM_Pw@mail.gmail.com>	<20140806165452.GN3711@ld-irv-0074>	<CAL_JsqK8BiffXgpQSig5EbV3FUW7EBOn9YjZGqOcUcEJiCJ0WA@mail.gmail.com>	<20140806201256.GO3711@ld-irv-0074> <CA+bK7J7LQq4S70ScSynbLTjNMmP=9n3KD2suYRg9JN+pEv-Y7g@mail.gmail.com>
In-Reply-To: <CA+bK7J7LQq4S70ScSynbLTjNMmP=9n3KD2suYRg9JN+pEv-Y7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 02:50 PM, Tim Bird wrote:
> On Wed, Aug 6, 2014 at 1:12 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> On Wed, Aug 06, 2014 at 01:42:08PM -0500, Rob Herring wrote:
>>> On Wed, Aug 6, 2014 at 11:54 AM, Brian Norris <computersforpeace@gmail.com> wrote:
>>>> On Thu, Jul 31, 2014 at 11:00:01AM -0700, Florian Fainelli wrote:
>>>> I think it is important that a device tree provide some flexibility on
>>>> kernel versions. We only invented 'interrupts-extended' in Linux 3.13,
>>>> so it's easy to have device trees that could work only on 3.13+.
>>>>
>>>> Typically, we might say that new features require new kernels, but this
>>>> is a very basic piece of the DT infrastructure. In our case, we have
>>>> hardware whose basic features can be supported by a single interrupt
>>>> parent, and so we used the 'interrupts' property pre-3.13. But when we
>>>> want to add some power management features, there's an additional
>>>> interrupt parent. Under the current DT binding, we have to switch over
>>>> to using 'interrupts-extended' exclusively, and thus we must have a
>>>> completely new DTB for >=3.13, and this DTB no longer works with the old
>>>> kernels.
>>>
>>> "Must have" to enable the new features?
>>
>> Yes. The new feature requires an additional interrupt parent, and so it
>> requires interrupts-extended.
> 
> Hold on there.  What about interrupt-map?  That was the traditional DT
> feature for
> supporting multi-parented interrupts.  Why couldn't the feature have been added
> using that instead of interrupts-extended?

As far as I read it from the ePAPR specification, you have a good point
here, it looks like 'interrupt-map' could have been used as-is instead
of 'interrupts-extended'. In fact it is a little more general than
'interrupts-extended' since it allows any sort of "child unit address",
whether that is an actual interrupt number, or something else, is
dependent on the type of node being used.

> 
> I know interrupts-extended is preferred, but has interrupt-map support been
> removed from recent kernels?  I'm a bit confused.

'interrupt-map' support has not been removed since that is heavily used
to cross interrupt domains, e.g: PCI relies heavily on it, other buses
as well most likely.

> 
>  -- Tim Bird
> Senior Software Engineer, Sony Mobile
> Architecture Group Chair, CE Workgroup, Linux Foundation
> 

