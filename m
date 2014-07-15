Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbaGOGv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:51:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbaGOGvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:51:24 -0400
Date: Tue, 15 Jul 2014 09:51:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] staging: dgap: fix memory leak in dgap_parsefile()
Message-ID: <20140715065116.GS25880@mwanda>
References: <20140715030456.GA14420@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715030456.GA14420@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:05:14PM +0900, Daeseok Youn wrote:
> The p->u.board.status is allocated and set a string as
> "No" once within allocating a node of BNODE type.
> But it also set again with kstrdup() in case of "STATUS"
> or "ID". If it is not allocated yet, use kstrdup().
> If not, use just memcpy().

I don't think a 2 char buffer is always large enough to hold the new
strings.

Just free it and allocate again.

regards,
dan carpenter

