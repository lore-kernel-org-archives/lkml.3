Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaGBVOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:14:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60272 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaGBVOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:14:44 -0400
Message-ID: <53B47626.4040506@ti.com>
Date: Wed, 2 Jul 2014 16:14:14 -0500
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
Subject: Re: [PATCHv5 04/15] hwspinlock/core: add common OF helpers
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-5-git-send-email-s-anna@ti.com> <CAK=WgbbZvBLT7U638fBfPjF7-MJaP=4WJcrT_fEg6Uu3cXRAyg@mail.gmail.com>
In-Reply-To: <CAK=WgbbZvBLT7U638fBfPjF7-MJaP=4WJcrT_fEg6Uu3cXRAyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

>
> On Thu, May 1, 2014 at 3:34 AM, Suman Anna <s-anna@ti.com> wrote:
>> 2. The of_hwspin_lock_simple_xlate() is a simple default
>>    translator function for hwspinlock provider implementations
>>    that use a single cell number for requesting a specific lock
>>    (relatively indexed) within a hwlock bank.
> 
> Do we have a use case today that require the xlate() method?
> 
> If not, let's remove it as we could always add it back if some new
> hardware shows up that needs it.

The xlate() method is to support the phandle + args specifier way of
requesting hwlocks, platform implementations are free to implement their
own xlate functions, but the above supports the simplest case of
controller + relative lock index within controller.

> 
> As long as the dt data is unchanged, we should generally only add
> kernel code that we really need.
> 
>> 3. The of_hwspin_lock_request_specific() API can be used by
>>    hwspinlock clients to request a specific lock using the
>>    phandle + args specifier. This function relies on the
>>    implementation providing back a relative hwlock id within
>>    the bank from the args specifier.
> 
> It seems to me we can just introduce a of_hwspin_lock_get_id() method
> which will provide the global lock id to dt users, with which they
> could just invoke the existing hwspin_lock_request_specific(). This
> way we will have more common code between dt users and users who get
> the lock id from a remote processor.

This function again is to support the phandle + args specifier way of
requesting hwlocks, the hwspin_lock_request_specific() is invoked
internally within this function, so we are still reusing the actual
request code other than handling the DT parsing portion. If we go back
to using global locks in client hwlocks property, we don't need a
of_hwspin_lock_get_id(), the same can be achieved using the existing DT
function, of_property_read_u32_index().

regards
Suman
