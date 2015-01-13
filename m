Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbbAMWUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:20:09 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbbAMWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:20:08 -0500
Date: Tue, 13 Jan 2015 14:19:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, dxld@darkboxed.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hostfs: Use noop_fsync for directories
Message-ID: <20150113221958.GA27739@infradead.org>
References: <1421187358-32600-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421187358-32600-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:15:58PM +0100, Richard Weinberger wrote:
> Daniel reported that dpkg(1) dies if the root filesystem is a hostfs
> because it does not expect fsync(2) to fail with EINVAL on directories.
> While fsync(2) is allowed to fail with EINVAL if the filesystem does not
> support it we can do better and use noop_fsync() to not confuse userspace
> further.

Shouldn't hostfs pass the fsync through to the host filesystem?
