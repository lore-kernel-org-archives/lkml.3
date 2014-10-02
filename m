Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaJBNMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:12:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18782 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaJBNMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:12:41 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-bc-542d4f4770b8
Message-id: <542D4F4B.90400@samsung.com>
Date: Thu, 02 Oct 2014 16:12:43 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Roberto Sassu <roberto.sassu@polito.it>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-ima-devel] [PATCH v2 3/4] ima: check appraisal flag in the
 ima_file_free() hook
References: <cover.1412188590.git.d.kasatkin@samsung.com>
 <600aeb6a5b8eca7eb381392e142ca71484717e9c.1412188590.git.d.kasatkin@samsung.com>
 <542D0C33.2010700@polito.it> <542D1B4B.7040904@samsung.com>
 <542D2398.8000300@polito.it> <542D2C56.9040505@samsung.com>
 <542D3A28.5000603@polito.it>
 <1412255026.15991.32.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1412255026.15991.32.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xy7ru/rohBr92C1t8WVpn8XLGPHaL
	y7vmsFl86HnEZvFy1zd2i08rJjE7sHnsnHWX3ePBoc0sHrsXfGbyOL2y2OPzJrkA1igum5TU
	nMyy1CJ9uwSujK6PegWPuSqmt89kbGCcy9HFyMkhIWAicWhdMxOELSZx4d56ti5GLg4hgaWM
	Es+OP2UHSQgJNDJJfLtoApGYBZT4MYkZJMEroCFxZPUtNhCbRUBV4tHDy2A2m4CexIbmH2DN
	ogIREifv7mGHqBeU+DH5HguILSIQIrF14kYmkKHMAvMZJdZvfsYIkhAWSJU4ePc+1BlPmSRW
	LjsOluAU8JDY8/MKUAcHUIe6xJQpuSBhZgF5ic1r3jJDXKoq0b12LRvEO4oSpyefY57AKDwL
	ye5ZCN2zkHQvYGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESH192MC4+ZnWIUYCDUYmH
	N6NBJ0SINbGsuDL3EKMEB7OSCK+nu26IEG9KYmVValF+fFFpTmrxIUYmDk6pBsaZQvcuzYy2
	iFxgfdsh2Zlx7RkVP8uHPTtP2i8U//e4UzFQX+aRo07rIa4rvgrmG9gDf7umvm7dcLJ+8j27
	SPEHkrqt65pU7h4TTbfb/v1kEL9P8tKfdjHVHxKrPhW2rt+SmG52NupdxCkvvWXlSyTK9q5s
	ivqtnfOI78XlGx9CF23NFNrA+lCJpTgj0VCLuag4EQCGVr7nbQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/14 16:03, Mimi Zohar wrote:
>> Ok, thanks.
>> > 
>> > Acked-by: Roberto Sassu <roberto.sassu@polito.it>
>> > 
>> > Roberto Sassu
> Thanks, Dmitry, Roberto.  The patch and update description looks good.
> Please post the updated patch inline here on the mailing list.
>
> thanks,
>
> Mimi
>
>

Mimi, patch is the same what I posted 9:21 GMT and what Roberto acked.
Patch description updated based on Roberto's and Your comments

    ima: check ima_policy_flag in the ima_file_free() hook
   
    This patch completes the switching to the 'ima_policy_flag' variable
    in the checks at the beginning of IMA functions, starting with the
    commit a756024e.
   
    Checking 'iint_initialized' is completely unnecessary, because
    S_IMA flag is unset if iint was not allocated. At the same time
    the integrity cache is allocated with SLAB_PANIC and the kernel will
    panic if the allocation fails during kernel initialization. So on
    a running system iint_initialized is always true and can be removed.
   
    Changes in v3:
    * not limiting test to IMA_APPRAISE (spotted by Roberto Sassu)
   
    Changes in v2:
    * 'iint_initialized' removal patch merged to this patch (requested
       by Mimi)
   
    Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
    Acked-by: Roberto Sassu <roberto.sassu@polito.it>

