Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaKDJcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:32:33 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60607 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751446AbaKDJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:32:30 -0500
Message-ID: <54589D2A.5060807@free-electrons.com>
Date: Tue, 04 Nov 2014 10:32:26 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/17] clk: mvebu: add suspend/resume for gatable clocks
References: <1414151970-6626-1-git-send-email-thomas.petazzoni@free-electrons.com> <1414151970-6626-10-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1414151970-6626-10-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 24/10/2014 13:59, Thomas Petazzoni wrote:
> This commit adds suspend/resume support for the gatable clock driver
> used on Marvell EBU platforms. When getting out of suspend, the
> Marvell EBU platforms go through the bootloader, which re-enables all
> gatable clocks. However, upon resume, the clock framework will not
> disable again all gatable clocks that are not used.
> 
> Therefore, if the clock driver does not save/restore the state of the
> gatable clocks, all gatable clocks that are not claimed by any device
> driver will remain enabled after a resume. This is why this driver
> saves and restores the state of those clocks.
> 
> Since clocks aren't real devices, we don't have the normal ->suspend()
> and ->resume() of the device model, and have to use the ->suspend()
> and ->resume() hooks of the syscore_ops mechanism. This mechanism has
> the unfortunate idea of not providing a way of passing private data,
> which requires us to change the driver to make the assumption that
> there is only once instance of the gatable clock control structure.

It should be possible to store more than one instance in an array, and
to go trough this array during suspend and resume. However until now we
never had needed more than one instance, so I agree to keep the code simple
with this assumption.

> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/mvebu/common.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Thanks,

Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
