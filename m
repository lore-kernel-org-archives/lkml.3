Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaEJCtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 22:49:31 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:64529 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaEJCt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 22:49:29 -0400
Date: Fri, 9 May 2014 22:49:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ata: use CONFIG_PM_SLEEP instead of CONFIG_PM where
 applicable in host drivers
Message-ID: <20140510024925.GB22539@mtj.dyndns.org>
References: <3169813.4KfLVZEqs2@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3169813.4KfLVZEqs2@amdc1032>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 05:17:44PM +0200, Bartlomiej Zolnierkiewicz wrote:
> This patch fixes host drivers to use CONFIG_PM_SLEEP instead of CONFIG_PM
> where applicable.  Benefits of this change:
> 
> * unused code is not being compiled in for CONFIG_PM=y, CONFIG_PM_SLEEP=n
>   and CONFIG_PM_RUNTIME=y configurations
> 
> * easier transition to use struct dev_pm_ops and SIMPLE_DEV_PM_OPS() in
>   the future
> 
> * more consistent code (there are host drivers which are using the correct
>   CONFIG_PM_SLEEP checks already)
> 
> The patch leaves the core libata code and ->port_[suspend,resume] support
> in sata_[inic162x,nv,sil24].c alone for now.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Applied to libata/for-3.16.

Thanks.

-- 
tejun
