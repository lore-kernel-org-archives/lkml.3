Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3KTMyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:54:54 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KTMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:54:53 -0500
Date: Wed, 20 Nov 2013 04:54:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        LKML <linux-kernel@vger.kernel.org>, matthew@wil.cx
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131120125446.GA6284@infradead.org>
References: <528CA73B.9070604@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CA73B.9070604@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 01:12:43PM +0100, Stefan Priebe - Profihost AG wrote:
> Can anyone explain to me why O_DSYNC for my app on linux is so slow?

Because FreeBSD ignores O_DSYNC on block devices, it never sends a FLUSH
to the device.

