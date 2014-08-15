Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaHOGfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:35:31 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:53571 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbaHOGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:35:30 -0400
Message-ID: <53EDAA24.3080705@ladisch.de>
Date: Fri, 15 Aug 2014 08:35:16 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux@roeck-us.net, jdelvare@suse.de, rdunlap@infradead.org,
        bp@suse.de
CC: lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] hwmon, k10temp: Add support for F15h M60h
References: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
In-Reply-To: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aravind Gopalakrishnan wrote:
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

Acked-by: Clemens Ladisch <clemens@ladisch.de>
