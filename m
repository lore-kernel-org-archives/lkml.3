Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaIBOuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:50:10 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:35944 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaIBOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:50:09 -0400
Message-ID: <5405D91D.7020108@gmail.com>
Date: Tue, 02 Sep 2014 16:50:05 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: lee.jones@linaro.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        arnd@arndb.de, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform
 devices
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.09.2014 16:42, Pankaj Dubey wrote:
> Currently a syscon entity can only be registered directly through a
> platform device that binds to a dedicated syscon driver. However in
> certain cases it is required to bind a device with it's dedicated
> driver rather than binding with syscon driver.
> 
> For example, certain SoCs (e.g. Exynos) contain system controller
> blocks which perform various functions such as power domain control,
> CPU power management, low power mode control, but in addition contain
> certain IP integration glue, such as various signal masks,
> coprocessor power control, etc. In such case, there is a need to have
> a dedicated driver for such system controller but also share registers
> with other drivers. The latter is where the syscon interface is helpful.
> 
> This patch decouples syscon object from syscon platform driver, and
> allows to create syscon objects first time when it is required by
> calling of syscon_regmap_lookup_by APIs and keeps a list of such syscon
> objects along with syscon provider device_nodes and regmap handles.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
> V1 of this patchset [1] and related discussion can be found here [1].
>  
> Changes since v1:
>  - Removed of_syscon_unregister function.
>  - Modified of_syscon_register function and it will be used by syscon.c 
>    to create syscon objects whenever required. 
>  - Removed platform device support from syscon.
>  - Removed syscon_regmap_lookup_by_pdevname API support.
>  - As there are significant changes w.r.t patchset v1, I am taking over
>    author for this patchset from Tomasz Figa.

I guess you should also drop my Signed-off-by too. I think the best
thing would replacing it with my Suggested-by and adding Arnd's
Suggested-by too.

Best regards,
Tomasz
