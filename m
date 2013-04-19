Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030472Ab3DSM7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:59:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34747 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030222Ab3DSM7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:59:54 -0400
Date: Fri, 19 Apr 2013 13:58:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jongsung Kim <neidhard.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: PL011: add support for extended FIFO-size of
	PL011-r1p5
Message-ID: <20130419125858.GL14496@n2100.arm.linux.org.uk>
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007301ce375e$bcf6d6b0$36e48410$@lge.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 06:18:47PM +0900, Jongsung Kim wrote:
> +static unsigned int get_fifosize_arm(unsigned int periphid)
> +{
> +	unsigned int rev = (periphid >> 20) & 0xf;
> +	return rev < 3 ? 16 : 32;

Don't we have a macro to get the revision given the amba device?
amba_rev().
