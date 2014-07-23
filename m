Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbaGWRUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:20:21 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45744 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbaGWRUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:20:18 -0400
Date: Wed, 23 Jul 2014 13:20:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
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
Message-ID: <20140723172011.GF7103@htj.dyndns.org>
References: <1406040688-1762-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <4586703.PjmVDM7Oct@amdc1032>
 <20140723163601.GE7103@htj.dyndns.org>
 <2111455.4B0otWTvWT@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2111455.4B0otWTvWT@amdc1032>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 23, 2014 at 06:46:05PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday, July 23, 2014 12:36:01 PM Tejun Heo wrote:
> BTW:
> 		/* the last tag is reserved for internal command. */
> 		if (tag == ATA_TAG_INTERNAL)
> 			continue;
> 
> in ata_qc_new()'s loop now becomes a dead code (loop will be done
> maximum ATA_MAX_QUEUE - 2 times and ATA_TAG_INTERNAL is defined
> as ATA_MAX_QUEUE - 1).  Compiler can probably optimize it away so
> as a bonus of your patch we may get one condition check less in
> a hot-path. :)

ATA_TAG_INTERNAL will soon be replaced by a qc flag so this should all
go away pretty soon.  ata_qc_new() is quite badly implemented tho.  It
has no reason to do atomic test_and_set_bit() and there are far more
efficient ways to implement what it does.  If anybody is interested in
improving it, please go ahead.

Thanks.

-- 
tejun
