Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3DAOIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 10:08:20 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55295 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab3DAOIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 10:08:18 -0400
Message-ID: <51599494.3020307@cogentembedded.com>
Date: Mon, 01 Apr 2013 18:07:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Hayes Wang <hayeswang@realtek.com>
CC: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] r8169: fix could not dump registers
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com> <1364824539-4156-7-git-send-email-hayeswang@realtek.com>
In-Reply-To: <1364824539-4156-7-git-send-email-hayeswang@realtek.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-04-2013 17:55, Hayes Wang wrote:

> For new version of Fedora and Ubuntu, we see all 0xff when dumping
> the hw regs through ethtool. Using a loop to read registers could
> fix it.

> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>   drivers/net/ethernet/realtek/r8169.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)

> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 876e088..c9cd64c 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -1889,12 +1889,16 @@ static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
>   			     void *p)
>   {
>   	struct rtl8169_private *tp = netdev_priv(dev);
> +	void __iomem *ioaddr = tp->mmio_addr;
> +	u8 *d = (u8 *)p;

    Casts from 'void *' are automatic, so no need for explicit one.

WBR, Sergei

