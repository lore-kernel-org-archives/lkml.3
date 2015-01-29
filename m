Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbbA2JpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:45:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50000 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541AbbA2JpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:45:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 29 Jan 2015 10:44:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Peter Hurley <peter@hurleysoftware.com>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/fwserial: use correct vendor/version IDs
Message-ID: <20150129104443.43b7ecbb@kant>
In-Reply-To: <54C9418F.1050600@ladisch.de>
References: <54C940E0.5090906@ladisch.de>
	<54C9418F.1050600@ladisch.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28 Clemens Ladisch wrote:
> The driver was using the vendor ID 0xd00d1e from the FireWire core.
> However, this ID was not registered, and invalid.
> 
> Instead, use the vendor/version IDs that now are officially assigned to
> firewire-serial:
> https://ieee1394.wiki.kernel.org/index.php/IEEE_OUI_Assignments
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
[...]
> --- a/drivers/staging/fwserial/fwserial.c
> +++ b/drivers/staging/fwserial/fwserial.c
> @@ -30,8 +30,8 @@
> 
>  #define be32_to_u64(hi, lo)  ((u64)be32_to_cpu(hi) << 32 | be32_to_cpu(lo))
> 
> -#define LINUX_VENDOR_ID   0xd00d1eU  /* same id used in card root directory   */
> -#define FWSERIAL_VERSION  0x00e81cU  /* must be unique within LINUX_VENDOR_ID */
> +#define LINUX_VENDOR_ID   0x001f11U  /* same id used in card root directory   */
> +#define FWSERIAL_VERSION  0x023953U  /* must be unique within LINUX_VENDOR_ID */

(Bikeshedding:  Per IEEE Registration Authority's list, 001f11 is not a
"Linux vendor ID" but Openmoko, Inc.'s vendor ID.)

Greg,
just FYI, the comment "same id used in card root directory" will remain
true only once a corresponding change to firewire-core was merged.
Proposed patch: http://marc.info/?l=linux1394-devel&m=142247554618207
(If I receive no substantial objections, this will go in in the next
merge window.)

Date: Wed, 28 Jan 2015 21:04:48 +0100
From: Clemens Ladisch <clemens@ladisch.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net
Subject: [PATCH] firewire: core: use correct vendor/model IDs

The kernel was using the vendor ID 0xd00d1e, which was inherited from
the old ieee1394 driver stack.  However, this ID was not registered, and
invalid.

Instead, use the vendor/model IDs that are now officially assigned to
the kernel:
https://ieee1394.wiki.kernel.org/index.php/IEEE_OUI_Assignments

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/core-transaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 60f6963..99d9d8c7 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -1271,14 +1271,14 @@ static u32 model_textual_descriptor[3 + 64/4] = {

 static struct fw_descriptor vendor_id_descriptor = {
 	.length = ARRAY_SIZE(vendor_textual_descriptor),
-	.immediate = 0x03d00d1e,
+	.immediate = 0x03001f11,
 	.key = 0x81000000,
 	.data = vendor_textual_descriptor,
 };

 static struct fw_descriptor model_id_descriptor = {
 	.length = ARRAY_SIZE(model_textual_descriptor),
-	.immediate = 0x17000001,
+	.immediate = 0x17023901,
 	.key = 0x81000000,
 	.data = model_textual_descriptor,
 };

-- 
Stefan Richter
-=====-===== ---= ===-=
http://arcgraph.de/sr/
