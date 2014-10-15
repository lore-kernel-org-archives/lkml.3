Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaJOMen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:34:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19646 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaJOMem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:34:42 -0400
Date: Wed, 15 Oct 2014 15:34:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141015123431.GA23154@mwanda>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 05:26:39AM -0700, Jeff Kirsher wrote:
> The Beceem WIMAX was generating compile warnings on 64bit machines,
> which were:
> 
> drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
> drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    (struct bcm_connect_mgr_params *) ntohl(
>    ^
> drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    (struct bcm_connect_mgr_params *) ntohl(
>    ^
> drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    (struct bcm_connect_mgr_params *) ntohl(
> 
> This resolves the issue by generating 64bit friendly code.
> 

As far as I can tell this isn't a bugfix, it just hides a real 64 bit
bug.  Let's leave the bug how it is so it's easy to see from a long way
away.

regards,
dan carpenter

