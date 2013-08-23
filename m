Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3HWLsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:48:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19436 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab3HWLsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:48:36 -0400
Date: Fri, 23 Aug 2013 14:48:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        maxtram95@gmail.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8187se: Remove pt_regs * irq handler
 parameter
Message-ID: <20130823114818.GU22811@mwanda>
References: <1377257406-16787-1-git-send-email-navinp@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377257406-16787-1-git-send-email-navinp@cdac.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:00:06PM +0530, navin patidar wrote:
> struct pt_regs pointer is no longer passed as a irq handler
> argument.
> 

Good eye.

Could you also remove the cast to (void *) so the compiler can catch
this in the future?

-       if (request_irq(dev->irq, (void *)rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
+       if (request_irq(dev->irq, rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {

regrds,
dan carpenter


