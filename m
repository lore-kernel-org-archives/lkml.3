Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaJNWsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:48:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52526 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaJNWr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:47:59 -0400
X-Auth-Info: BcZun30QEKeooSqEAgw8GpsRCNoTDH5jvBVyMC3u8SU=
From: Marek Vasut <marex@denx.de>
To: "Bean Huo =?utf-8?q?=E9=9C=8D=E6=96=8C=E6=96=8C?= (beanhuo)" 
	<beanhuo@micron.com>
Subject: Re: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite platform ID point
Date: Wed, 15 Oct 2014 00:45:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201410150045.53976.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 14, 2014 at 03:26:49 AM, Bean Huo 霍斌斌 (beanhuo) wrote:
[...]

> -			dev_warn(dev, "found %s, expected %s\n",
> -				 jid->name, id->name);
> -			id = jid;
> -			info = (void *)jid->driver_data;
> +			struct flash_info *tmpinfo;
> +
> +			tmpinfo = (void *)jid->driver_data;
> +			if (tmpinfo->jedec_id != info->jedec_id ||
> +					(info->ext_id != 0 &&
> +					 tmpinfo->ext_id != info->ext_id)) {
> +				dev_warn(dev, "found %s, expected %s\n",
> +						jid->name, id->name);
> +				id = jid;
> +				info = (void *)jid->driver_data;
> +			}

Won't $info contain an undefined value in case the newly added condition isn't 
met ? The old code initialized $info to a certain value always, the new code 
does not do that.

Best regards,
Marek Vasut
