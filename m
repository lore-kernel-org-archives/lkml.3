Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbaGCR3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:29:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37925 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbaGCR3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:29:17 -0400
Message-ID: <53B592CE.2010001@ti.com>
Date: Thu, 3 Jul 2014 12:28:46 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 03/15] hwspinlock/core: maintain a list of registered
 hwspinlock banks
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-4-git-send-email-s-anna@ti.com> <CAK=WgbakGbTaYz+4K24aT3vyRkDYwPKCm6XrcJvH667NMMfTTA@mail.gmail.com> <53B47621.6090307@ti.com> <CAK=WgbYtJ7TGqvjG3VAPPD5tVXx9-jEJU3iKEStUMxOvD1v=LQ@mail.gmail.com>
In-Reply-To: <CAK=WgbYtJ7TGqvjG3VAPPD5tVXx9-jEJU3iKEStUMxOvD1v=LQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 07/03/2014 02:00 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Thu, Jul 3, 2014 at 12:14 AM, Suman Anna <s-anna@ti.com> wrote:
>>> I'm not sure we need this patch.
>>
>> This patch is needed if we use the controller-phandle + args specifier
>> for requesting hwlocks by a client, as we need to translate
>> controller-phandle to the corresponding hwspinlock_device.
>>
>> Looks like we still don't have a closure on the semantics of how
>> clients have to request a lock in DT. You are suggesting something like
>>     hwlocks = <global_lock1 global_lock2 ...>;
>>
>> whereas this patch is built to support based on comments from
>> DT-maintainers,
>>     hwlocks = <controller-phandle lock-specifier1>, <controller-phandle
>> lock-specifier2>...;
> 
> I'm actually ok with this suggestion and haven't suggested otherwise.

OK, thanks for confirming and sorry for the misinterpretation.

> 
> All I propose is that we add the base_id property to the controller
> node (as you have done in the subsequent patches), and then drivers
> will be able to infer the global lock id from the DT data by adding
> the controller's base_id to the lock specifier.

OK, but we would still require this function to lookup the registered
device from the controller-phandle to retrieve the base_id. Do note that
the hwspinlock core currently only maintains the registered locks in an
integrated radix tree, but not the registered hwspinlock banks themselves.

regards
Suman

> Controllers with non standard lock indexing may use an xlate() method
> if needed but frankly this is fictional right now. We can start
> without this, and add it later when needed, as this doesn't affect the
> DT data.
> 
> With the global lock id in hand, drivers could simply use the existing
> hwspin_lock_request_specific API to obtain a specific lock, and then
> we don't need this patch.
> 
> Thanks,
> Ohad.
> 

