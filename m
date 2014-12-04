Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaLDIPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:15:00 -0500
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:14048
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbaLDIO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:14:59 -0500
Message-ID: <54801440.2040300@cypress.com>
Date: Thu, 4 Dec 2014 09:58:56 +0200
From: Ferruh Yigit <fery@cypress.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] input / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
References: <8119438.MdkFLx3Wvh@vostro.rjw.lan>
In-Reply-To: <8119438.MdkFLx3Wvh@vostro.rjw.lan>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [78.189.35.227]
X-ClientProxiedBy: SG2PR03CA0023.apcprd03.prod.outlook.com (25.160.233.33) To
 BY1PR0601MB1030.namprd06.prod.outlook.com (25.160.193.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1030;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1030;
X-Forefront-PRVS: 041517DFAB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(377454003)(479174003)(24454002)(189002)(51164003)(199003)(51704005)(87266999)(54356999)(102836001)(76176999)(65816999)(68736005)(50986999)(66066001)(65956001)(86362001)(20776003)(42186005)(64706001)(64126003)(65806001)(101416001)(77096005)(36756003)(23676002)(107046002)(31966008)(83506001)(95666004)(106356001)(77156002)(62966003)(105586002)(47776003)(40100003)(46102003)(87976001)(4396001)(92566001)(97736003)(92726001)(50466002)(21056001)(120916001)(122386002)(19580395003)(19580405001)(99396003)(117636001)(62816006)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1030;H:[172.23.210.93];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1030;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 03:47 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
>
> The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> replaced with CONFIG_PM too.
>
> Make these changes in 2 files under drivers/input/.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Ferruh Yigit <fery@cypress.com>


> ---
>
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
>
> Please let me know if it is OK to take this one into linux-pm.
>
> ---
>  drivers/input/keyboard/samsung-keypad.c  |    2 +-
>  drivers/input/touchscreen/cyttsp4_core.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-pm/drivers/input/keyboard/samsung-keypad.c
> ===================================================================
> --- linux-pm.orig/drivers/input/keyboard/samsung-keypad.c
> +++ linux-pm/drivers/input/keyboard/samsung-keypad.c
> @@ -463,7 +463,7 @@ static int samsung_keypad_remove(struct
>       return 0;
>  }
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int samsung_keypad_runtime_suspend(struct device *dev)
>  {
>       struct platform_device *pdev = to_platform_device(dev);
> Index: linux-pm/drivers/input/touchscreen/cyttsp4_core.c
> ===================================================================
> --- linux-pm.orig/drivers/input/touchscreen/cyttsp4_core.c
> +++ linux-pm/drivers/input/touchscreen/cyttsp4_core.c
> @@ -1716,7 +1716,7 @@ static void cyttsp4_free_si_ptrs(struct
>       kfree(si->btn_rec_data);
>  }
>
> -#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
> +#ifdef CONFIG_PM
>  static int cyttsp4_core_sleep(struct cyttsp4 *cd)
>  {
>       int rc;
>
>


--


regards,
ferruh


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
