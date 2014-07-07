Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaGGJ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:28:47 -0400
Received: from asav22.altibox.net ([109.247.116.9]:55152 "EHLO
	asav22.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaGGJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:28:44 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 05:28:43 EDT
Message-ID: <53BA66F6.9020605@tronnes.org>
Date: Mon, 07 Jul 2014 11:23:02 +0200
From: Noralf Tronnes <notro@tronnes.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: sis: init.c:  Cleaning up redundant condition
 is always true
References: <1404422121-11298-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20140707075709.GI25934@mwanda>
In-Reply-To: <20140707075709.GI25934@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 140706-1, 06.07.2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Den 07.07.2014 09:57, skrev Dan Carpenter:
> On Thu, Jul 03, 2014 at 11:15:21PM +0200, Rickard Strandqvist wrote:
>> diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/init.c
>> index bd40f5e..9e2dd96 100644
>> --- a/drivers/video/fbdev/sis/init.c
>> +++ b/drivers/video/fbdev/sis/init.c
>> @@ -355,12 +355,12 @@ SiS_GetModeID(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
>>   		}
>>   		break;
>>   	case 400:
>> -		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 800) && (LCDwidth >= 600))) {
>> +		if ((!(VBFlags & CRT1_LCDA)) || (LCDwidth >= 600)) {
>
> It might be that this was supposed to be:
>
> 		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth <= 800) && (LCDwidth >= 600))) {
>
> But why would people write a range from high to low?  That's crazy
> people who write backwards code...
The numbers 800x600 (1024x768) indicate that LCDheight is meant to be used:
                  if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 800) && 
(LCDheight >= 600))) {

regards,
Noralf Tronnes

