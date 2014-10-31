Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbaJaSI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:08:28 -0400
Received: from mout.web.de ([212.227.17.11]:64861 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137AbaJaSIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:08:25 -0400
Message-ID: <5453D013.9000007@users.sourceforge.net>
Date: Fri, 31 Oct 2014 19:08:19 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH resent] staging: rtl8188eu: Deletion of unnecessary checks
 before three function calls
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <544954FD.8040607@users.sourceforge.net> <20141029084702.GA18675@kroah.com> <5453CD0D.9010206@users.sourceforge.net> <alpine.DEB.2.10.1410311900201.2481@hadrien>
In-Reply-To: <alpine.DEB.2.10.1410311900201.2481@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:9YF9+rGtgZk7wBVTxGXVCorISY4WUqpn6KFNemSRf5Vw5XPbEg9
 mnBnsajXquoLB5UcoMOuWq85SAeVSp65PwaI1aQrLYHDmTXgmhqVnjFwHIqpSxsTcfK9GPu
 dSooUFEShd8seBpqDzYwI0KJn9hnU1LmZ/jhYZWbhz8YljteY79iA89RL6SKoYhBJcdhFrw
 FVvzup5f48z/L0QUkgevA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The functions kfree(), rtw_free_netdev() and vfree() test whether their
>> argument is NULL and then return immediately. Thus the test around the call
>> is not needed.
>>
>> This issue was detected by using the Coccinelle software.
>>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> ---
>>  drivers/staging/rtl8188eu/core/rtw_efuse.c   | 3 +--
>>  drivers/staging/rtl8188eu/core/rtw_mlme.c    | 3 +--
>>  drivers/staging/rtl8188eu/core/rtw_sta_mgt.c | 3 +--
>>  drivers/staging/rtl8188eu/core/rtw_xmit.c    | 6 ++----
>>  drivers/staging/rtl8188eu/os_dep/usb_intf.c  | 5 ++---
>>  5 files changed, 7 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c
>> b/drivers/staging/rtl8188eu/core/rtw_efuse.c
>> index 7006088..77f7552 100644
>> --- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
>> +++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
>> @@ -212,8 +212,7 @@ efuse_phymap_to_logical(u8 *phymap, u16 _offset, u16
>> _size_byte, u8  *pbuf)
>>  exit:
>>  	kfree(efuseTbl);
>>
>> -	if (eFuseWord)
>> -		kfree(eFuseWord);
>> +	kfree(eFuseWord);
> 
> I think that this code has been updated already.  It would be better to
> add labels so that kfree is only executed when needed.

Are there any chances to achieve the suggested fine-tuning for jump labels
also with another semantic patch approach?

Regards,
Markus
