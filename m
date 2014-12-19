Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaLSW1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:27:01 -0500
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:34132 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751456AbaLSW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:26:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:4321:5007:6261:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13095:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bird81_2653095a4f45
X-Filterd-Recvd-Size: 2357
Message-ID: <1419028015.25129.14.camel@perches.com>
Subject: Re: [PATCH v2 1/2] Input: touchscreen-iproc: Add Broadcom iProc
 touchscreen driver
From: Joe Perches <joe@perches.com>
To: Jonathan Richardson <jonathar@broadcom.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Date: Fri, 19 Dec 2014 14:26:55 -0800
In-Reply-To: <1419027470-7969-2-git-send-email-jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
	 <1419027470-7969-1-git-send-email-jonathar@broadcom.com>
	 <1419027470-7969-2-git-send-email-jonathar@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 14:17 -0800, Jonathan Richardson wrote:
> Add initial version of the Broadcom touchscreen driver.

more trivia:

> diff --git a/drivers/input/touchscreen/bcm_iproc_tsc.c b/drivers/input/touchscreen/bcm_iproc_tsc.c
[]
> +static int get_tsc_config(struct device_node *np, struct iproc_ts_priv *priv)
> +{
> +	u32 val;
[]
> +	if (of_property_read_u32(np, "debounce_timeout", &val) >= 0) {
> +		if (val < 0 || val > 255) {
> +			dev_err(dev, "debounce_timeout must be [0-255]\n");
> +			return -EINVAL;
> +		}
> +		priv->cfg_params.debounce_timeout = val;

Doesn't the compiler generate a warning message
about an impossible "unsigned < 0" test for all
of these "val < 0" uses?

> +	}
> +
> +	if (of_property_read_u32(np, "settling_timeout", &val) >= 0) {
> +		if (val < 0 || val > 11) {
[]
> +	if (of_property_read_u32(np, "touch_timeout", &val) >= 0) {
> +		if (val < 0 || val > 255) {
[]
> +	if (of_property_read_u32(np, "average_data", &val) >= 0) {
> +		if (val < 0 || val > 8) {
[]
> +	if (of_property_read_u32(np, "fifo_threshold", &val) >= 0) {
> +		if (val < 0 || val > 31) {


