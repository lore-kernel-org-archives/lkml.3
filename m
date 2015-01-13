Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbbAMGh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:37:29 -0500
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:48048
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751064AbbAMGh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:37:27 -0500
X-WSS-ID: 0NI3R2O-08-ZKD-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>, Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 1/4] usb: gadget: u_uac1: fix build issue
Date: Tue, 13 Jan 2015 14:20:34 +0800
Message-ID: <1421130034-1891-1-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(164054003)(189002)(2171001)(87936001)(105586002)(50226001)(86362001)(229853001)(53416004)(47776003)(77156002)(106466001)(23676002)(77096005)(36756003)(68736005)(101416001)(92566002)(19580405001)(19580395003)(50466002)(33646002)(46102003)(64706001)(62966003)(50986999)(97736003)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB205;
X-Forefront-PRVS: 045584D28C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 06:23:14.5661
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB205
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since gaudio member is removed at f_uac1_opts, it also needs to remove the
cleanup call of gaudio member at f_uac1_opts when the usb function instance
is freed.

See below error message:
  CC [M]  drivers/gpu/drm/nouveau/core/subdev/vm/nv50.o
  CC [M]  drivers/staging/lustre/lnet/selftest/module.o
drivers/usb/gadget/function/f_uac1.c: In function ‘f_audio_free_inst’:
drivers/usb/gadget/function/f_uac1.c:904:21: error: ‘struct f_uac1_opts’ has no member named ‘card’
  gaudio_cleanup(opts->card);
                     ^
make[4]: *** [drivers/usb/gadget/function/f_uac1.o] Error 1
make[3]: *** [drivers/usb/gadget/function] Error 2
make[2]: *** [drivers/usb/gadget] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC [M]  drivers/staging/lustre/lnet/selftest/ping_test.o

Signed-off-by: Huang Rui <ray.huang@amd.com>
Cc: Peter Chen <peter.chen@freescale.com>
---

Felipe,

As mentioned at previous mail, this fix is for your current testing/next
branch.

Thanks,
Rui

---

 drivers/usb/gadget/function/f_uac1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 9cf2252..3196e34 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -901,7 +901,7 @@ static void f_audio_free_inst(struct usb_function_instance *f)
 	struct f_uac1_opts *opts;
 
 	opts = container_of(f, struct f_uac1_opts, func_inst);
-	gaudio_cleanup(opts->card);
+
 	if (opts->fn_play_alloc)
 		kfree(opts->fn_play);
 	if (opts->fn_cap_alloc)
-- 
1.9.1

