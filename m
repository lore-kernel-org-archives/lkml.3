Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaGHMDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:03:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGHMDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:03:32 -0400
Date: Tue, 8 Jul 2014 05:03:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Drysdale <drysdale@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Message-ID: <20140708120331.GA30459@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404124096-21445-2-git-send-email-drysdale@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:28:01AM +0100, David Drysdale wrote:
> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
> provided path, rejecting (with -EACCES) paths that are not beneath
> the provided dfd.  In particular, reject:
>  - paths that contain .. components
>  - paths that begin with /
>  - symlinks that have paths as above.


How is this implemented in FreeBSD?  I can't find any references to
O_BENEATH_ONLY except for your patchset.
