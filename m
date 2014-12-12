Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934737AbaLLJhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:37:07 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33787 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091AbaLLJhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:37:03 -0500
Message-ID: <548AB734.2030907@collabora.co.uk>
Date: Fri, 12 Dec 2014 10:36:52 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "'Kukjin Kim'" <kgene@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
CC: "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "'Ajay Kumar'" <ajaykumar.rs@samsung.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH V2 RESEND] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
References: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com> <CABxcv=mmJp2c=ZC8=0+TW0-x3g7RnELTAFY24KJRjUgf+QrDcQ@mail.gmail.com> <000501d00e0b$8e0e8610$aa2b9230$%han@samsung.com>
In-Reply-To: <000501d00e0b$8e0e8610$aa2b9230$%han@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding arm-soc maintainers to cc]

Hello Kukjin,

On 12/02/2014 09:39 AM, Jingoo Han wrote:
> On Tuesday, December 02, 2014 5:17 PM, Javier Martinez Canillas wrote:
>> On Mon, Nov 24, 2014 at 6:41 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> > DP PHY now require pmu-system-controller to handle PMU register
>> > to control PHY's power isolation. Adding the same to dp-phy
>> > node.
>> >
>> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> > Reviewed-by: Jingoo Han <jg1.han@samsung.com>
>> > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> > Cc: Kukjin Kim <kgene@kernel.org>
>> 
>> Any opinions about $subject?
>> 
>> This patch is -rc material since is needed after commit a5ec598 ("phy:
>> exynos-dp-video: Use syscon
>> support to control pmu register") which landed in 3.18. That means
>> that display for Exynos is currently broken in 3.18.
>> 
>> I think it's too late for the 3.18 -rc cycle but at least it would be
>> great to have this merged for 3.19 and backport to stable kernels to
>> have display working again.
> 
> I agree with this suggestion.
>

Sorry for being nagging with this but 3.18 has been released and the Exynos
DP video PHY is not working because this patch was not merged :(

So, it would be good if this can be pushed before the merge window for 3.19
closes or we may end with another kernel release with a non-working display.
 
>> 
>> Thierry had concerns that this change breaks DT backward compability
>> but actually it was already been broken by a5ec598 which changed the
>> DT binding for the phy-exynos-dp-video driver so we should either
>> apply this patch now or revert a5ec598.
> 
> I think that very few people might use old properties for Exynos DP.
> Actually, DT backward compatibility will not be the considerable problem
> in my opinion.
> 
> But, in order to keep the DT backward compatibility, we should revert
> a5ec598, and send another patch for keeping the DT backward compatibility.
>

I'm not sure if is worth it to revert a5ec598 and maintain DT backward
compatibility in this case since it seems there aren't real mainline
users of Exynos DP, otherwise someone would had cared that 3.18 is broken.

IMHO just $subject has to be picked to make the DTS use the new DT binding
of the phy-exynos-dp-video driver. Maybe arm-soc maintainers can pick
$subject directly since Kukjin seems to be busy?

Thanks a lot and best regards,
Javier
