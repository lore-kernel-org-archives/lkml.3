Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3J2S67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:58:59 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56109 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3J2S65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:58:57 -0400
Message-ID: <5270056F.4030702@linux.com>
Date: Tue, 29 Oct 2013 19:58:55 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux IDE/ATA Dev <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] ata: libata-eh: Remove unnecessary snprintf arithmetic
References: <527000AE.8060506@linux.com> <20131029185302.GA22261@mtj.dyndns.org>
In-Reply-To: <20131029185302.GA22261@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-29 19:53 keltezéssel, Tejun Heo írta:
> Hello,
> 
> On Tue, Oct 29, 2013 at 07:38:38PM +0100, Levente Kurusa wrote:
>> Remove an unnecessary arithmetic operation from a call to snprintf, because
>> the size parameter of snprintf includes the trailing null byte.
>>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
>> ---
>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>> index f9476fb..b7c4146 100644
>> --- a/drivers/ata/libata-eh.c
>> +++ b/drivers/ata/libata-eh.c
>> @@ -2427,7 +2434,7 @@ static void ata_eh_link_report(struct ata_link *link)
>>
>>  	memset(tries_buf, 0, sizeof(tries_buf));
> 
> While at it, can you please remove the above and just initialize the
> buffer to "" on definition?

Sure, sending v2 in a moment.

-- 
Regards,
Levente Kurusa
