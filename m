Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaG1JQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:16:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36390 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaG1JQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:16:20 -0400
Message-ID: <53D614D8.4070309@ti.com>
Date: Mon, 28 Jul 2014 12:16:08 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <dmitry.torokhov@gmail.com>, <tony@atomide.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v7 0/5] Input: pixcir_i2c_ts: Add Type-B Multi-touch and
 DT support
References: <1402997507-9736-1-git-send-email-rogerq@ti.com> <53B523AE.70601@ti.com>
In-Reply-To: <53B523AE.70601@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Gentle ping. Would be nice to get these into 3.17. Thanks :).

cheers,
-roger

On 07/03/2014 12:34 PM, Roger Quadros wrote:
> Hi Dmitry,
> 
> Gentle reminder to pick this series for -next. Thanks :).
> 
> cheers,
> -roger
> 
> On 06/17/2014 12:31 PM, Roger Quadros wrote:
>> Hi Dmitry,
>>
>> These are the pending patches that didn't go through in the 3.16 merge window.
>> Please queue them for -next. Thanks.
>>
>> The series does the following
>> - convert to Type-B multi touch protocol
>> - support upto 5 fingers with hardware supplied tracking IDs
>> - device tree support
>>
>> Tony,
>>
>> The last 2 patches fix the touch screen size property in the device tree since
>> we now use the unified touch screen properties.
>>
>> cheers,
>> -roger
>>
>> Changelog:
>>
>> v7:
>> - Rebased on 3.16-rc1.
>>
>> v6:
>> - Use unified touchscreen bindings.
>> - Update pointer math i.e. bufptr += 4 instead of &bufptr[4];
>>
>> v5:
>> - Changed ts->exiting flag to ts->running in patch 2.
>> - Don't call pixcir_stop() from .suspend() if wakeup is required.
>>
>> v4:
>> - Imporved pixcir_stop() as per Dmitry's suggestion.
>> - Removed unnecessary input_unregister_device() from .remove().
>>
>> v3:
>> - Rebased to 3.15-rc3
>> - Fixed suspend while touchscreen in use
>> - Fixed module removal while touchscreen in use
>>
>> v2:
>> - Addressed review comments and re-arranged patch order
>>
>> v1:
>> - http://article.gmane.org/gmane.linux.kernel/1616417
>>
>> --
>>
>> Roger Quadros (5):
>>   Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
>>   Input: pixcir_i2c_ts: support upto 5 fingers and hardware provided
>>     tracking IDs
>>   Input: pixcir_i2c_ts: Add device tree support
>>   ARM: dts: am43x-epos-evm: Update binding for touchscreen size
>>   ARM: dts: am437x-gp-evm: Update binding for touchscreen size
>>
>>  .../bindings/input/touchscreen/pixcir_i2c_ts.txt   |  26 +++
>>  .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>>  arch/arm/boot/dts/am437x-gp-evm.dts                |   4 +-
>>  arch/arm/boot/dts/am43x-epos-evm.dts               |   4 +-
>>  drivers/input/touchscreen/pixcir_i2c_ts.c          | 251 ++++++++++++++++++---
>>  include/linux/input/pixcir_ts.h                    |  12 +
>>  6 files changed, 259 insertions(+), 39 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
>>
> 

