Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaD1Uha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:37:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:24409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbaD1Uh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:37:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502498347"
Message-ID: <535EBBA6.2090903@intel.com>
Date: Mon, 28 Apr 2014 22:35:50 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V5 02/12] PNPACPI: use whilte list for pnpacpi device
 enumeration
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>	 <1396886819-2637-3-git-send-email-rui.zhang@intel.com>	 <34978551.c1lKBcQLqc@vostro.rjw.lan> <1398649251.2443.2.camel@rzhang1-mobl4>
In-Reply-To: <1398649251.2443.2.camel@rzhang1-mobl4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 3:40 AM, Zhang Rui wrote:
> On Mon, 2014-04-28 at 00:01 +0200, Rafael J. Wysocki wrote:
>> On Tuesday, April 08, 2014 12:06:49 AM Zhang Rui wrote:
>>
>> [...]
>>
>>> +
>>> +static int acpi_pnp_scan_handler_attach(struct acpi_device *adev,
>>> +					const struct acpi_device_id *id)
>>> +{
>>> +	return 1;
>>> +}
>>> +
>>> +static int acpi_pnp_scan_handler_match(char *devid, char *handlerid)
>>> +{
>>> +	int i;
>>> +
>>> +	if (memcmp(devid, handlerid, 3))
>>> +		return 0;
>>> +
>>> +	for (i = 3; i < 7; i++) {
>>> +		/* Not a HEX value */
>>> +		if (!((devid[i] >= '0' && devid[i] <= '9') ||
>>> +		      (devid[i] > 'A' && devid[i] <= 'F')))
>>> +			return 0;
>>> +
>>> +		if ((handlerid[i] != 'X') &&
>> Hmm.  What exactly is the above check for?
>>
> PNP bus supports wildcard in the drivers' id list.
> say, drivers/tty/serial/8250/8250_pnp.c
>        {"WACFXXX"},            /* Wacom tablets */
> means the driver wants to try to probe all the PNP devices start with
> "WACF".

I see.  Maybe you can add a comment explaining this before that 
statement, then?

Rafael

