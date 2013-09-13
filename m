Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3IMVHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:07:46 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:52656 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3IMVHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:07:45 -0400
Message-ID: <1379106460.2438.16.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 1/1] isdn: hfcpci_softirq: get func return to suppress
 compiler warning
From: Ben Hutchings <bhutchings@solarflare.com>
To: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
CC: Karsten Keil <isdn@linux-pingi.de>, Masanari Iida <standby24x7@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 13 Sep 2013 22:07:40 +0100
In-Reply-To: <1379094259-6237-1-git-send-email-antonio.alecrim@gmail.com>
References: <1379094259-6237-1-git-send-email-antonio.alecrim@gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20144.005
X-TM-AS-Result: No--16.772400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 14:44 -0300, Antonio Alecrim Jr wrote:
> Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
> ---
>  drivers/isdn/hardware/mISDN/hfcpci.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> index 7f910c7..5b8df75b 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -2295,7 +2295,9 @@ _hfcpci_softirq(struct device *dev, void *arg)
>  static void
>  hfcpci_softirq(void *arg)
>  {
> -	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
> +	int ret;
> +
> +	ret = driver_for_each_device(&hfc_driver.driver, NULL, arg,
>  				      _hfcpci_softirq);
>  
>  	/* if next event would be in the past ... */

This can result in a new compiler warning because ret is not used after
it is assigned.  Maybe add WARN_ON(ret)?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

