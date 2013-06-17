Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3FQRzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:55:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3FQRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:55:27 -0400
Date: Mon, 17 Jun 2013 10:55:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RESEND 02/12] msm_serial: Use devm_clk_get() and properly
 return errors
Message-ID: <20130617175525.GB15370@kroah.com>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371490999-15501-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:43:09AM -0700, Stephen Boyd wrote:
> Clocks are not clk_put() in this driver's error paths during
> probe. The code that checks for clock errors also fails to
> properly return the error code from the pclk member if it turns
> out to be the failing clock, leading to potentially confusing
> error values if the clk member is not an error pointer. Fix these
> problems with devm_clk_get() and proper error checking.
> 
> Removing the clk_put() in msm_serial_remove() also points out
> that msm_port is unused. Furthermore, msm_port is the wrong type
> and so the clk_put() would be using the wrong pointer. Replace it
> with the proper type and call uart_remove_one_port() to do the
> proper cleanup.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
