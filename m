Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaHBJzP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 05:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbaHBJzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 05:55:13 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Miguel Oliveira <cmroliv@gmail.com>, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix static symbol sparse warning
References: <1406898387-13987-1-git-send-email-cmroliv@gmail.com>
	<53DBA840.6050804@lwfinger.net>
Date: Sat, 02 Aug 2014 11:55:02 +0200
In-Reply-To: <53DBA840.6050804@lwfinger.net> (Larry Finger's message of "Fri,
	01 Aug 2014 09:46:24 -0500")
Message-ID: <wrfjwqarfc7d.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 08/01/2014 08:06 AM, Miguel Oliveira wrote:
>> Fix sparse warning:
>> drivers/staging/rtl8723au/core/rtw_efuse.c:579:5: warning: symbol
>> efuse_GetCurrentSize23a' was not declared. Should it be static?
>> 
>> Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
>> ---
>>  drivers/staging/rtl8723au/include/rtw_efuse.h |    1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/staging/rtl8723au/include/rtw_efuse.h
>> b/drivers/staging/rtl8723au/include/rtw_efuse.h
>> index 07bdc34..304cc71 100644
>> --- a/drivers/staging/rtl8723au/include/rtw_efuse.h
>> +++ b/drivers/staging/rtl8723au/include/rtw_efuse.h
>> @@ -82,6 +82,7 @@ struct pg_pkt_struct {
>>  /*------------------------Export global
>> variable----------------------------*/
>>  
>>  u16	efuse_GetMaxSize23a(struct rtw_adapter *padapter);
>> +int	efuse_GetCurrentSize23a(struct rtw_adapter *padapter, u16 *size);
>>  int rtw_efuse_access23a(struct rtw_adapter *padapter, u8 bRead, u16
>> start_addr, u16 cnts, u8 *data);
>>  int rtw_efuse_map_read23a(struct rtw_adapter *padapter, u16 addr,
>> u16 cnts, u8 *data);
>>  u8 rtw_efuse_map_write(struct rtw_adapter *padapter, u16 addr, u16
>> cnts, u8 *data);
>
> NACK. Whenever Sparse issues this warning, you should first check to see if it
> can be made static. Adding it to a header to make the Sparse warning go away is
> not correct unless some other routine needs it to be globally known. In this
> case, no other routine needs it.
>
> Of course, making it static will lead to the compilation warning that the
> routine is not used. The correct patch is to delete the entire routine as it is
> never called.

Yep, fix it correctly, or don't bother!

Cheers,
Jes
