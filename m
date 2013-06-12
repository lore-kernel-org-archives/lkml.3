Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3FLPKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:10:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3FLPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:10:03 -0400
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20130612150817.GA12624@mwanda>
Date: Wed, 12 Jun 2013 08:08:17 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: omar.ramirez@copitl.com, gregkh@linuxfoundation.org,
        justinmattock@gmail.com, andriy.shevchenko@linux.intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: tidspbridge: Fix potential NULL pointer
 dereference
References: <1371047595-11702-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1371047595-11702-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) This patch doesn't do anything.  "dcd_key" points to freed memory
but it's not a NULL pointer.
2) The original pointer doesn't dereference "dcd_key" it just takes
the address of one of the elements.  I don't know the context and
can't say for sure that it's a wrong thing to do.

The code does look very suspect.  Why is it checking permisions
after we already removed the element and freed it?

But it's not a dereferencing freed memory bug.

regards,
dan carpenter

