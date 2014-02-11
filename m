Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBKSod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:44:33 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47973 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaBKSoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:44:30 -0500
Date: Tue, 11 Feb 2014 10:44:26 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: fix erronous read_buf call in
 nand_write_page_raw_syndrome
Message-ID: <20140211184426.GF18440@ld-irv-0074>
References: <1391278228-12701-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391278228-12701-1-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 07:10:28PM +0100, Boris BREZILLON wrote:
> read_buf is called in place of write_buf in the
> nand_write_page_raw_syndrome function.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>

Good catch! I guess no one really tests this function. I can understand
that, since it's in the "raw" version (i.e., without ECC), which should
really only be used for special debugging purposes. And many drivers
don't use the defaults for page writes.

Pushed to l2-mtd.git.

Brian
