Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaLOPs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:48:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaLOPs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:48:56 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: os_dep: usb_intf.c: Fix for possible null pointer dereference
References: <1418596754-24735-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20141215103117.GC4856@mwanda>
Date: Mon, 15 Dec 2014 10:48:45 -0500
In-Reply-To: <20141215103117.GC4856@mwanda> (Dan Carpenter's message of "Mon,
	15 Dec 2014 13:31:17 +0300")
Message-ID: <wrfjbnn4vrqa.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> On Sun, Dec 14, 2014 at 11:39:14PM +0100, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>> 
>> Was largely found by using a static code analysis program called cppcheck.
>> 
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8723au/os_dep/usb_intf.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c
>> b/drivers/staging/rtl8723au/os_dep/usb_intf.c
>> index 865743e..71a6330 100644
>> --- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
>> +++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
>> @@ -351,10 +351,11 @@ error_exit:
>>  int rtw_hw_resume23a(struct rtw_adapter *padapter)
>
> That's weird.  Is this function even called?

[jes@ultrasam jes.git]$ find drivers/staging/rtl8723au -name \*.[ch] |xargs grep rtw_hw_resume
drivers/staging/rtl8723au/include/osdep_intf.h:int rtw_hw_resume23a(struct rtw_adapter *padapter);
drivers/staging/rtl8723au/os_dep/usb_intf.c:int rtw_hw_resume23a(struct rtw_adapter *padapter)
drivers/staging/rtl8723au/os_dep/usb_intf.c:		DBG_8723A("==> rtw_hw_resume23a\n");
[jes@ultrasam jes.git]$ find drivers/staging/rtl8723au -name \*.[ch] |xargs grep rtw_hw_suspend
drivers/staging/rtl8723au/include/osdep_intf.h:int rtw_hw_suspend23a(struct rtw_adapter *padapter);
drivers/staging/rtl8723au/os_dep/usb_intf.c:int rtw_hw_suspend23a(struct rtw_adapter *padapter)
drivers/staging/rtl8723au/os_dep/usb_intf.c:		DBG_8723A("==> rtw_hw_suspend23a\n");

A more useful patch would be one removing those two functions IMHO.

Jes
