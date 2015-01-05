Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbbAEBko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:40:44 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48884 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbbAEBkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:40:43 -0500
Message-ID: <54A9EB99.30806@lwfinger.net>
Date: Sun, 04 Jan 2015 19:40:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexander Kuleshov <kuleshovmail@gmail.com>
CC: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192e: Fix duplicated conditional branch
References: <1420354755-5261-1-git-send-email-kuleshovmail@gmail.com> <1420355446.2619.18.camel@perches.com>
In-Reply-To: <1420355446.2619.18.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2015 01:10 AM, Joe Perches wrote:
> On Sun, 2015-01-04 at 12:59 +0600, Alexander Kuleshov wrote:
>> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> []
>> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
> []
>> @@ -1661,7 +1661,7 @@ void dm_change_dynamic_initgain_thresh(struct net_device *dev,
>>   		dm_digtable.rssi_low_thresh = dm_value;
>>   	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
>>   		dm_digtable.rssi_high_power_highthresh = dm_value;
>> -	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
>> +	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_LOW) {
>>   		dm_digtable.rssi_high_power_highthresh = dm_value;
>>   	} else if (dm_type == DIG_TYPE_ENABLE) {
>>   		dm_digtable.dig_state		= DM_STA_DIG_MAX;
>
> Presumably, this is a copy/paste error and should have
> both lines changed to HIGHPWR_LOW/high_power_lowthresh
>
> 	else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_LOW)
> 		dm_digtable.rssi_high_power_lowthresh = dm_value;
>

I have no idea what this should be, but this patch does not appear to be any 
improvement. Joe is probably correct.

Larry


