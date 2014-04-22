Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaDVLaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:30:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64906 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaDVLaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:30:07 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-c0-535652bdd44e
Message-id: <535652B2.7000607@samsung.com>
Date: Tue, 22 Apr 2014 13:29:54 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for	components
 tracking
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
 <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
 <20140417220412.GZ24070@n2100.arm.linux.org.uk> <5351145D.8070207@samsung.com>
 <20140418124652.GE24070@n2100.arm.linux.org.uk>
In-reply-to: <20140418124652.GE24070@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xq7p7g8KCDaYs4bDoPXeSyeLvpGPs
	Fle+vmezaF68ns1i0v0JLBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYu2Ru+wW62e8ZnHg
	8Whp7mHz+P1rEqPH9m8PWD32z13D7nG/+ziTx+Yl9R59W1YxenzeJBfAEcVlk5Kak1mWWqRv
	l8CV0fbcoGALb8WHvb+ZGhjvc3UxcnJICJhIbD70gRnCFpO4cG89WxcjF4eQwFJGid2T1rGB
	JIQEPjFKrP8S0cXIwcEroCXx+3M8SJhFQFWif84DFhCbTUBT4u/mm2DlogIREvcaD7OC2LwC
	ghI/Jt8DqxERMJW49ugZM8h8ZoEmFok5V2eAJYQFIiVW7l3FArG4gUni55oLYJM4BWwkPr0+
	AXYds4COxP7WaWwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7N
	S9dLzs/dxAiJmK87GJceszrEKMDBqMTDK2EQGizEmlhWXJl7iFGCg1lJhFfRMyxYiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA+NOXp2pDpkxMi4sH5Y6R7Xf2j9vi9Ea1QfvWOYwcW5dwJNg/eNh
	y+PDMy/UHhBrf3Pz1tI/f9d9kQvdy1vzReVC3RXVJ8suSM+5l/MvtZCj3HF1+IeAQ33N6cuU
	f3SUK+38qql36PCJN/OmHdG3yu2IqdSZt+Xhx4WCBU6vRf9uFPvz8ECr+VE+JZbijERDLeai
	4kQAYfUwyXYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 02:46 PM, Russell King - ARM Linux wrote:
> On Fri, Apr 18, 2014 at 02:02:37PM +0200, Andrzej Hajda wrote:
>> Separation of the interfaces exposed by the device from the device itself
>> seems to me a good thing. I would even consider it as a biggest
>> advantage of this solution :)
>>
>> The problem of re-initialization does not seems to be relevant here, it
>> is classic
>> problem of coding correctness nothing more, it can appear here and in
>> many different
>> places.
> It may be a problem of coding correctless, but it's also a maintainability
> problem too - it makes it _much_ more difficult to ensure that everything
> is correct.

But forcibly re-initializing all component devices instead of fixing bugs
in specific drivers seems to be 'absolutely absurd' as classic says.
>> Anyway it seems we have different point of view on the problem, your say
>> about devices with two stage initialization. I see it more as devices
>> registering interfaces and superdevice using it.
> Right, so please make this exynos-specific, because from what I can see it
> has no reason to pretend to be generic.  As I've already pointed out, it
> can't be used in the general case because it ties sub-components directly
> to their main driver, which is absolutely absurd.  Please keep this
> absurdness in exynos and don't spread it around.  Thanks.

As I wrote already, this framework was proposed for drivers which
are tied together anyway, and this is case of many drivers, not only exynos.
Standalone drivers were not at my sight but I have also described in
other mail
how the framework can be 'improved' to support standalone drivers also.

Regards
Andrzej

>

