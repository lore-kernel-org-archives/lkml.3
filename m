Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3H2Pi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:38:58 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:54045
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab3H2Pi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:38:57 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z551biz98dI936eI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah186068h8275bh8275dh1de097hz2fh2a8h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1377790696.26261.3.camel@linux-builds1>
Subject: Re: [PATCH RFC v2 11/16] ARM: socfpga: remove call to of_clk_init
From: Dinh Nguyen <dinguyen@altera.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 29 Aug 2013 10:38:16 -0500
In-Reply-To: <1377638890-371-12-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1377638890-371-12-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 23:28 +0200, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove mach specific calls to it.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Dinh Nguyen <dinguyen@altera.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-socfpga/socfpga.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
> index bfce964..dd0d49c 100644
> --- a/arch/arm/mach-socfpga/socfpga.c
> +++ b/arch/arm/mach-socfpga/socfpga.c
> @@ -14,7 +14,6 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> -#include <linux/clk-provider.h>
>  #include <linux/irqchip.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> @@ -107,7 +106,6 @@ static void __init socfpga_cyclone5_init(void)
>  {
>  	l2x0_of_init(0, ~0UL);
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> -	of_clk_init(NULL);
>  	socfpga_init_clocks();
>  }
>  

Acked-by: Dinh Nguyen <dinguyen@altera.com>

Thanks,
Dinh



