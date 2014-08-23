Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaHWPeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:34:44 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaHWPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:34:43 -0400
Message-ID: <53F8B48D.8060209@nod.at>
Date: Sat, 23 Aug 2014 17:34:37 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thorsten Knabe <linux@thorsten-knabe.de>
CC: linux-kernel@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] UML: UBD: Fix for processes stuck in D state forever
 in UserModeLinux
References: <53F89B7A.1040406@thorsten-knabe.de>
In-Reply-To: <53F89B7A.1040406@thorsten-knabe.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 23.08.2014 15:47, schrieb Thorsten Knabe:
> From: Thorsten Knabe <linux@thorsten-knabe.de>
> 
> UML: UBD: Fix for processes stuck in D state forever in UserModeLinux.
> 
> Starting with Linux 3.12 processes get stuck in D state forever in
> UserModeLinux under sync heavy workloads. This bug was introduced by
> commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
> Fix bug by adding a check if FLUSH request was successfully submitted to
> the I/O thread and keeping the FLUSH request on the request queue on
> submission failures.
> 
> Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
> Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>

Thanks a lot for hunting this issue down.

> ---
> Patch applies to 3.16.1.
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index 3716e69..b7d2840 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -1277,7 +1277,7 @@ static void do_ubd_request(struct request_queue *q)
> 
>  	while(1){
>  		struct ubd *dev = q->queuedata;
> -		if(dev->end_sg == 0){
> +		if(dev->request == NULL){

Why do we need this specific change?

Thanks,
//richard
