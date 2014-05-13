Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaEMOHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:07:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:6757 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbaEMOHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="510911268"
Message-ID: <53722700.6010001@intel.com>
Date: Tue, 13 May 2014 22:06:56 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rolf Eike Beer <eb@emlix.com>
CC: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 0/9] I2C ACPI operation region handler support
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-1-git-send-email-tianyu.lan@intel.com> <3275231.ERSr3mUlis@devpool02>
In-Reply-To: <3275231.ERSr3mUlis@devpool02>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 09:09 PM, Rolf Eike Beer wrote:
> Am Montag, 28. April 2014, 22:27:39 schrieb Lan Tianyu:
>> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
>> region. It allows ACPI aml code able to access such kind of devices to
>> implement some ACPI standard method.
>>
>> On the Asus T100TA, Bios use GenericSerialBus operation region to access
>> i2c device to get battery info. So battery function depends on the I2C
>> operation region support. Here is the bug link.
>> https://bugzilla.kernel.org/show_bug.cgi?id=69011
>
> Hi all,
>
> I have tested this series and got some errors, but no additional functionality:
>

Hi Rolf:
	Thanks for test. Could you attach the output of dmesg and acpidump?
Which machine you are testing on?

> [    0.607442] ACPI Error: Error attaching device[f60238a0] data
> [    0.607460]  (20140214/bus-143)
> [    0.607708] ACPI Error: Error attaching device[f60238a0] data
> [    0.607724]  (20140214/bus-143)
> [    0.607987] ACPI Error: Error attaching device[f60238a0] data
> [    0.608003]  (20140214/bus-143)
> [    0.608251] ACPI Error: Error attaching device[f60238a0] data
> [    0.608267]  (20140214/bus-143)
> [    0.608515] ACPI Error: Error attaching device[f60238a0] data
> [    0.608531]  (20140214/bus-143)
>
> A bit more output, e.g. the error code if such is present or the device path,
> could probably help when identifyint the device in question.
>
> Also this still looks incomplete, as on other places one still gets those
> warnings:
>
> [    0.314944] pnp 00:08: Plug and Play ACPI device, IDs INT33fc (active)
> [    0.316122] pnp 00:09: unknown resource type 19 in _CRS
> [    0.316136] pnp 00:09: can't evaluate _CRS: 1
>
> I don't know if looking on them at this place has any value, maybe something
> like this is correct?
>
> commit 52e2822c4c8b09180e5eb3dd94e4e9aea0d25eff
> Author: Rolf Eike Beer <eb@emlix.com>
> Date:   Tue Feb 18 11:11:10 2014 +0100
>
>      ACPI: ignore GPIO and SERIAL_BUS resources in PNP init code
>
> diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
> index 167f3d0..5b8459b 100644
> --- a/drivers/pnp/pnpacpi/rsparser.c
> +++ b/drivers/pnp/pnpacpi/rsparser.c
> @@ -240,6 +240,8 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
>                  break;
>
>          case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
> +       case ACPI_RESOURCE_TYPE_GPIO:
> +       case ACPI_RESOURCE_TYPE_SERIAL_BUS:
>                  break;
>
>          default:
>
> Greetings,
>
> Eike
>

