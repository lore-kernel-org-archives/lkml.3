Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaHUMB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:01:58 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41972 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaHUMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:01:57 -0400
Date: Thu, 21 Aug 2014 13:01:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] mfd: arizona: Mark additional registers as
 volatile
Message-ID: <20140821120151.GE4266@lee--X1>
References: <1407926567-10047-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1407926567-10047-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407926567-10047-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Charles Keepax wrote:

> Mark some additional registers as volatile. The write sequencer control
> registers should not be cached, as we don't ever want their value
> synchronised as this might cause a write sequence to be accidentally
> initiated.
> 
> Additionally, the DAC_COMP registers require special preconditions to
> write so there values wouldn't be updated accurately during a register
> sync.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |   11 ++++++++---
>  drivers/mfd/wm5110-tables.c |    6 +++---
>  2 files changed, 11 insertions(+), 6 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index c18d527..191f224 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -245,9 +245,6 @@ const struct regmap_irq_chip wm5102_irq = {
>  static const struct reg_default wm5102_reg_default[] = {
>  	{ 0x00000008, 0x0019 },   /* R8     - Ctrl IF SPI CFG 1 */ 
>  	{ 0x00000009, 0x0001 },   /* R9     - Ctrl IF I2C1 CFG 1 */ 
> -	{ 0x00000016, 0x0000 },   /* R22    - Write Sequencer Ctrl 0 */ 
> -	{ 0x00000017, 0x0000 },   /* R23    - Write Sequencer Ctrl 1 */ 
> -	{ 0x00000018, 0x0000 },   /* R24    - Write Sequencer Ctrl 2 */ 
>  	{ 0x00000020, 0x0000 },   /* R32    - Tone Generator 1 */ 
>  	{ 0x00000021, 0x1000 },   /* R33    - Tone Generator 2 */ 
>  	{ 0x00000022, 0x0000 },   /* R34    - Tone Generator 3 */ 
> @@ -1881,6 +1878,10 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
>  	switch (reg) {
>  	case ARIZONA_SOFTWARE_RESET:
>  	case ARIZONA_DEVICE_REVISION:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_0:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_1:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_2:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_3:
>  	case ARIZONA_OUTPUT_STATUS_1:
>  	case ARIZONA_RAW_OUTPUT_STATUS_1:
>  	case ARIZONA_SLIMBUS_RX_PORT_STATUS:
> @@ -1892,6 +1893,10 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
>  	case ARIZONA_FLL1_NCO_TEST_0:
>  	case ARIZONA_FLL2_NCO_TEST_0:
> +	case ARIZONA_DAC_COMP_1:
> +	case ARIZONA_DAC_COMP_2:
> +	case ARIZONA_DAC_COMP_3:
> +	case ARIZONA_DAC_COMP_4:
>  	case ARIZONA_FX_CTRL2:
>  	case ARIZONA_INTERRUPT_STATUS_1:
>  	case ARIZONA_INTERRUPT_STATUS_2:
> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index 9b98ee5..beae0a3 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -666,9 +666,6 @@ static const struct reg_default wm5110_reg_default[] = {
>  	{ 0x0000000A, 0x0001 },    /* R10    - Ctrl IF I2C2 CFG 1 */
>  	{ 0x0000000B, 0x0036 },    /* R11    - Ctrl IF I2C1 CFG 2 */
>  	{ 0x0000000C, 0x0036 },    /* R12    - Ctrl IF I2C2 CFG 2 */
> -	{ 0x00000016, 0x0000 },    /* R22    - Write Sequencer Ctrl 0 */
> -	{ 0x00000017, 0x0000 },    /* R23    - Write Sequencer Ctrl 1 */
> -	{ 0x00000018, 0x0000 },    /* R24    - Write Sequencer Ctrl 2 */
>  	{ 0x00000020, 0x0000 },    /* R32    - Tone Generator 1 */
>  	{ 0x00000021, 0x1000 },    /* R33    - Tone Generator 2 */
>  	{ 0x00000022, 0x0000 },    /* R34    - Tone Generator 3 */
> @@ -2815,6 +2812,9 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
>  	switch (reg) {
>  	case ARIZONA_SOFTWARE_RESET:
>  	case ARIZONA_DEVICE_REVISION:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_0:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_1:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_2:
>  	case ARIZONA_HAPTICS_STATUS:
>  	case ARIZONA_SAMPLE_RATE_1_STATUS:
>  	case ARIZONA_SAMPLE_RATE_2_STATUS:

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
