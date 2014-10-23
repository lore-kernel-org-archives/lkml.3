Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaJWRFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:05:38 -0400
Received: from marcansoft.com ([213.138.101.166]:50507 "EHLO
	mail.marcansoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaJWRFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:05:37 -0400
Message-ID: <5449355C.2060301@marcansoft.com>
Date: Fri, 24 Oct 2014 02:05:32 +0900
From: Hector Martin <hector@marcansoft.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russ Dill <russ.dill@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R devices
References: <5448F83A.7010903@marcansoft.com> <CA+Bv8XbpqJZiKFA2PsY7DFMcGxzG=bfZv5oR45k2gx7rQivLGA@mail.gmail.com>
In-Reply-To: <CA+Bv8XbpqJZiKFA2PsY7DFMcGxzG=bfZv5oR45k2gx7rQivLGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/14 23:14, Russ Dill wrote:
> On Thu, Oct 23, 2014 at 5:44 AM, Hector Martin <hector@marcansoft.com> wrote:
>> +       write_eeprom(port, 0, eeprom_data[0]);
>> +       write_eeprom(port, 1, 0);
>> +       write_eeprom(port, eeprom_size - 2, eeprom_data[eeprom_size - 2]);
>> +       write_eeprom(port, eeprom_size - 1, checksum);
> 
> Damned off by one errors. Yes, it should be the product ID, not the
> vendor ID. These write u16's though, writing to wIndex 2 writes to
> bytes 4 and 5. the correct code is:
> 
> write_eeprom(port, 2, 0);
> write_eeprom(port, eeprom_size - 2, checksum);
> 
> And yes, the checksum code needs to be modified to create a specially
> crafted value that allows the existing checksum to pass.

Oh, I thought/assumed that the switch to VID and the real checksum was a
deliberate attempt at perversing the original code into something that
bricks even real FTDIs :-) (In which case all you'd need to add is the
two extra dummy writes, to load the proper data into the buffer register
on a real FT232RL to prevent it from corrupting the adjacent EEPROM words).

-- 
Hector Martin (hector@marcansoft.com)
Public Key: http://www.marcansoft.com/marcan.asc

