Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaBKOBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:01:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:36761 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812AbaBKOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:01:08 -0500
Date: Tue, 11 Feb 2014 11:01:03 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mtd: add per NAND partition ECC config
Message-ID: <20140211140102.GB23150@localhost>
References: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Sat, Feb 08, 2014 at 11:26:46AM +0100, Boris BREZILLON wrote:
> This patch aims to add per partition ECC config for NAND devices.
> It defines a new field in the mtd struct to store the mtd ECC config and
> thus each mtd partition device can store its config instead of using the
> default NAND chip config.
> 
> This feature is needed to support the sunxi boot0 paritition case:
> Allwinner boot code (BROM) requires a specific HW ECC for its boot code
> that may not fit the HW NAND requirements for the entire NAND chip.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
> Hello,
> 
> This patch is just a draft that implement per partition ECC config.
> It's currently not properly splitted (it should be separated in several
> patches) and not documented either.
> 

Ah, ah...

> There's at least one point that bother me in the current implementation:
> I introduced DT notions in the nand core code by the mean of the get_ecc_ctrl
> callback, and so far this was kept out of mtd/nand core code (I guess it was
> on purpose).
> 
> Please let me know if you see other drawbacks.
> 
> If you think per partition ECC should not be implemented, could you help me
> find a way to handle sunxi specific case decribed above ?
> 
>  drivers/mtd/mtdpart.c          |   23 ++-
>  drivers/mtd/nand/nand_base.c   |  428 ++++++++++++++++++++++++----------------

I really appreciate your effort, but 428 changed lines is a too big and
intrusive change. I must admit I'm not smart enough to review such patches.

I honestly think you'll have better luck getting feedback if you take the time
to properly split and document this.

Yeah, it's annoying and time-consuming, but it's globally cheaper for you to
invest time on making it easier for reviewers and maintainers, than for each
of us to invest the time deciphering this :-)

Just my point of view, of course.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
