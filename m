Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbaAJTgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:36:03 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:40767 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaAJTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:36:00 -0500
Message-ID: <1389382665.5567.418.camel@haakon3.risingtidesystems.com>
Subject: Re: randconfig build error with next-20140110, in
 drivers/target/target_core_sbc.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Date: Fri, 10 Jan 2014 11:37:45 -0800
In-Reply-To: <CA+r1ZhiKhGJrki8X_bcKC3LrALRHj61uFpAmiGRfePO0g9tU4w@mail.gmail.com>
References: <CA+r1ZhiKhGJrki8X_bcKC3LrALRHj61uFpAmiGRfePO0g9tU4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On Fri, 2014-01-10 at 06:57 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `sbc_dif_v1_verify':
> /home/jim/linux/drivers/target/target_core_sbc.c:1019: undefined
> reference to `crc_t10dif'
> make: *** [vmlinux] Error 1

Applying the following patch to address this build failure.

Thanks for the heads up!

--nab

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 1830368..50aad2e 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -3,6 +3,7 @@ menuconfig TARGET_CORE
        tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
        depends on SCSI && BLOCK
        select CONFIGFS_FS
+       select CRC_T10DIF
        default n
        help
        Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled

