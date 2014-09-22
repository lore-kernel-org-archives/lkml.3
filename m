Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaIVN1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:27:38 -0400
Received: from smtp-out-048.synserver.de ([212.40.185.48]:1080 "EHLO
	smtp-out-047.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753578AbaIVN1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:27:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16922
Message-ID: <542023C8.8080802@metafoo.de>
Date: Mon, 22 Sep 2014 15:27:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: wsa@the-dreams.de, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices addresses
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com> <20140922104555.GQ1786@lahna.fi.intel.com>
In-Reply-To: <20140922104555.GQ1786@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 12:45 PM, Mika Westerberg wrote:
> On Fri, Sep 05, 2014 at 04:02:19PM +0200, Jean-Michel Hautbois wrote:
>> Some I2C devices have multiple addresses assigned, for example each address
>> corresponding to a different internal register map page of the device.
>> So far drivers which need support for this have handled this with a driver
>> specific and non-generic implementation, e.g. passing the additional address
>> via platform data.
>>
>> This patch provides a new helper function called i2c_new_secondary_device()
>> which is intended to provide a generic way to get the secondary address
>> as well as instantiate a struct i2c_client for the secondary address.
>>
>> The function expects a pointer to the primary i2c_client, a name
>> for the secondary address and an optional default address. The name is used
>> as a handle to specify which secondary address to get.
>>
>> The default address is used as a fallback in case no secondary address
>> was explicitly specified. In case no secondary address and no default
>> address were specified the function returns NULL.
>>
>> For now the function only supports look-up of the secondary address
>> from devicetree, but it can be extended in the future
>> to for example support board files and/or ACPI.
>>
>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>
> Sorry, just noticed this one.
>
> Srinivas (CC'd) and I did similar patch series here:
>
> http://patchwork.ozlabs.org/patch/338342/
>
> We should probably collaborate on this one to get both DT and ACPI
> supported.

Yes. The idea was to keep the interface of the API generic so it can be used 
by ACPI or other device topology description mechanisms as well.

But it looks as if the ACPI case is a bit more complex and we may need a 
revision of the API. How for example in the ACPI case do you know which 
address is which, when different parts of a chip are addressed using 
different addresses?

- Lars

