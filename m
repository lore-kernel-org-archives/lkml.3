Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaKDQI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:08:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKDQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:08:26 -0500
Date: Tue, 4 Nov 2014 08:07:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] of/platform: Move platform devices under
 /sys/devices/platform
Message-ID: <20141104160716.GA1630@kroah.com>
References: <1415097920-30014-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415097920-30014-1-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:45:20AM +0000, Grant Likely wrote:
> Currently the devices created by drivers/of/platform.c get created at
> the root of /sys/devices. This goes against the typical pattern for
> sysfs where the top level /sys/devices structure contains categories of
> devices, and the structure of devices is placed below that. To fix this,
> make the code in drivers/of/platform.c follow the drivers/base/platform.c
> behaviour, and use &platform_bus as the default parent for all new
> platform_devices and amba_devices.
> 
> This change has been discussed for a long time, but nobody has actually
> acted on it. Userspace code that expects to find devices under a fixed
> /sys/devices/... path will be affected. It isn't /supposed/ to do that,
> but if anyone complains then I'll add a default-off workaround option to
> put them back into the root.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
