Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3AUSjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:39:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3AUSji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:39:38 -0500
Message-ID: <50FD8B63.1060506@ti.com>
Date: Mon, 21 Jan 2013 12:39:31 -0600
From: Rob Clark <rob@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-16-git-send-email-arnd@arndb.de> <50FD7A5F.9020702@ti.com> <201301211741.11875.arnd@arndb.de>
In-Reply-To: <201301211741.11875.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 11:41 AM, Arnd Bergmann wrote:
> On Monday 21 January 2013, Rob Clark wrote:
>> Are you sure OMAP2_DSS requires ARCH_OMAP2PLUS?  I don't see this, and
>> it at least used to not depend on ARCH_OMAP2PLUS.  If it does now, I
>> think the correct fix would be to remove the dependency in OMAP2_DSS.  I
>> don't think removing ARCH_MULTIPLATFORM support in omapdrm is the
>> correct solution.
> At least it says so in drivers/video/omap2/Kconfig, which contains
>
> if ARCH_OMAP2PLUS
> source drivers/video/omap2/dss/Kconfig
> endif

ahh, ok, I see.. the if ARCH_OMAP2PLUS bit looks like it came in 
recently (770b6cb)

what about changing this to 'if ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM'?

BR,
-R

> We can probably change this, but until we do, we should not select
> OMAP2_DSS from something that doesn't also depend on ARCH_OMAP2PLUS.
>   
>>> drivers/video/omap2/dss/dss.c: In function 'dss_calc_clock_div':
>>> drivers/video/omap2/dss/dss.c:572:20: error: 'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared (first use in this function)
>>> drivers/video/omap2/dss/dss.c:572:20: note: each undeclared identifier is reported only once for each function it appears in
>>> drivers/staging/omapdrm/omap_connector.c: In function 'omap_connector_dpms':
>>> drivers/staging/omapdrm/omap_connector.c:116:8: error: 'OMAP_DSS_DISPLAY_SUSPENDED' undeclared (first use in this function)
>>> drivers/staging/omapdrm/omap_connector.c:116:8: note: each undeclared identifier is reported only once for each function it appears in
>>
>> This was an unrelated build break which should be fixed in latest master
>> after 'staging: drm/omap: use omapdss low level API'
> Ok, it seems the message is stale then, I created the patch some time ago, but
> only today wrote rest of the explanation for the changeset text.
>
> With all the other patches from my series applied, allyesconfig still gives me
>
> drivers/video/omap2/dss/dss.c:572:20: error: 'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared
>
> because that symbol is only defined when OMAP2_DSS is enabled rather than
> selected. Changing drivers/video/omap2/Kconfig to not depend on OMAP seems
> to work as well, but that seems a little intrusive for v3.8, because it would
> let a lot of people build that code that have no use for it.
>
> 	Arnd

