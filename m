Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaCaWpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:45:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54103 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCaWpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:45:45 -0400
Message-ID: <5339EFFB.30304@ti.com>
Date: Mon, 31 Mar 2014 17:45:15 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 0/7] omap hwspinlock dt support
References: <1389658764-39199-1-git-send-email-s-anna@ti.com> <52F9282B.5000702@ti.com> <530B8C00.8020001@ti.com> <CAK=WgbZp_RQPCeZJyMRkNTQxaJsnGZ3DnjhSkYYR_-PAE_Kp4g@mail.gmail.com> <53239789.40600@ti.com> <CAK=WgbZCzA7JovSxnysHCQRZZWc3Z2j3AS8ekpM9fOZ160rmCA@mail.gmail.com> <532748B7.1080606@ti.com> <CAK=WgbYjtw+cxy5wX6pjK=Rpj6wOk6Cu+GrPuFN+sqtgDAY=_Q@mail.gmail.com> <53278950.5030905@ti.com> <CAK=WgbZ1M0JZE2BH0ukNo33hBuffTGbd3-DD0WCiwZ-akgvQ-Q@mail.gmail.com>
In-Reply-To: <CAK=WgbZ1M0JZE2BH0ukNo33hBuffTGbd3-DD0WCiwZ-akgvQ-Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 08:35 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Tue, Mar 18, 2014 at 1:46 AM, Suman Anna <s-anna@ti.com> wrote:
>> So far, we have not come across multiple controllers. I see your point,
>> and I think this also depends on the semantics of how you exchange the
>> lock id number. The agreement at the moment is on base_ids across
>> multiple SoC components. If the semantics involve exchanging the
>> controller instance, for example, then we might get away with it. But
>> that probably involves adding additional helpers to retrieve controller
>> instance in addition to lock number, or some other similar functions.
> 
> Yes, this could be done too, but I agree it is less simple with no real win.
> 
>> Sorry, I should have rephrased it better - by order, I meant the
>> inherent order between board early code and other drivers. With DT, we
>> cannot guarantee that right, as specific locks are requested from drivers.
> 
> Yeah.
> 
>> Understood. And we may have to assign the client association with a lock
>> as well. These are core changes that were actually not needed in the
>> non-DT case due to the inherent order as stated above. So, are you
>> suggesting that we add one more property to the controller node to mark
>> which are reserved, or rely on constructing this through DT tree parsing?
> 
> I guess this is a question to the DT folks; both approaches work from
> hwspinlock perspective.
> 
> In the past Arnd Benoit and myself were happy with adding one more
> property to the controller node, but this might be somewhat error
> prone as it leaves room for mistakes - developers can add hwlock
> phandles and forget to update the reserved property in the controller
> node.

Ohad,
I agree that this is the most simplest form (either a reserved number
starting from base, or a reserved range - I prefer the first). The
developer errors can be restricted by having the
of_hwspin_lock_request_specific() return an error if anything outside
this reserved range is requested.

Mark, Kumar,
Any recommendations/objections on this problem/approach?

I also have to bring back the hwlock-base-id property (dropped in v3)
for registration purposes, so that the registration does not change
based on the probe order of the multiple controller nodes.

regards
Suman
