Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaI2TFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:05:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaI2TFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:05:10 -0400
Date: Mon, 29 Sep 2014 12:05:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return short read or 0 at end of a raw device, not EIO
Message-ID: <20140929190509.GA2767@infradead.org>
References: <20140929142110.GA12562@fury.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929142110.GA12562@fury.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:21:10AM -0400, David Jeffery wrote:
> Changes to the basic direct I/O code have broken the raw driver when reading
> to the end of a raw device.  Instead of returning a short read for a read that
> extends partially beyond the device's end or 0 when at the end of the device,
> these reads now return EIO.

Seems like this should be changed in the generic code, or is there some
reason why it would return EIO only for devices, but not for regular
files in this case?

