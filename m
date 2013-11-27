Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3K0JZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:25:26 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51478 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3K0JZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:25:23 -0500
Message-ID: <5295BB05.1030506@gmail.com>
Date: Wed, 27 Nov 2013 17:27:33 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: marek.belisko@gmail.com, kelleynnn@gmail.com, linux@rainbow-software.org,
        peter.p.waskiewicz.jr@intel.com, rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers: staging: ft1000: ft1000-usb: initialize 'status'
 with STATUS_SUCCESS in request_code_segment()
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com> <5295607E.2000504@gmail.com> <20131127091841.GA19465@leaf>
In-Reply-To: <20131127091841.GA19465@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 05:18 PM, Josh Triplett wrote:
> On Wed, Nov 27, 2013 at 11:01:18AM +0800, Chen Gang wrote:
>> If "!bool_case", it returns unexpected value instead of STATUS_SUCCESS,
>> so need fix it, the related warning (with allmodconfig under hexagon):
>>
>>     CC [M]  drivers/staging/ft1000/ft1000-usb/ft1000_download.o
>>   drivers/staging/ft1000/ft1000-usb/ft1000_download.c: In function 'request_code_segment':
>>   drivers/staging/ft1000/ft1000-usb/ft1000_download.c:581:6: warning: 'status' may be used uninitialized in this function [-Wuninitialized]
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 

Thanks.  :-)

>>  .../staging/ft1000/ft1000-usb/ft1000_download.c    |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
>> index 68ded17..15f3062 100644
>> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
>> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
>> @@ -578,7 +578,7 @@ static int request_code_segment(struct ft1000_usb *ft1000dev, u16 **s_file,
>>  		 u8 **c_file, const u8 *endpoint, bool boot_case)
>>  {
>>  	long word_length;
>> -	int status;
>> +	int status = STATUS_SUCCESS;
>>  
>>  	/*DEBUG("FT1000:REQUEST_CODE_SEGMENT\n");i*/
>>  	word_length = get_request_value(ft1000dev);
>> -- 
>> 1.7.7.6


-- 
Chen Gang
