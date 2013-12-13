Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3LMI1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:27:15 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:10004
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab3LMI1O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:27:14 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h1155h)
Message-ID: <52AAC327.6060806@analog.com>
Date: Fri, 13 Dec 2013 09:19:51 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, <linux-kernel@vger.kernel.org>
CC: <josh@joshtriplett.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [PATCH 4/5] drivers: misc: Mark functions as static in ad525x_dpot.c
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com> <e96ca2e8c4c331f556363a7dc2046a07da230e3c.1386915618.git.rashika.kheria@gmail.com>
In-Reply-To: <e96ca2e8c4c331f556363a7dc2046a07da230e3c.1386915618.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.44.2.88]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: analog.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 07:57 AM, Rashika Kheria wrote:
> This patch marks the function ad_dpot_add_files() and
> ad_dpot_remove_files() as static in ad525x_dpot.c because they are not
> used outside this file.
>
> Thus, it also eliminates the following warnings in ad525x_dpot.c:
> drivers/misc/ad525x_dpot.c:644:5: warning: no previous prototype for ‘ad_dpot_add_files’ [-Wmissing-prototypes]
> drivers/misc/ad525x_dpot.c:669:13: warning: no previous prototype for ‘ad_dpot_remove_files’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/misc/ad525x_dpot.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
> index 0daadcf..d3eee11 100644
> --- a/drivers/misc/ad525x_dpot.c
> +++ b/drivers/misc/ad525x_dpot.c
> @@ -641,7 +641,7 @@ static const struct attribute_group ad525x_group_commands = {
>   	.attrs = ad525x_attributes_commands,
>   };
>   
> -int ad_dpot_add_files(struct device *dev,
> +static int ad_dpot_add_files(struct device *dev,
>   		unsigned features, unsigned rdac)
>   {
>   	int err = sysfs_create_file(&dev->kobj,
> @@ -666,7 +666,7 @@ int ad_dpot_add_files(struct device *dev,
>   	return err;
>   }
>   
> -inline void ad_dpot_remove_files(struct device *dev,
> +static inline void ad_dpot_remove_files(struct device *dev,
>   		unsigned features, unsigned rdac)
>   {
>   	sysfs_remove_file(&dev->kobj,


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


