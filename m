Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3JRSeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 14:34:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56139 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3JRSeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 14:34:11 -0400
Message-ID: <52617F22.6030900@codeaurora.org>
Date: Fri, 18 Oct 2013 11:34:10 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] ARM: tty: Move HVC DCC assembly to arch/arm
References: <1382120064-2459-1-git-send-email-cov@codeaurora.org>
In-Reply-To: <1382120064-2459-1-git-send-email-cov@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 11:14, Christopher Covington wrote:
> Put architecture-specific assembly code where it belongs,
> allowing for support of additional architectures such as arm64 in
> the future.

Do you have that patch too? There was also a patch a year ago to add
armv5/v4 support to this driver. Maybe we can resurrect that too.

> diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
> index 44fbeba..e9f0191 100644
> --- a/drivers/tty/hvc/hvc_dcc.c
> +++ b/drivers/tty/hvc/hvc_dcc.c
> @@ -8,57 +8,13 @@
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> - * 02110-1301, USA.
>   */
>  
> -#include <linux/console.h>
> -#include <linux/delay.h>
> -#include <linux/err.h>
> -#include <linux/init.h>

We still need init.h

> -#include <linux/moduleparam.h>
> -#include <linux/types.h>
> -
> +#include <asm/dcc.h>
>  #include <asm/processor.h>
>  
>  #include "hvc_console.h"
>  
>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

