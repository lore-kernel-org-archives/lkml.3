Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967334Ab3E3CcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:32:19 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56218 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967287Ab3E3CcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:32:11 -0400
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 22:32:11 EDT
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no> <1369860078-10334-2-git-send-email-jonarne@jonarne.no> <20130529213554.690f7eaa@redhat.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20130529213554.690f7eaa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC 1/3] saa7115: Set saa7113 init to values from datasheet
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 29 May 2013 22:19:49 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?ISO-8859-1?Q?Jon_Arne_J=F8rgensen?= <jonarne@jonarne.no>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
Message-ID: <7454763a-75fe-4d98-b7ab-29b6649dc25e@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-05-29_10:2013-05-29,2013-05-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=11
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1211240000 definitions=main-1305290312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>Em Wed, 29 May 2013 22:41:16 +0200
>Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
>
>> Change all default values in the initial setup table to match the
>table
>> in the datasheet.
>
>This is not a good idea, as it can produce undesired side effects
>on the existing drivers that depend on it, and can't be easily
>tested.
>
>Please, don't change the current "default". It is, of course, OK
>to change them if needed via the information provided inside the
>platform data.
>
>Regards,
>Mauro
>> 
>> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
>> ---
>>  drivers/media/i2c/saa7115.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/media/i2c/saa7115.c
>b/drivers/media/i2c/saa7115.c
>> index d6f589a..4403679 100644
>> --- a/drivers/media/i2c/saa7115.c
>> +++ b/drivers/media/i2c/saa7115.c
>> @@ -223,12 +223,12 @@ static const unsigned char saa7111_init[] = {
>>  static const unsigned char saa7113_init[] = {
>>  	R_01_INC_DELAY, 0x08,
>>  	R_02_INPUT_CNTL_1, 0xc2,
>> -	R_03_INPUT_CNTL_2, 0x30,
>> +	R_03_INPUT_CNTL_2, 0x33,
>>  	R_04_INPUT_CNTL_3, 0x00,
>>  	R_05_INPUT_CNTL_4, 0x00,
>> -	R_06_H_SYNC_START, 0x89,
>> +	R_06_H_SYNC_START, 0xe9,
>>  	R_07_H_SYNC_STOP, 0x0d,
>> -	R_08_SYNC_CNTL, 0x88,
>> +	R_08_SYNC_CNTL, 0x98,
>>  	R_09_LUMA_CNTL, 0x01,
>>  	R_0A_LUMA_BRIGHT_CNTL, 0x80,
>>  	R_0B_LUMA_CONTRAST_CNTL, 0x47,
>> @@ -236,11 +236,11 @@ static const unsigned char saa7113_init[] = {
>>  	R_0D_CHROMA_HUE_CNTL, 0x00,
>>  	R_0E_CHROMA_CNTL_1, 0x01,
>>  	R_0F_CHROMA_GAIN_CNTL, 0x2a,
>> -	R_10_CHROMA_CNTL_2, 0x08,
>> +	R_10_CHROMA_CNTL_2, 0x00,
>>  	R_11_MODE_DELAY_CNTL, 0x0c,
>> -	R_12_RT_SIGNAL_CNTL, 0x07,
>> +	R_12_RT_SIGNAL_CNTL, 0x01,
>>  	R_13_RT_X_PORT_OUT_CNTL, 0x00,
>> -	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,
>> +	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,	/* RESERVED */
>>  	R_15_VGATE_START_FID_CHG, 0x00,
>>  	R_16_VGATE_STOP, 0x00,
>>  	R_17_MISC_VGATE_CONF_AND_MSB, 0x00,
>
>
>-- 
>
>Cheers,
>Mauro
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I was going to make a comment along the same line as Mauro.  
Please leave the driver defaults alone.  It is almost impossible to regression test all the different devices with a SAA7113 chip, to ensure the change doesn't cause someone's device to not work properly.

Regards,
Andy

