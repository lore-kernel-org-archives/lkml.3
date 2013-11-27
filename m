Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab3K0C7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:59:12 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49494 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab3K0C7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:59:09 -0500
Message-ID: <5295607E.2000504@gmail.com>
Date: Wed, 27 Nov 2013 11:01:18 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: marek.belisko@gmail.com, kelleynnn@gmail.com, josh@joshtriplett.org,
        linux@rainbow-software.org, peter.p.waskiewicz.jr@intel.com
CC: rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] drivers: staging: ft1000: ft1000-usb: initialize 'status'
 with STATUS_SUCCESS in request_code_segment()
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
In-Reply-To: <5294255E.7040105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "!bool_case", it returns unexpected value instead of STATUS_SUCCESS,
so need fix it, the related warning (with allmodconfig under hexagon):

    CC [M]  drivers/staging/ft1000/ft1000-usb/ft1000_download.o
  drivers/staging/ft1000/ft1000-usb/ft1000_download.c: In function 'request_code_segment':
  drivers/staging/ft1000/ft1000-usb/ft1000_download.c:581:6: warning: 'status' may be used uninitialized in this function [-Wuninitialized]


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 68ded17..15f3062 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -578,7 +578,7 @@ static int request_code_segment(struct ft1000_usb *ft1000dev, u16 **s_file,
 		 u8 **c_file, const u8 *endpoint, bool boot_case)
 {
 	long word_length;
-	int status;
+	int status = STATUS_SUCCESS;
 
 	/*DEBUG("FT1000:REQUEST_CODE_SEGMENT\n");i*/
 	word_length = get_request_value(ft1000dev);
-- 
1.7.7.6
