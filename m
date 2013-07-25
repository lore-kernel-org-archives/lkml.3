Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3GYKw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:52:27 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:51106 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394Ab3GYKw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:52:26 -0400
Message-ID: <1374749544.29835.50.camel@x61.thuisdomein>
Subject: Re: [PATCH] staging/lustre: add BLOCK depends in Kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org
Date: Thu, 25 Jul 2013 12:52:24 +0200
In-Reply-To: <alpine.DEB.2.02.1307251458330.31610@M2420>
References: <alpine.DEB.2.02.1307251458330.31610@M2420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Jul 2013 10:52:24.0984 (UTC) FILETIME=[0C154980:01CE8925]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 15:06 +0800, Xiong Zhou wrote:
> Add BLOCK depends in Kconfig for LUSTRE to fix this:
> drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117:2: 
> error: implicit declaration of function ‘unregister_blkdev’ 
> 
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> ---
>  drivers/staging/lustre/lustre/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
> index 9ae7fa8..0b45de0 100644
> --- a/drivers/staging/lustre/lustre/Kconfig
> +++ b/drivers/staging/lustre/lustre/Kconfig
> @@ -1,6 +1,6 @@
>  config LUSTRE_FS
>         tristate "Lustre file system client support"
> -       depends on STAGING && INET && m
> +       depends on STAGING && INET && BLOCK && m

Everything below drivers/staging/lustre/Kconfig is only sourced if
STAGING is set. You can drop the dependency on STAGING.

>         select LNET
>         select CRYPTO
>         select CRYPTO_CRC32


Paul Bolle

