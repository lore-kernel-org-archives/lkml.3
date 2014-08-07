Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaHGNH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:07:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbaHGNHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:07:25 -0400
Message-ID: <53E37A0B.1060105@suse.de>
Date: Thu, 07 Aug 2014 15:07:23 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoiify@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "open list:LSILOGIC/SYMBIOS/..." <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: Check if WSR already defined
References: <1407389918-10463-1-git-send-email-xerofoiify@gmail.com>
In-Reply-To: <1407389918-10463-1-git-send-email-xerofoiify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 07:38 AM, Nick Krause wrote:
> On xtensa arch there is this warning
>
> drivers/scsi/sym53c8xx_2/sym_defs.h:109:0: warning: "WSR" redefined [enabled by default]
> arch/xtensa/include/asm/processor.h:188:0: note: this is the location of the previous definition
>
> I can remove WSR since it is not being used but more documentation purpose, so
> undefining is enough.
>
> Signed-off-by: Nick Krause <xerofoify@gmail.com>
> ---
>   drivers/scsi/sym53c8xx_2/sym_defs.h | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/scsi/sym53c8xx_2/sym_defs.h b/drivers/scsi/sym53c8xx_2/sym_defs.h
> index defccc4..68334a5 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_defs.h
> +++ b/drivers/scsi/sym53c8xx_2/sym_defs.h
> @@ -91,6 +91,10 @@ struct sym_chip {
>   #define FE_CACHE0_SET	(FE_CACHE_SET & ~FE_ERL)
>   };
>
> +#ifdef WSR
> +#undef WSR
> +#endif
> +
>   /*
>    *	SYM53C8XX IO register data structure.
>    */
>
Ouch.
Certainly not. Who knows for which odd function the 'WSR' definition 
is used.
Better to redefine WSR in sym_defs.h.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
