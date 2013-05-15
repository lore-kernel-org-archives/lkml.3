Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3EOJhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:37:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50438 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3EOJhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:37:33 -0400
Date: Wed, 15 May 2013 10:37:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jongsung Kim <neidhard.kim@lge.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: PL011: add support for extended FIFO-size of
	PL011-r1p5
Message-ID: <20130515093713.GJ18614@n2100.arm.linux.org.uk>
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com> <5191D200.3040604@wwwdotorg.org> <01fd01ce5072$d6b9fcd0$842df670$@lge.com> <5192A692.4010700@wwwdotorg.org> <022d01ce5107$8bc668e0$a3533aa0$@lge.com> <5193164E.6050400@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5193164E.6050400@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 10:59:58PM -0600, Stephen Warren wrote:
> Well, that certainly isn't true in practice. I think we should revert
> this commit until we can determine what the problem is.
> 
> I validated that the periphid register in HW contains the r1p5 revision
> (3), and the pcellid register does indeed contain the expected
> 0xb105f00d value. However, if I run the following hacky code in U-Boot
> to determine the FIFO depth, it comes out as 16, which explains the
> symptoms I'm seeing:

We could do that, just like we do in 8250.c to check the FIFO depth.
There's not much harm in doing that at boot time, it just needs to be
done carefully so that it doesn't disrupt any existing use of the UART.
