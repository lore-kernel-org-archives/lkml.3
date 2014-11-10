Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaKJTe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:34:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:24117 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaKJTeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:34:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,354,1413270000"; 
   d="scan'208";a="634638026"
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "joe@perches.com" <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "willy@linux.intel.com" <willy@linux.intel.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH 01/11] block: nvme-scsi: Fix probable mask then right
 shift defects
Thread-Topic: [PATCH 01/11] block: nvme-scsi: Fix probable mask then right
 shift defects
Thread-Index: AQHP8acBncwIX8qMnE2BH3BZ4FqIhpxa3ZAA
Date: Mon, 10 Nov 2014 19:33:54 +0000
Message-ID: <1415648084.4373.2.camel@omniknight.lm.intel.com>
References: <cover.1414387334.git.joe@perches.com>
	 <8cd08200f7cc1d1a7562d61f22a0758ec7ca182a.1414387334.git.joe@perches.com>
In-Reply-To: <8cd08200f7cc1d1a7562d61f22a0758ec7ca182a.1414387334.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.112.163]
Content-Type: text/plain; charset="utf-8"
Content-ID: <49E1A205BB69D64E945222BB19A95B12@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAAJYVbs031424

On Sun, 2014-10-26 at 22:24 -0700, Joe Perches wrote:
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> Add parentheses around the mask.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Vishal Verma <vishal.l.verma@linux.intel.com>

> ---
>  drivers/block/nvme-scsi.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
> index a4cd6d6..529ee54 100644
> --- a/drivers/block/nvme-scsi.c
> +++ b/drivers/block/nvme-scsi.c
> @@ -1972,8 +1972,8 @@ static inline void nvme_trans_get_io_cdb10(u8 *cmd,
>  {
>  	cdb_info->fua = GET_U8_FROM_CDB(cmd, IO_10_CDB_FUA_OFFSET) &
>  					IO_CDB_FUA_MASK;
> -	cdb_info->prot_info = GET_U8_FROM_CDB(cmd, IO_10_CDB_WP_OFFSET) &
> -					IO_CDB_WP_MASK >> IO_CDB_WP_SHIFT;
> +	cdb_info->prot_info = (GET_U8_FROM_CDB(cmd, IO_10_CDB_WP_OFFSET) &
> +			       IO_CDB_WP_MASK) >> IO_CDB_WP_SHIFT;
>  	cdb_info->lba = GET_U32_FROM_CDB(cmd, IO_10_CDB_LBA_OFFSET);
>  	cdb_info->xfer_len = GET_U16_FROM_CDB(cmd, IO_10_CDB_TX_LEN_OFFSET);
>  }
> @@ -1983,8 +1983,8 @@ static inline void nvme_trans_get_io_cdb12(u8 *cmd,
>  {
>  	cdb_info->fua = GET_U8_FROM_CDB(cmd, IO_12_CDB_FUA_OFFSET) &
>  					IO_CDB_FUA_MASK;
> -	cdb_info->prot_info = GET_U8_FROM_CDB(cmd, IO_12_CDB_WP_OFFSET) &
> -					IO_CDB_WP_MASK >> IO_CDB_WP_SHIFT;
> +	cdb_info->prot_info = (GET_U8_FROM_CDB(cmd, IO_12_CDB_WP_OFFSET) &
> +			       IO_CDB_WP_MASK) >> IO_CDB_WP_SHIFT;
>  	cdb_info->lba = GET_U32_FROM_CDB(cmd, IO_12_CDB_LBA_OFFSET);
>  	cdb_info->xfer_len = GET_U32_FROM_CDB(cmd, IO_12_CDB_TX_LEN_OFFSET);
>  }
> @@ -1994,8 +1994,8 @@ static inline void nvme_trans_get_io_cdb16(u8 *cmd,
>  {
>  	cdb_info->fua = GET_U8_FROM_CDB(cmd, IO_16_CDB_FUA_OFFSET) &
>  					IO_CDB_FUA_MASK;
> -	cdb_info->prot_info = GET_U8_FROM_CDB(cmd, IO_16_CDB_WP_OFFSET) &
> -					IO_CDB_WP_MASK >> IO_CDB_WP_SHIFT;
> +	cdb_info->prot_info = (GET_U8_FROM_CDB(cmd, IO_16_CDB_WP_OFFSET) &
> +			       IO_CDB_WP_MASK) >> IO_CDB_WP_SHIFT;
>  	cdb_info->lba = GET_U64_FROM_CDB(cmd, IO_16_CDB_LBA_OFFSET);
>  	cdb_info->xfer_len = GET_U32_FROM_CDB(cmd, IO_16_CDB_TX_LEN_OFFSET);
>  }

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
