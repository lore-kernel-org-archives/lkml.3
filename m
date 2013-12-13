Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3LMJBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:01:38 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:56568 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3LMJBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:01:37 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 13 Dec 2013 01:01:30 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers: message: Mark functions as static in
 mptsas.c
Message-ID: <20131213090130.GJ4386@leaf>
References: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
 <14b2696b781c98ce10a0075753bbe2cc7c7fc2e7.1386914148.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14b2696b781c98ce10a0075753bbe2cc7c7fc2e7.1386914148.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:40:35AM +0530, Rashika Kheria wrote:
> This patch marks the function mptsas_refreshing_device_handles(),
> mptsas_expander_add() and mptsas_shutdown() as static in fusion/mptsas.c
> because they are not used outside this file.
> 
> Thus, it also eliminates the following warnings in fusion/mptsas.c:
> drivers/message/fusion/mptsas.c:1579:1: warning: no previous prototype for ‘mptsas_refreshing_device_handles’ [-Wmissing-prototypes]
> drivers/message/fusion/mptsas.c:3654:1: warning: no previous prototype for ‘mptsas_expander_add’ [-Wmissing-prototypes]
> drivers/message/fusion/mptsas.c:5327:1: warning: no previous prototype for ‘mptsas_shutdown’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/message/fusion/mptsas.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index dd239bd..906f448 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1575,7 +1575,7 @@ mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
>  	mptsas_port_delete(ioc, phy_info->port_details);
>  }
>  
> -struct mptsas_phyinfo *
> +static struct mptsas_phyinfo *
>  mptsas_refreshing_device_handles(MPT_ADAPTER *ioc,
>  	struct mptsas_devinfo *sas_device)
>  {
> @@ -3650,7 +3650,7 @@ mptsas_send_expander_event(struct fw_event_work *fw_event)
>   * @handle:
>   *
>   */
> -struct mptsas_portinfo *
> +static struct mptsas_portinfo *
>  mptsas_expander_add(MPT_ADAPTER *ioc, u16 handle)
>  {
>  	struct mptsas_portinfo buffer, *port_info;
> @@ -5323,7 +5323,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	return error;
>  }
>  
> -void
> +static void
>  mptsas_shutdown(struct pci_dev *pdev)
>  {
>  	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
> -- 
> 1.7.9.5
> 
