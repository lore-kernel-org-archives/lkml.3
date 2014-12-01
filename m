Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaLAQ5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:57:09 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:40996 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaLAQ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:57:06 -0500
Message-ID: <547C9DDF.5060906@lwfinger.net>
Date: Mon, 01 Dec 2014 10:57:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anjana Sasindran <anjanasasindran123@gmail.com>,
        gregkh@linuxfoundation.org, es.Sorensen@redhat.com
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: hal: Removed spaces before starting
 of a line
References: <1417449197-3227-1-git-send-email-anjanasasindran123@gmail.com>
In-Reply-To: <1417449197-3227-1-git-send-email-anjanasasindran123@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 09:53 AM, Anjana Sasindran wrote:
> This patch fix the checkpatch.pl warning:
>
> WARNING: please, no spaces at the start of a line
>
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>   drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
> index 88e0126..959e89e 100644
> --- a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
> +++ b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
> @@ -20,7 +20,7 @@ odm_ConfigRFReg_8723A(
>   	struct dm_odm_t *pDM_Odm,
>   	u32					Addr,
>   	u32					Data,
> -  enum RF_RADIO_PATH     RF_PATH,
> +enum RF_RADIO_PATH     RF_PATH,

NACK. You are blindly "fixing" a checkpatch warning, but you are making the code 
worse!! Obviously, this line should start with a tab to make the arguments of 
this routine line up. Even if you were to do that, the style would be wrong.

If I were fixing this section, my patch would look like:

--- a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
+++ b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
@@ -15,14 +15,8 @@

  #include "odm_precomp.h"

-void
-odm_ConfigRFReg_8723A(
-       struct dm_odm_t *pDM_Odm,
-       u32                                     Addr,
-       u32                                     Data,
-  enum RF_RADIO_PATH     RF_PATH,
-       u32                                 RegAddr
-       )
+void odm_ConfigRFReg_8723A(struct dm_odm_t *pDM_Odm, u32 Addr, u32 Data,
+			    enum RF_RADIO_PATH RF_PATH, u32 RegAddr)
  {
  	if (Addr == 0xfe) {
  		msleep(50);

That change would make the procedure entry line easier to read. Of course, the 
commit message would need to say something like "checkpatch warns of spaces at 
the beginning of a line. To fix this, the procedure entry is reformatted."

Caution, my patch fragment is white-space damaged. You will need to do it yourself.

>   	u32				    RegAddr
>   	)
>   {
> @@ -60,7 +60,7 @@ odm_ConfigBB_AGC_8723A(
>   	u32		Addr,
>   	u32		Bitmask,
>   	u32		Data
> -  )
> +)
>   {
>   	ODM_SetBBReg(pDM_Odm, Addr, Bitmask, Data);
>   	/*  Add 1us delay between BB/RF register setting. */
> @@ -77,7 +77,7 @@ odm_ConfigBB_PHY_8723A(
>   	u32		Addr,
>   	u32		Bitmask,
>   	u32		Data
> -  )
> +)
>   {
>   	if (Addr == 0xfe)
>   		msleep(50);
>

Same criticism here.

Larry

