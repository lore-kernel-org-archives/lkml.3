Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaEMPYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:24:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaEMPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:24:30 -0400
Date: Tue, 13 May 2014 08:24:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Message-ID: <20140513152429.GA15679@infradead.org>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 04:57:36PM +0800, Ley Foon Tan wrote:
> This patchset change default time_t and clock_t to 64 bit in
> include/uapi/asm-generic/posix_types.h. The existing 32 bit architectures override
> these define to 32 bit in arch posix_types.h.
> 
> There is request to support 64 bit time_t for new architecture [1]. According to the

I think this is an utterly wrong, and very dangerous approach.  A 64-bit
time_t is something that will need non-trivial porting effort in
userland, and introducing it only for new fringe architectures is a
guaranteed way to create silent breakage.

If you do care about it make sure the architectures that are heavily
used support it and userland can properly deal with it first, and only
then default new architectures to it.

