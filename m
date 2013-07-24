Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3GXQRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:17:33 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52701 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3GXQRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:17:32 -0400
Message-ID: <51EFFE1B.3050909@tilera.com>
Date: Wed, 24 Jul 2013 12:17:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 05/13] tile: support PTP using the tilegx mPIPE (IEEE
 1588)
References: <cover.1374609948.git.cmetcalf@tilera.com> <77f753af79722f39c5fa77cd35adefdd1634e5d5.1374609949.git.cmetcalf@tilera.com> <20130724062900.GB5163@netboy>
In-Reply-To: <20130724062900.GB5163@netboy>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/2013 2:29 AM, Richard Cochran wrote:
> On Tue, Jul 23, 2013 at 04:05:48PM -0400, Chris Metcalf wrote:
>
>> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>> index 5be73ba..255ed1a 100644
>> --- a/drivers/ptp/Kconfig
>> +++ b/drivers/ptp/Kconfig
>> @@ -87,4 +87,14 @@ config PTP_1588_CLOCK_PCH
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called ptp_pch.
>>  
>> +config PTP_1588_CLOCK_TILEGX
>> +        tristate "Tilera TILE-Gx mPIPE as PTP clock"
>> +        select PTP_1588_CLOCK
>> +        depends on TILEGX
>> +        help
>> +          This driver adds support for using the mPIPE as a PTP
>> +          clock. This clock is only useful if your PTP programs are
>> +          getting hardware time stamps on the PTP Ethernet packets
>> +          using the SO_TIMESTAMPING API.
>> +
> Is this feature available on every TILEGX hardware variant?
> If not, then there needs to be some provision for that.

It is.

> Also, this option should probably appear under the main MAC option.

By that I assume you mean in drivers/net/ethernet/tile/Kconfig?  I will do that.

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

