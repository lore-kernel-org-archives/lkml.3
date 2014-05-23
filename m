Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaEWIRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:17:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56094 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaEWIRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:17:14 -0400
Message-ID: <537F03C8.3070101@ti.com>
Date: Fri, 23 May 2014 11:16:08 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tony Lindgren <tony@atomide.com>,
        Javier Martinez Canillas <javier@dowhile0.org>
CC: Brian Norris <computersforpeace@gmail.com>, "Gupta, Pekon" <pekon@ti.com>,
        Robert Nelson <robertcnelson@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, <dwmw2@infradead.org>,
        <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 00/16] OMAP: GPMC: Restructure OMAP GPMC driver (NAND)
 : DT binding change proposal
References: <1400671264-10702-1-git-send-email-rogerq@ti.com> <20140521160818.GA1150@arch.cereza> <537DB17A.6060608@ti.com> <CABxcv=nbgGhVN+XYO8s=mYOpoLU9-kWuEqc+FLMaSbWS7BJNyQ@mail.gmail.com> <20140522144600.GA1785@arch.cereza>
In-Reply-To: <20140522144600.GA1785@arch.cereza>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ezequiel & Javier,

On 05/22/2014 05:46 PM, Ezequiel Garcia wrote:
> On 22 May 01:51 PM, Javier Martinez Canillas wrote:
>> On Thu, May 22, 2014 at 10:12 AM, Roger Quadros <rogerq@ti.com> wrote:
>>>> On 21 May 02:20 PM, Roger Quadros wrote:
>>>>>
>>>>> For DT boot:
>>>>> - The GPMC controller node should have a chip select (CS) node for each used
>>>>>   chip select. The CS node must have a child device node for each device
>>>>>   attached to that chip select. Properties for that child are GPMC agnostic.
>>>>>
>>>>>   i.e.
>>>>>      gpmc {
>>>>>              cs0 {
>>>>>                      nand0 {
>>>>>                      }
>>>>>              };
>>>>>
>>>>>              cs1 {
>>>>>                      nor0 {
>>>>>                      }
>>>>>              }
>>>>>              ...
>>>>>      };
>>>>>
>>>>
>>>> While I agree that the GPMC driver is a bit messy, I'm not sure it's possible
>>>> to go through such a complete devicetree binding re-design (breaking backwards
>>>> compatibility) now that the binding is already in production.
>>>
>>> Why not? especially if the existing bindings are poorly dones. Is anyone using these
>>> bindings burning the DT into ROM and can't change it when they update the kernel?
>>>
>>
>> While I do agree that your DT bindings are much better than the
>> current ones, there is a policy that DT bindings are an external API
>> and once are released with a kernel are set in stone and can't be
>> changed.
>>
> 
> Exactly. The DT binding is considered an ABI. Thus, invariant across kernel
> versions. Users can't be coherced into a DTB update after a kernel update.
> 
> That said, I don't really care if you break compatilibity in this case.
> Rather, I'm suggesting that you make sure this change is going to be accepted
> upstream, before doing any more work. The DT maintainers are reluctant to do
> so.

Appreciate your concern.

Would be really nice if you can review patches 1-12. They have nothing to do with DT changes.
Thanks.

cheers,
-roger

> 
> On the other side, I guess you will also break bisectability while breaking
> backward compatibility. Doesn't sound very nice.
> 

