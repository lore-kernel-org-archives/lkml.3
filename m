Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaKTH5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:57:49 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56341 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaKTH5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:57:48 -0500
Date: Wed, 19 Nov 2014 23:57:35 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, akinobu.mita@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mtd: oobtest: Add parameter to ignore bitflip errors
 within specified limit
Message-ID: <20141120075735.GA3212@norris-Latitude-E6410>
References: <1413899608-3911-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413899608-3911-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:53:26PM +0300, Roger Quadros wrote:
> Hi,
> 
> The oobtest case uses raw NAND read/writes to OOB area bypassing the error correction
> mechanism

Hmm, I suppose that's the case. I intended for
ecc.{read,write}_oob_raw() vs. ecc.{read,write}_oob() to provide a
distinction, but most drivers use identical implementations for both,
and both are 'raw.' Now that I think about it again, I'm not sure
there's really a good use for an ECC-protected OOB read/write operation.
If you're intending to use ECC, you should be writing data+OOB (i.e.,
nand_do_{read,write}_ops()).

> and hence is bound to be affected by bitflip errors which are normal
> in NAND memories. (e.g. we can never get DRA7-evm's NAND to fully pass
> mtd_oobtest).
> 
> In these patches we add a module parameter "bitflip_limit" to specify how many
> bitflips per page are tolerable. Not specifiing the parameter defaults to old
> behaviour (i.e. zero bitflips tolerated).
> Specifying bitflip_limit=1 makes us pass on DRA7-evm with 0 errors.
> 
> Introduce a new memcmpshow() function that shows the data byte where comparison failed.
> This is useful for debugging. The same function is also used to calculate number of
> bitflip errors over the data block.

It's possible this sort of function could be useful for the other test
modules too. But we can keep it local for now.

Pushed both to l2-mtd.git.

Brian
