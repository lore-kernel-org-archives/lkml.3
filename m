Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3HETBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:01:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:10358 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3HETBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:01:03 -0400
Message-ID: <51FFF66B.4020203@atmel.com>
Date: Mon, 5 Aug 2013 20:00:59 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] staging: ozwpan: Return correct hub status.
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com> <1375724415-10801-5-git-send-email-rupesh.gujare@atmel.com> <20130805185643.GM5051@mwanda>
In-Reply-To: <20130805185643.GM5051@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/13 19:56, Dan Carpenter wrote:
> On Mon, Aug 05, 2013 at 06:40:15PM +0100, Rupesh Gujare wrote:
>> Fix a bug where we were not returning correct hub status
>> for 8th port.
> What are the user visible effects of this bug?

8 th port is never assigned to new device & we loose one port.

> Style nits below.
>
>> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
>> ---
>>   drivers/staging/ozwpan/ozhcd.c |   11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
>> index b060e43..2f93a00 100644
>> --- a/drivers/staging/ozwpan/ozhcd.c
>> +++ b/drivers/staging/ozwpan/ozhcd.c
>> @@ -1871,17 +1871,24 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
>>   	int i;
>>   
>>   	buf[0] = 0;
>> +	buf[1] = 0;
>>   
>>   	spin_lock_bh(&ozhcd->hcd_lock);
>>   	for (i = 0; i < OZ_NB_PORTS; i++) {
>>   		if (ozhcd->ports[i].flags & OZ_PORT_F_CHANGED) {
>>   			oz_dbg(HUB, "Port %d changed\n", i);
>>   			ozhcd->ports[i].flags &= ~OZ_PORT_F_CHANGED;
>> -			buf[0] |= 1<<(i+1);
>> +			if (i < 7)
>> +				buf[0] |= 1 << (i+1);
> Put spaces around math operations:
> 				buf[0] |= 1 << (i + 1);
>
>> +			else
>> +				buf[1] |= 1 << (i-7);
> 				buf[1] |= 1 << (i - 7);
>
>
Ok. I will rework on style nits.

-- 
Regards,
Rupesh Gujare

