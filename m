Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaHARzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:55:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37297 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHARzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:55:42 -0400
Date: Fri, 1 Aug 2014 19:55:28 +0200
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: micky <micky_ching@realsil.com.cn>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v5 3/4] Staging: rts5208: Use dev_dbg and %*ph
 specifierto dump memory
Message-ID: <20140801175526.GA19125@PippoloLaptop>
References: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
 <1406672155-13187-4-git-send-email-fabio.falzoi84@gmail.com>
 <53D84FE3.9040709@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D84FE3.9040709@realsil.com.cn>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 09:52:35AM +0800, micky wrote:
> Documentation/printk-formats.txt
> 
> Raw buffer as a hex string:
> 	%*ph	00 01 02  ...  3f
> 	%*phC	00:01:02: ... :3f
> 	%*phD	00-01-02- ... -3f
> 	%*phN	000102 ... 3f
> 
> 	For printing a small buffers (up to 64 bytes long) as a hex string with
> 	certain separator. For the larger buffers consider to use
> 	print_hex_dump().
> 
> 
> Since we can't make sure the cnt value, it is not good use "%*ph",
> because it must make cnt <= 64.

> dw_len * 4  <= 64 ?

Hi Micky,

I think that in these two cases we can rely on print_hex_dump_bytes that
doesn't have the dev_dbg limit on buffer size.
Let me know what you think about it. If you agree, I can send a new version 
for patches 3/4 and 4/4, since the first two have already been merged in the
linux-next tree by Greg.

Regards,
Fabio
