Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaAFBGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:06:05 -0500
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:52400 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751318AbaAFBGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:06:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1544:1593:1594:1605:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3868:3872:4321:4605:5007:6119:7652:7903:10004:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13019,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beds31_347e4e086503d
X-Filterd-Recvd-Size: 4909
Message-ID: <1388970358.5808.37.camel@joe-AO722>
Subject: Re: [PATCH] Power: ab8500: Fixed coding style issues
From: Joe Perches <joe@perches.com>
To: Jesper Falk <jesperfalk94@gmail.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 05 Jan 2014 17:05:58 -0800
In-Reply-To: <1388969418-30376-1-git-send-email-jesperfalk94@gmail.com>
References: <1388969418-30376-1-git-send-email-jesperfalk94@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 01:50 +0100, Jesper Falk wrote:
> Fixed coding style.

It'd  be nice to change some of these arrays to const too like:

diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 3301b20..9fa8c0c 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -287,8 +287,8 @@ struct abx500_bm_data {
 	int gnd_lift_resistance;
 	int n_chg_out_curr;
 	int n_chg_in_curr;
-	int *chg_output_curr;
-	int *chg_input_curr;
+	const int *chg_output_curr;
+	const int *chg_input_curr;
 	const struct abx500_maxim_parameters *maxi;
 	const struct abx500_bm_capacity_levels *cap_levels;
 	struct abx500_battery_type *bat_type;



> diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
[]
> @@ -448,19 +448,19 @@ static const struct abx500_bm_charger_parameters chg = {
>   * AB8500 values
>   */
>  static int ab8500_charge_output_curr_map[] = {

static const int

> -        100,    200,    300,    400,    500,    600,    700,    800,
> -        900,    1000,   1100,   1200,   1300,   1400,   1500,   1500,
> +	100,    200,    300,    400,    500,    600,    700,    800,
> +	900,    1000,   1100,   1200,   1300,   1400,   1500,   1500,
>  };
>  
>  static int ab8540_charge_output_curr_map[] = {

here too

> -        0,      0,      0,      75,     100,    125,    150,    175,
> -        200,    225,    250,    275,    300,    325,    350,    375,
> -        400,    425,    450,    475,    500,    525,    550,    575,
> -        600,    625,    650,    675,    700,    725,    750,    775,
> -        800,    825,    850,    875,    900,    925,    950,    975,
> -        1000,   1025,   1050,   1075,   1100,   1125,   1150,   1175,
> -        1200,   1225,   1250,   1275,   1300,   1325,   1350,   1375,
> -        1400,   1425,   1450,   1500,   1600,   1700,   1900,   2000,
> +	0,      0,      0,      75,     100,    125,    150,    175,
> +	200,    225,    250,    275,    300,    325,    350,    375,
> +	400,    425,    450,    475,    500,    525,    550,    575,
> +	600,    625,    650,    675,    700,    725,    750,    775,
> +	800,    825,    850,    875,    900,    925,    950,    975,
> +	1000,   1025,   1050,   1075,   1100,   1125,   1150,   1175,
> +	1200,   1225,   1250,   1275,   1300,   1325,   1350,   1375,
> +	1400,   1425,   1450,   1500,   1600,   1700,   1900,   2000,
>  };
>  
>  /*
> @@ -468,19 +468,19 @@ static int ab8540_charge_output_curr_map[] = {
>   * AB8500 values
>   */
>  static int ab8500_charge_input_curr_map[] = {
> -        50,     98,     193,    290,    380,    450,    500,    600,
> -        700,    800,    900,    1000,   1100,   1300,   1400,   1500,
> +	50,     98,     193,    290,    380,    450,    500,    600,
> +	700,    800,    900,    1000,   1100,   1300,   1400,   1500,
>  };

here 3
 
>  static int ab8540_charge_input_curr_map[] = {
> -        25,     50,     75,     100,    125,    150,    175,    200,
> -        225,    250,    275,    300,    325,    350,    375,    400,
> -        425,    450,    475,    500,    525,    550,    575,    600,
> -        625,    650,    675,    700,    725,    750,    775,    800,
> -        825,    850,    875,    900,    925,    950,    975,    1000,
> -        1025,   1050,   1075,   1100,   1125,   1150,   1175,   1200,
> -        1225,   1250,   1275,   1300,   1325,   1350,   1375,   1400,
> -        1425,   1450,   1475,   1500,   1500,   1500,   1500,   1500,
> +	25,     50,     75,     100,    125,    150,    175,    200,
> +	225,    250,    275,    300,    325,    350,    375,    400,
> +	425,    450,    475,    500,    525,    550,    575,    600,
> +	625,    650,    675,    700,    725,    750,    775,    800,
> +	825,    850,    875,    900,    925,    950,    975,    1000,
> +	1025,   1050,   1075,   1100,   1125,   1150,   1175,   1200,
> +	1225,   1250,   1275,   1300,   1325,   1350,   1375,   1400,
> +	1425,   1450,   1475,   1500,   1500,   1500,   1500,   1500,
>  };

and here.


