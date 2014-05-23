Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaEWSxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:53:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaEWSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:53:10 -0400
Date: Sat, 24 May 2014 02:18:26 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/staging: Remove useless return variables
Message-ID: <20140523171826.GA4268@kroah.com>
References: <1400582028-24990-3-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400582028-24990-3-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:33:43PM +0200, Peter Senna Tschudin wrote:
> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.
> 
> Verified by compilation only.
> 
> The coccinelle script that find and fixes this issue is:
> // <smpl>
> @@
> type T;
> constant C;
> identifier ret;
> @@
> - T ret = C;
> ... when != ret
> - return ret;
> + return C;
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

This patch no longer applies to my tree, can you refresh it and resend?

thanks,

greg k-h
