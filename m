Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaJXCLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:11:55 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:47749 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaJXCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <CABgxDoKm5kKKCTD1njAerUrM24iVcGRDuhJ7b4qBVPqKBC4ftQ@mail.gmail.com>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
 <20141023081230.GK32045@tbergstrom-lnx.Nvidia.com> <CABgxDoKm5kKKCTD1njAerUrM24iVcGRDuhJ7b4qBVPqKBC4ftQ@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 24 Oct 2014 11:11:30 +0900
Message-ID: <CAAVeFuLccYzU6aHUjGu-oUZoXaZ0dgRiiCHy5QoOvJgKypm=ug@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] mfd: tps65910: Convert ti,system-power-controller
 DT property to poweroff-source
To: PERIER Romain <romain.perier@gmail.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "pawel.moll" <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 6:39 PM, PERIER Romain <romain.perier@gmail.com> wrote:
> Hi Peter,
>
> 2014-10-23 10:12 GMT+02:00 Peter De Schrijver <pdeschrijver@nvidia.com>:
>> This breaks DT ABI stability right? An existing device tree using ti,system-power-controller won't work anymore after this patch right? I don't think that's acceptable.
>>
>
> This is why I converted all dts which use "ti,system-power-controller"
> and tps65910/tps65911 to the new property (everything is in the
> patches serie). However, with an existing dtb it will no longer work,
> yes.
> What do you suggest ? keep these two properties in the driver ? :/
>
> I mean, this is a standardization, so all the corresponding dts must
> be updated and rebuilt... Like when you change something in a
> dt-binding, you should update and rebuilt the dts... I Don't compute.

DT ABI stability rule: any DTB that worked with kernel x must also
work with kernel x+1. It seems like this patch would break that rule.

It's ok to manage new properties and to deprecate the use of older
ones if it makes sense (and in this case it seems like it does). But
the old property must still be handled for compatibility reasons.
