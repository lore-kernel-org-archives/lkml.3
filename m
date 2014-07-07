Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaGGToK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:44:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60005 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751264AbaGGToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:44:09 -0400
Date: Mon, 7 Jul 2014 21:44:06 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] memory: add a driver for atmel ram controllers
Message-ID: <20140707194406.GH3113@piout.net>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404746355-19988-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140707183340.GG9558@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707183340.GG9558@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 at 20:33:40 +0200, Jean-Christophe PLAGNIOL-VILLARD wrote :
> > +	if (caps->has_mpddr_clk) {
> > +		clk = devm_clk_get(&pdev->dev, "mpddr");
> > +		if (WARN_ON(IS_ERR(clk)))
> > +			return 0;
> 		I don't like this warn_on this need to be an error

What would you prefer ? pr_err() and panic or BUG_ON ?. We can also
probably simply put a single pr_err(), anyway, the platform will stop
just before switching to userspace.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
