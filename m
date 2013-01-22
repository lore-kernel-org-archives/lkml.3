Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3AVQ6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:58:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54516 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3AVQ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:58:06 -0500
Message-ID: <50FEC508.50004@ti.com>
Date: Tue, 22 Jan 2013 10:57:44 -0600
From: Rob Clark <rob@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arm@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-16-git-send-email-arnd@arndb.de> <50FD7A5F.9020702@ti.com> <201301211741.11875.arnd@arndb.de> <50FD8B63.1060506@ti.com> <20130122165330.GA28152@kroah.com>
In-Reply-To: <20130122165330.GA28152@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 10:53 AM, Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 12:39:31PM -0600, Rob Clark wrote:
>> On 01/21/2013 11:41 AM, Arnd Bergmann wrote:
>>> On Monday 21 January 2013, Rob Clark wrote:
>>>> Are you sure OMAP2_DSS requires ARCH_OMAP2PLUS?  I don't see this, and
>>>> it at least used to not depend on ARCH_OMAP2PLUS.  If it does now, I
>>>> think the correct fix would be to remove the dependency in OMAP2_DSS.  I
>>>> don't think removing ARCH_MULTIPLATFORM support in omapdrm is the
>>>> correct solution.
>>> At least it says so in drivers/video/omap2/Kconfig, which contains
>>>
>>> if ARCH_OMAP2PLUS
>>> source drivers/video/omap2/dss/Kconfig
>>> endif
>> ahh, ok, I see.. the if ARCH_OMAP2PLUS bit looks like it came in
>> recently (770b6cb)
>>
>> what about changing this to 'if ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM'?
> That's what Arnd's patch did.

sorry, I was talking about in drivers/video/omap2/Kconfig

Ie. I'd prefer to re-enable omapdss on multi-plat rather than disabling 
omapdrm.  With changes in drm core, it is a bit of a pain to compile 
test all the arm drivers by doing N different builds, so we've been 
trying to get to the point of all arm drm drivers supporting multi-plat

BR,
-R

> totally confused,
>
> greg k-h

