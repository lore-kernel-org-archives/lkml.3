Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaGIK0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:26:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43853 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaGIK0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:26:10 -0400
Date: Wed, 9 Jul 2014 13:26:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] staging: gdm72xx: move T_CAPABILITY definitions to
 hci.h
Message-ID: <20140709102603.GV25880@mwanda>
References: <1404219616-1788-3-git-send-email-mpappas@fastmail.fm>
 <1404296287-3970-1-git-send-email-mpappas@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404296287-3970-1-git-send-email-mpappas@fastmail.fm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 11:18:07AM +0100, Michalis Pappas wrote:
> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
> ---
>  drivers/staging/gdm72xx/gdm_wimax.c | 11 ++++-------
>  drivers/staging/gdm72xx/hci.h       |  6 ++++++
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
> index 4148013..50b7bf0 100644
> --- a/drivers/staging/gdm72xx/gdm_wimax.c
> +++ b/drivers/staging/gdm72xx/gdm_wimax.c
> @@ -609,10 +609,7 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
>  	u16 len = 0;
>  	u32 val = 0;
>  
> -	#define BIT_MULTI_CS	0
> -	#define BIT_WIMAX		1
> -	#define BIT_QOS			2
> -	#define BIT_AGGREGATION	3
> +
>  
>  	/* GetInformation mac address */
>  	len = 0;
> @@ -621,12 +618,12 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
>  	hci->length = H2B(len);
>  	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
>  
> -	val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
> +	val = (1 << T_CAPABILITY_WIMAX) | (1 << T_CAPABILITY_MULTI_CS);

Double shifting here...  It should just be:

	val = T_CAPABILITY_WIMAX | T_CAPABILITY_MULTI_CS;

This bug feels like something a static checker should find.  Let me test
that.

regards,
dan carpenter

