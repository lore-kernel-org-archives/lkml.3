Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3FSQrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:47:14 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59571 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3FSQrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:47:12 -0400
Message-ID: <51C1E08C.9040900@gmail.com>
Date: Wed, 19 Jun 2013 09:47:08 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 3/5] tty/8250_dw: Add support for OCTEON UARTS.
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com> <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com> <20130619141008.GA32331@xps8300>
In-Reply-To: <20130619141008.GA32331@xps8300>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 07:10 AM, Heikki Krogerus wrote:
> On Tue, Jun 18, 2013 at 12:12:53PM -0700, David Daney wrote:
>> A few differences needed by OCTEON:
>>
>> o These are DWC UARTS, but have USR at a different offset.
>>
>> o OCTEON must have 64-bit wide register accesses, so we have OCTEON
>>    specific register accessors.
>>
>> o No UCV register, so we hard code some properties.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>
> <snip>
>
>> @@ -270,10 +301,8 @@ static int dw8250_probe(struct platform_device *pdev)
>>   	uart.port.serial_out = dw8250_serial_out;
>>   	uart.port.private_data = data;
>>
>> -	dw8250_setup_port(&uart);
>> -
>>   	if (pdev->dev.of_node) {
>> -		err = dw8250_probe_of(&uart.port);
>> +		err = dw8250_probe_of(&uart.port, data);
>>   		if (err)
>>   			return err;
>>   	} else if (ACPI_HANDLE(&pdev->dev)) {
>> @@ -284,6 +313,9 @@ static int dw8250_probe(struct platform_device *pdev)
>>   		return -ENODEV;
>>   	}
>>
>> +	if (!data->no_ucv)
>> +		dw8250_setup_port(&uart);
>
> Moving the dw8250_setup_port() call here breaks dw8250_probe_acpi(). It
> expects values from the CPR register for the DMA burst size calculation.
>
> The DMA support can be moved to a separate function. This way it can
> be called after this point, and it will then be available for both DT
> and ACPI. I can make a patch tomorrow. That should solve this issue.
>

I am reworking the patch because other problems were found.  I will try 
to get this part right in the next version.

David Daney

