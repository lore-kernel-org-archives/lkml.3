Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaFCHWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:22:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23239 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaFCHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:22:14 -0400
Date: Tue, 3 Jun 2014 10:22:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: dgap: pass "brd" as a paramter to
 dgap_after_config_loaded()
Message-ID: <20140603072203.GE15585@mwanda>
References: <20140603062728.GA7161@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603062728.GA7161@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:27:28PM +0900, Daeseok Youn wrote:
> -static int dgap_after_config_loaded(int board)
> +static int dgap_after_config_loaded(struct board_t *brd)
>  {
> +	int board = brd->boardnum;
> +

We don't need to use "board" in this function.  We can replaced
"dgap_board[board]->" with "brd->"

>  	/*
>  	 * Initialize KME waitqueues...
>  	 */

regards,
dan carpenter

