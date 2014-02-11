Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaBKQcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:32:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:37814 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752451AbaBKQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:32:08 -0500
Date: Tue, 11 Feb 2014 17:32:03 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] clk: respect the clock dependencies in of_clk_init
Message-ID: <20140211173203.4e6c7b22@skate>
In-Reply-To: <1392054179-28830-1-git-send-email-gregory.clement@free-electrons.com>
References: <1392054179-28830-1-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 10 Feb 2014 18:42:59 +0100, Gregory CLEMENT wrote:
> Until now the clock providers were initialized in the order found in
> the device tree. This led to have the dependencies between the clocks
> not respected: children clocks could be initialized before their
> parent clocks.
> 
> Instead of forcing each platform to manage its own initialization order,
> this patch adds this work inside the framework itself.
> 
> Using the data of the device tree the of_clk_init function now delayed
> the initialization of a clock provider if its parent provider was not
> ready yet.
> 
> The strict dependency check (all parents of a given clk must be
> initialized) was added by Boris BREZILLON
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
> 
> Since the v1, I have merged the  strict dependency check from Boris.
> And of course tested on my Armada 370 and Armada XP based board
> 
>  drivers/clk/clk.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 106 insertions(+), 3 deletions(-)

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

On the newly proposed Armada 375 platform.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
