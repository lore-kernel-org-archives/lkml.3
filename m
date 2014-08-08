Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaHHJIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:08:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39176 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:08:14 -0400
Date: Fri, 8 Aug 2014 12:05:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adrian Remonda <adrianremonda@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCHv2 2/2] Staging: rtl8188eu: Removed unnecessarry code.
Message-ID: <20140808090538.GH4856@mwanda>
References: <1407447471-11632-1-git-send-email-adrianremonda@gmail.com>
 <1407447471-11632-2-git-send-email-adrianremonda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407447471-11632-2-git-send-email-adrianremonda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 11:37:51PM +0200, Adrian Remonda wrote:
> This patch clear some code that was not doing any help.
> Pointed out by Larry.Finger
> 

The patch is fine but the changelog doesn't inpsire confidence.  It
should say:

This patch removes some unneeded code.
1) kzalloc() allocates 4 extra bytes so that we can align the return
   value.  But actually the return value is already aligned so we can
   remove the + 4 and the call to N_BYTE_ALIGMENT().
2) The memset() isn't needed because kzalloc() zeroes the allocation.

Suggested-by: Larry Finger <Larry.Finger@lwfinger.net>

regards,
dan carpenter

