Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbbAMRRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:17:24 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:48081 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbbAMRRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:17:22 -0500
MIME-Version: 1.0
In-Reply-To: <20150113112854.GA7660@katana>
References: <1418357907-4215-1-git-send-email-harinik@xilinx.com>
	<1418357907-4215-2-git-send-email-harinik@xilinx.com>
	<20150113112854.GA7660@katana>
Date: Tue, 13 Jan 2015 22:47:20 +0530
Message-ID: <CAFcVECK5PmvmHpGmtVdyc=rrv7bj97bjR5LuZQoehVhgn3Xbxw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] i2c: cadence: Handle > 252 byte transfers
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 13, 2015 at 4:58 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Fri, Dec 12, 2014 at 09:48:26AM +0530, Harini Katakam wrote:
>> The I2C controller sends a NACK to the slave when transfer size register
>> reaches zero, irrespective of the hold bit. So, in order to handle transfers
>> greater than 252 bytes, the transfer size register has to be maintained at a
>> value >= 1. This patch implements the same.
>> The interrupt status is cleared at the beginning of the isr instead of
>> the end, to avoid missing any interrupts.
>>
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>
> Applied to for-next, thanks!
>
>> @@ -333,10 +359,11 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
>>        * receive if it is less than transfer size and transfer size if
>>        * it is more. Enable the interrupts.
>>        */
>> -     if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
>> +     if (id->recv_count > CDNS_I2C_TRANSFER_SIZE) {
>>               cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
>>                                 CDNS_I2C_XFER_SIZE_OFFSET);
>> -     else
>> +             id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE;
>> +     } else
>>               cdns_i2c_writereg(id->recv_count, CDNS_I2C_XFER_SIZE_OFFSET);
>
> else branch must have braces, too! I fixed that.

Thanks!

Regards,
Harini
