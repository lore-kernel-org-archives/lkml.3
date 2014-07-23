Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaGWQq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:46:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9813 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaGWQqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:46:25 -0400
X-AuditID: cbfee61b-f79f86d00000144c-a8-53cfe6dff6f8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, wenxiong@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, zhenghch@cn.ibm.com, haokexin@gmail.com,
        Peter Hurley <peter@hurleysoftware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH libata/for-3.16-fixes] libata: introduce ata_host->n_tags
 to avoid oops on SAS controllers
Date: Wed, 23 Jul 2014 18:46:05 +0200
Message-id: <2111455.4B0otWTvWT@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140723163601.GE7103@htj.dyndns.org>
References: <1406040688-1762-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <4586703.PjmVDM7Oct@amdc1032> <20140723163601.GE7103@htj.dyndns.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+xoO79Z+eDDS70C1n0Hi+y6JrFbnHs
	+QNWi/OP5SyO7XjEZHF51xw2i2OX/jFaHO89wGTRc3Aio8Wv5UcZLT68u8Vi8fTjNVYHHo/m
	23fZPHbOusvuseLPejaPzSu0PDat6mTzeHBoM4vHjbvNbB6fN8kFcERx2aSk5mSWpRbp2yVw
	ZZx93s5ScISjYs/ri2wNjJfZuhg5OSQETCReb98DZYtJXLi3Hsjm4hASmM4oMb/hIiNIQkig
	hUliyUYwm03ASmJi+yowW0RAVuLKtIeMIA3MAlOZJRZd6gLq5uAQFiiQ+LA2F6SGRUBV4nL3
	dRYQm1dAU6J9w1dWEFtUwFNix/aVYIs5BYwllv38zgixeAKjxKPGzawQDYISPybfA2tmFpCX
	2Ld/KiuErSWxfudxpgmMArOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMHx8kx6B+OqBotDjAIcjEo8vB17zwcLsSaWFVfmHmKU4GBWEuFdew8oxJuSWFmVWpQfX1Sa
	k1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgXFtOa/c9h/30r9trpRrTM85tv9+
	xMROo77qz9eWb/U6rxSps3UaW+x+HY+5G45fk2zouZTbZ6X59v/UB22Nf/tnxYTrrHXWDTFf
	cP0Rr1yaRLVAYfaBiKN7l1bnSc14MqdI/KK622W9tSIf7jL/SNrL+8SDMy11i9FTs0/mT+1l
	W/WsZlht11BiKc5INNRiLipOBADdSDaZkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 12:36:01 PM Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 23, 2014 at 06:31:58PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Hmmm, wasn't ATA_MAX_QUEUE used before not ATA_MAX_QUEUE - 1?
> > 
> > It seems that after your patch the loop in the ata_qc_new() will use
> > only 30 tags and not 31 ones?
> 
> It was always 31 (ATA_MAX_QUEUE - 1) with the tag 31 reserved for EH
> commands.  The previous patch just used limit value which is one too
> high.  I'm planning to change that but this is the way it has always
> been.

I see, thanks for explaining this.

BTW:
		/* the last tag is reserved for internal command. */
		if (tag == ATA_TAG_INTERNAL)
			continue;

in ata_qc_new()'s loop now becomes a dead code (loop will be done
maximum ATA_MAX_QUEUE - 2 times and ATA_TAG_INTERNAL is defined
as ATA_MAX_QUEUE - 1).  Compiler can probably optimize it away so
as a bonus of your patch we may get one condition check less in
a hot-path. :)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

