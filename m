Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbaIEJRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:17:06 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63782 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbaIEJRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:17:04 -0400
Message-ID: <54097F87.1030009@linaro.org>
Date: Fri, 05 Sep 2014 17:16:55 +0800
From: Guodong Xu <guodong.xu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: hi6421: Fix misleading comment
References: <1409879666.5208.2.camel@phoenix>
In-Reply-To: <1409879666.5208.2.camel@phoenix>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. Could you also change the comments in macro defines, like here:

diff --git a/drivers/regulator/hi6421-regulator.c
b/drivers/regulator/hi6421-regulator.c
index e389920..156d0d1 100644
--- a/drivers/regulator/hi6421-regulator.c
+++ b/drivers/regulator/hi6421-regulator.c
@@ -37,7 +37,7 @@ struct hi6421_regulator_pdata {
  * struct hi6421_regulator_info - hi6421 regulator information
  * @desc: regulator description
  * @mode_mask: ECO mode bitmask of LDOs; for BUCKs, this masks sleep
- * @eco_microamp: eco mode load upper limit (in mA), valid for LDOs only
+ * @eco_microamp: eco mode load upper limit (in uA), valid for LDOs only
  */
 struct hi6421_regulator_info {
        struct regulator_desc   desc;
@@ -164,7 +164,7 @@ static const struct regulator_ops hi6421_buck345_ops;
  * emask - enable mask
  * odelay - off/on delay time in uS
  * ecomask - eco mode mask
- * ecoamp - eco mode load uppler limit in mA
+ * ecoamp - eco mode load uppler limit in uA
  */
 #define HI6421_LDO(_id, v_table, vreg, vmask, ereg, emask,             \
                   odelay, ecomask, ecoamp)                             \
@@ -200,7 +200,7 @@ static const struct regulator_ops hi6421_buck345_ops;
  * emask - enable mask
  * odelay - off/on delay time in uS
  * ecomask - eco mode mask
- * ecoamp - eco mode load uppler limit in mA
+ * ecoamp - eco mode load uppler limit in uA
  */
 #define HI6421_LDO_LINEAR(_id, _min_uV, n_volt, vstep, vreg, vmask,    \
                          ereg, emask, odelay, ecomask, ecoamp)         \
@@ -237,7 +237,7 @@ static const struct regulator_ops hi6421_buck345_ops;
  * emask - enable mask
  * odelay - off/on delay time in uS
  * ecomask - eco mode mask
- * ecoamp - eco mode load uppler limit in mA
+ * ecoamp - eco mode load uppler limit in uA
  */
 #define HI6421_LDO_LINEAR_RANGE(_id, n_volt, volt_ranges, vreg, vmask, \
                                ereg, emask, odelay, ecomask, ecoamp)   \


Thanks.

Best regards,
Guodong Xu


On 09/05/2014 09:14 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/hi6421-regulator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/hi6421-regulator.c b/drivers/regulator/hi6421-regulator.c
> index e389920..a8c362c 100644
> --- a/drivers/regulator/hi6421-regulator.c
> +++ b/drivers/regulator/hi6421-regulator.c
> @@ -37,7 +37,7 @@ struct hi6421_regulator_pdata {
>   * struct hi6421_regulator_info - hi6421 regulator information
>   * @desc: regulator description
>   * @mode_mask: ECO mode bitmask of LDOs; for BUCKs, this masks sleep
> - * @eco_microamp: eco mode load upper limit (in mA), valid for LDOs only
> + * @eco_microamp: eco mode load upper limit (in uA), valid for LDOs only
>   */
>  struct hi6421_regulator_info {
>  	struct regulator_desc	desc;
> 
