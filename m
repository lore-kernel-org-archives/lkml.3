Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3J3Qpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:45:40 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50395 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3J3Qpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:45:38 -0400
Date: Wed, 30 Oct 2013 10:45:35 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rajiv Andrade <mail@srajiv.net>, tpmdd-devel@lists.sourceforge.net,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm/tpm_ppi: Do not compare strcmp(a,
 b) == -1
Message-ID: <20131030164535.GA3511@obsidianresearch.com>
References: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:40:27AM +0100, Peter Huewe wrote:
> strcmp does return the difference between two strings not only -1,0,1
> consequently
>  if (strcmp (a,b) == -1)
> might lead to taking the wrong branch
> 
> -> compare with <= instead.

I've always thought this was the preferred idiom:

cmp(a,b) == 0
cmp(a,b) < 0
cmp(a,b) > 0

As the operator matches what is actually happening in all cases.

'>= -1' doesn't mean a >= b.

Regards,
Jason
