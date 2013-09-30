Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3I3QDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:03:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1837 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3I3QDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:03:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 30 Sep 2013 08:59:51 -0700
Message-ID: <5249A0DC.9030206@nvidia.com>
Date: Mon, 30 Sep 2013 12:03:40 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Manish Badarkhe <badarkhe.manish@gmail.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH] tps65090-charger: Use "IS_ENABLED(CONFIG_OF)" for DT
 code.
References: <1380342744-4227-1-git-send-email-badarkhe.manish@gmail.com>
In-Reply-To: <1380342744-4227-1-git-send-email-badarkhe.manish@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2013 12:32 AM, Manish Badarkhe wrote:
> Instead of "#if defined(CONFIG_OF)" use "IS_ENABLED(CONFIG_OF)" option
> for DT code to avoid if-deffery in code.
> Also, arranged header files in alphabetically.
> 
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> ---
> :100644 100644 bdd7b9b... 8b9c406... M	drivers/power/tps65090-charger.c
>  drivers/power/tps65090-charger.c |   19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
> index bdd7b9b..8b9c406 100644
> --- a/drivers/power/tps65090-charger.c
> +++ b/drivers/power/tps65090-charger.c
> @@ -15,15 +15,17 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> +#include <linux/delay.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/slab.h>
> -#include <linux/delay.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
> +#include <linux/slab.h>
> +
>  #include <linux/mfd/tps65090.h>
>  
>  #define TPS65090_REG_INTR_STS	0x00
> @@ -185,10 +187,6 @@ static irqreturn_t tps65090_charger_isr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -#if defined(CONFIG_OF)
> -
> -#include <linux/of_device.h>
> -
>  static struct tps65090_platform_data *
>  		tps65090_parse_dt_charger_data(struct platform_device *pdev)
>  {
> @@ -210,13 +208,6 @@ static struct tps65090_platform_data *
>  	return pdata;
>  
>  }
> -#else
> -static struct tps65090_platform_data *
> -		tps65090_parse_dt_charger_data(struct platform_device *pdev)
> -{
> -	return NULL;
> -}
> -#endif
>  
>  static int tps65090_charger_probe(struct platform_device *pdev)
>  {
> @@ -228,7 +219,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
>  
>  	pdata = dev_get_platdata(pdev->dev.parent);
>  
> -	if (!pdata && pdev->dev.of_node)
> +	if (IS_ENABLED(CONFIG_OF) && !pdata && pdev->dev.of_node)
>  		pdata = tps65090_parse_dt_charger_data(pdev);
>  
>  	if (!pdata) {
> 

LGTM
Acked-by: Rhyland Klein <rklein@nvidia.com>

-- 
nvpublic
