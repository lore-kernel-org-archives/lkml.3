Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab3F0Ben (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:34:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41902 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab3F0Bem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:34:42 -0400
Message-ID: <1372296879.557.3.camel@dabdike>
Subject: Re: [PATCH RESEND v2 2/2] scsi: 64-bit port of buslogic driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khalid Aziz <khalid@gonehiking.org>
Date: Wed, 26 Jun 2013 18:34:39 -0700
In-Reply-To: <97daf2d29ceb78bdef3ddf6358dc634de35d0345.1368754556.git.khalid.aziz@oracle.com>
References: <cover.1368754558.git.khalid.aziz@oracle.com>
	 <97daf2d29ceb78bdef3ddf6358dc634de35d0345.1368754556.git.khalid.aziz@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 14:26 -0600, Khalid Aziz wrote: 
> @@ -5072,17 +5039,15 @@ static void FPT_busMstrSGDataXferStart(unsigned long p_port,
>   * Description: 
>   *
>   *---------------------------------------------------------------------*/
> -static void FPT_busMstrDataXferStart(unsigned long p_port,
> -				     struct sccb *pcurrSCCB)
> +static void FPT_busMstrDataXferStart(u32 p_port, struct sccb *pcurrSCCB)
>  {
> -	unsigned long addr, count;
> +	u32 addr, count;
>  
>  	if (!(pcurrSCCB->Sccb_XferState & F_AUTO_SENSE)) {
>  
>  		count = pcurrSCCB->Sccb_XferCnt;
>  
> -		addr =
> -		    (unsigned long)pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;
> +		addr = (u32)pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;

This is giving

In file included from drivers/scsi/BusLogic.c:57:0:
drivers/scsi/FlashPoint.c: In function ‘FPT_busMstrDataXferStart’:
drivers/scsi/FlashPoint.c:5050:10: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]

to do this cast, you need first to cast to unsigned long and then
truncate the long with u32.  I fixed it up.

James


