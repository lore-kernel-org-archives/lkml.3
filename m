Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaGHUFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:05:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52150 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaGHUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:05:43 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BC4F15.9030608@roeck-us.net>
Date: Tue, 08 Jul 2014 13:05:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: stub: Add support for SMBus block commands
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net> <20140708215453.0677d3ed@endymion.delvare>
In-Reply-To: <20140708215453.0677d3ed@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 07/08/2014 12:54 PM, Jean Delvare wrote:
> Hi Guenter,
>
> On Mon,  7 Jul 2014 07:23:03 -0700, Guenter Roeck wrote:
>> SMBus block commands are different to I2C block commands since
>> the returned data is not normally accessible with byte or word
>> commands on other command offsets. Add linked list of 'block'
>> commands to support those commands.
>>
>> Access mechanism is quite simple: Block commands must be written
>> before they can be read. The first write selects the block length.
>> Subsequent writes can be partial. Block read commands always return
>> the number of bytes selected with the first write.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v2: Make new functionality only available on request via functionality
>>      module parameter
>>      Add more details about SMBus block mode support to documentation
>>      Use correct sizeof() variable in devm_kzalloc
>>      Use stub_find_block() only in SMBus block command itself.
>>      Store first word of block data in chip->words[].
>>      When writing block data and the written data is longer than
>>      the first write, bail out with debug message indicating the reason
>>      for the error.
>
> Looks good, thanks for the quick update.
>
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
>
> Just one thing I have been thinking about while reviewing the updated
> code... You decided to make the first SMBus block write select the
> maximum block length, and you always use that for SMBus block reads.
> However you accept partial writes. The fact that the order in which
> writes are performed has an effect on which writes are accepted is
> somewhat unexpected.
>
> Wouldn't it make more sense to accept all SMBus block writes,
> regardless of the size (as long as it is within the limits of the SMBus
> standard, of course)? Then the only thing left to decide is whether
> SMBus block reads use the maximum size or the size of the most recent
> SMBus block write.
>
> I suspect this would mimic the behavior of real chips better. What do
> you think?
>

Not really sure what the expected behavior is. My original code
accepted all writes and returned the most recent write, including
the most recent write length. I thought this was untypical, and that
it would be more typical for the chip to return a fixed length.
But ultimately I don't really know, and I am fine either way.

Guenter

