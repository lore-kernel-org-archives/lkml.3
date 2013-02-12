Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab3BLBmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 20:42:54 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33962 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808Ab3BLBmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 20:42:53 -0500
Date: Mon, 11 Feb 2013 17:42:54 -0800
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <c_dwalke@quicinc.com>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 03/19] ARM: msm: proc_comm_boot_wait should not be __init
Message-ID: <20130212014254.GA6952@quad.lixom.net>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-4-git-send-email-arnd@arndb.de>
 <8yak3r15ds0.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yak3r15ds0.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:16:31AM -0800, David Brown wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > msm_smd_probe is a driver probe function and may get
> > called after the __init time, so it must not call
> > any __init function, as the link-time warning reports.
> > Take away the __init annotation on proc_comm_boot_wait
> > to fix this.
> >
> > Without this patch, building msm_defconfig results in:
> >
> > WARNING: vmlinux.o(.text+0xb048): Section mismatch in reference from the function msm_smd_probe() to the function .init.text:proc_comm_boot_wait()
> > The function msm_smd_probe() references
> > the function __init proc_comm_boot_wait().
> > This is often because msm_smd_probe lacks a __init
> > annotation or the annotation of proc_comm_boot_wait is wrong.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: David Brown <davidb@codeaurora.org>
> > Cc: Bryan Huntsman <bryanh@codeaurora.org>
> > Cc: Daniel Walker <c_dwalke@quicinc.com>
> > Cc: linux-arm-msm@vger.kernel.org
> > ---
> >  arch/arm/mach-msm/proc_comm.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Arnd, you're welcome to pull this into your tree:
> Acked-by: David Brown <davidb@codeaurora.org>
> 
> I don't forsee any conflicts with upcoming patches.

Applied.


-Olof
