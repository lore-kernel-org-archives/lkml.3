Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3IBKK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab3IBKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:10:58 -0400
Date: Mon, 2 Sep 2013 12:10:42 +0200
From: Karel Zak <kzak@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Peter Jones <pjones@redhat.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] partitions/efi: use lba-aware partition records
Message-ID: <20130902101042.GB30710@x2.net.home>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
 <1375766476-4204-2-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375766476-4204-2-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:21:09PM -0700, Davidlohr Bueso wrote:
>  
> +typedef struct _gpt_record {
> +        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */
> +        u8      start_head;     /* unused by EFI, pt start in CHS */
> +        u8      start_sector;   /* unused by EFI, pt start in CHS */
> +        u8      start_track;
> +        u8      os_type;        /* EFI and legacy non-EFI OS types */
> +        u8      end_head;       /* unused by EFI, pt end in CHS */
> +        u8      end_sector;     /* unused by EFI, pt end in CHS */
> +        u8      end_track;      /* unused by EFI, pt end in CHS */
> +        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */
> +        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */
> +} __attribute__ ((packed)) gpt_record;
> +

 Maybe it would be better to rename this struct to "gpt_mbr_record" to
 make it more obvious.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
