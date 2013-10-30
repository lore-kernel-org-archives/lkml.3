Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab3J3RVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:21:14 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:55605 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3J3RVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:21:13 -0400
X-AuditID: cbfec372-b7fe76d000003347-ae-527140087e78
Date: Wed, 30 Oct 2013 15:21:07 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: linux-edac@vger.kernel.org, tony.luck@intel.com,
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 11/12] sb_edac: avoid decoding the same error multiple times
Message-id: <20131030152107.438876ea@samsung.com>
In-reply-to: <1383150426-24730-12-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
 <1383150426-24730-12-git-send-email-arozansk@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/hIF0Oh8Igg8/rRS3aTvxms7i67CyT
	xYVTDUwWl3fNYbN4c+EeiwOrx+I9L5k83u+7yubxeZOcx5RD7SwBLFFcNimpOZllqUX6dglc
	GdO/nWAq+MxRcf/EJ6YGxnb2LkZODgkBE4lNMy9B2WISF+6tZ+ti5OIQEljCKLHtyUt2CKeb
	SeLw/cOMIFUsAqoSh3/PYQWx2QSMJF41toDZIgJaErdOrGUGaWAWWMQo8af1CRtIQlggQOLU
	xBXMIDavgKHEy3s7wWxOAVeJr7N/gNUICdRJfPrQChTnADrDSWL3ASmIckGJH5PvsYDYzEDz
	N29rYoWw5SU2r3nLPIFRYBaSsllIymYhKVvAyLyKUbS0OLmgOCk911CvODG3uDQvXS85P3cT
	IySQi3YwPttgdYhRgINRiYeXQbcwSIg1say4MvcQowQHs5IIr54xUIg3JbGyKrUoP76oNCe1
	+BAjEwenVAPj2uX60TXCMz4vELidXFLk3shsJ2KaFWmlxRfC9Dnz1NJff6Ss/ebPaXlfsfzd
	whVtTmYGpaHhn9esOSDgbv6q86nF2Qzmhvk3lu0svmgRtHR7dnGXikZpA8+qL13SB+d8bV9/
	2Mzwc1G7TtzfG9+sdO0sY8obn0W/uh7MKWi6hmeVjtzUrkYlluKMREMt5qLiRAC2QAO8QgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 30 Oct 2013 12:27:05 -0400
Aristeu Rozanski <arozansk@redhat.com> escreveu:

> Whenever the extended error reporting is active, multiple MCEs will be
> generated for the same event, which will lead to multiple repeated
> errors to be reported. So check ADDRV and only decode the error if the
> MCE address is valid.
> 
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

For patches 2 to 11 on this series:

Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
>  drivers/edac/sb_edac.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index 2e977b9..3c2f52b 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -1410,6 +1410,10 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
>  		}
>  	}
>  
> +	/* Only decode errors with an valid address (ADDRV) */
> +	if (!GET_BITFIELD(m->status, 58, 58))
> +		return;
> +
>  	rc = get_memory_error_data(mci, m->addr, &socket,
>  				   &channel_mask, &rank, &area_type, msg);
>  	if (rc < 0)


-- 

Cheers,
Mauro
