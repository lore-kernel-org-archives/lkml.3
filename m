Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaBZNtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:49:20 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:38986 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaBZNtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:49:18 -0500
Date: Wed, 26 Feb 2014 08:49:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: linux-next: build failure after merge of the libata tree
Message-ID: <20140226134915.GB17302@htj.dyndns.org>
References: <20140226135521.047c301755d2bb44401e3ac6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226135521.047c301755d2bb44401e3ac6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 01:55:21PM +1100, Stephen Rothwell wrote:
> Hi Tejun,
> 
> After merging the libata tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/ata/ahci_st.c: In function 'st_ahci_probe':
> drivers/ata/ahci_st.c:159:8: error: implicit declaration of function 'ahci_platform_put_resources' [-Werror=implicit-function-declaration]
>         ahci_platform_put_resources(&pdev->dev, hpriv);
>         ^
> 
> Caused by commit 0d8d213703ff ("ahci: st: Add support for ST's SATA
> IP").  That function is defined as "static" in another file ...
> 
> I have used the version of the libata tree from next-20140225 for today.

Right, that patch was against the previous version which didn't use
devres.  The put_resources calls are no longer necessary.  Will revert
the patch for now.

Thanks.

-- 
tejun
