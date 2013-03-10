Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3CJIWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:22:52 -0400
Received: from mx0.parallels.com ([199.115.104.20]:53548 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CJIWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:22:48 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH -mmotm] scsi: fix the wrong position of the comment
Thread-Topic: [PATCH -mmotm] scsi: fix the wrong position of the comment
Thread-Index: AQHOHWaugnbpva3RokGvOc0XzwiVrJifC22A
Date: Sun, 10 Mar 2013 08:22:47 +0000
Message-ID: <1362903765.3003.2.camel@dabdike.int.hansenpartnership.com>
References: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [46.65.52.191]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <19E55EEC942AF247B1B31F6E961DDC95@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[missing SCSI cc added]
On Sun, 2013-03-10 at 17:09 +0900, Akinobu Mita wrote:
> This fixes the wrong position of the comment introduced by
> scsi-rename-random32-to-prandom_u32.patch in the -mm tree.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 04bf7b8..e44d47e 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>  	}
>  
>  	/* No pending activities shall be there on the vha now */
> -	if (ql2xextended_error_logging & ql_dbg_user)
> -		msleep(prandom_u32() % 10);
> +	if (ql2xextended_error_logging & ql_dbg_user) {
>  		/*
>  		 * Just to see if something falls on the net we have placed
>  		 * below
>  		 */
> -
> +		msleep(prandom_u32() % 10);
> +	}

I don't git a toss if it's random or prandom: Andrew: get rid of it; we
do not sleep in kernel for random intervals whatever the provocation ...
if this is supposed to be a warning or error condition then print
something.

James

