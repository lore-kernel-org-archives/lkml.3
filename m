Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaJOM7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:59:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35118 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaJOM7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:59:49 -0400
Date: Wed, 15 Oct 2014 15:59:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141015125934.GB23154@mwanda>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141015123431.GA23154@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015123431.GA23154@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or we could fix it but add a multi-line comment with lots of capital
letters and exclamation marks.  I guess we would need to make a function
since this cast is in several places.

void *silence_buggy_casting(u32 pointer)
{
	/*
	 * DANGER! DANGER! DANGER! DANGER! DANGER! DANGER! DANGER!
	 * FIXME!!!  We know this cast is totally buggy.  The BCM driver
	 * doesn't work on 64 bits.  But no one knows how to make this
	 * work.  Oh well.  Let's silence the GCC warning.
	 * DANGER! DANGER! DANGER! DANGER! DANGER! DANGER! DANGER!
	 *
	 */
	return (void *)(long)pointer;
}

Something really ugly and gnarly like that would be hard to ignore.

regards,
dan carpenter

