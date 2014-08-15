Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaHOGQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:16:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaHOGQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:16:55 -0400
Date: Fri, 15 Aug 2014 08:16:28 +0200
From: Borislav Petkov <bp@suse.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: clemens@ladisch.de, linux@roeck-us.net, jdelvare@suse.de,
        rdunlap@infradead.org, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] hwmon, k10temp: Add support for F15h M60h
Message-ID: <20140815061628.GC23775@pd.tnic>
References: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 06:15:27PM -0500, Aravind Gopalakrishnan wrote:
> This patch adds temperature monitoring support for F15h M60h processor.
>  - Add new pci device id for the relevant processor
>  - The functionality of REG_REPORTED_TEMPERATURE is moved to
>    D0F0xBC_xD820_0CA4 [Reported Temperature Control]
>    - So, use this to get CUR_TEMP value
>    - Since we need an indirect register access, protect this with
>      a mutex lock
>  - Add Kconfig, Doc entries to indicate support for this processor.
> 
> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> ---
> Changes in V3:
>  - Move helper function that protects indirect register access locally
>    until a time when others outside k10temp may need it
>    
> Changes in V2:
>  - Prevent race with other code that may require indirect NB_SMU_REG access
>  - Fix some minor style issues
> 
>  Documentation/hwmon/k10temp |  2 +-
>  drivers/hwmon/Kconfig       |  4 ++--
>  drivers/hwmon/k10temp.c     | 35 ++++++++++++++++++++++++++++++++---
>  3 files changed, 35 insertions(+), 6 deletions(-)

Looks good to me.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
