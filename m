Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbaGWQgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:36:09 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:55135 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaGWQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:36:07 -0400
Date: Wed, 23 Jul 2014 12:36:01 -0400
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
Message-ID: <20140723163601.GE7103@htj.dyndns.org>
References: <1406040688-1762-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <20140722201109.GN13851@htj.dyndns.org>
 <20140723144631.GA7103@htj.dyndns.org>
 <4586703.PjmVDM7Oct@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4586703.PjmVDM7Oct@amdc1032>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 23, 2014 at 06:31:58PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Hmmm, wasn't ATA_MAX_QUEUE used before not ATA_MAX_QUEUE - 1?
> 
> It seems that after your patch the loop in the ata_qc_new() will use
> only 30 tags and not 31 ones?

It was always 31 (ATA_MAX_QUEUE - 1) with the tag 31 reserved for EH
commands.  The previous patch just used limit value which is one too
high.  I'm planning to change that but this is the way it has always
been.

Thanks.

-- 
tejun
