Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3KSWpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:45:19 -0500
Received: from kanga.kvack.org ([205.233.56.17]:50723 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab3KSWpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:45:16 -0500
Date: Tue, 19 Nov 2013 17:45:13 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] aio: prevent double free in ioctx_alloc
Message-ID: <20131119224513.GF14098@kvack.org>
References: <1384900383-22009-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384900383-22009-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 05:33:02PM -0500, Sasha Levin wrote:
> ioctx_alloc() calls aio_setup_ring() to allocate a ring. If aio_setup_ring()
> fails to do so it would call aio_free_ring() before returning, but
> ioctx_alloc() would call aio_free_ring() again causing a double free of
> the ring.
> 
> This is easily reproducible from userspace.

I've applied this to my aio-next tree at git://git.kvack.org/~bcrl/aio-next.git
.  Please verify that it applied correctly, as that tree also includes 
another fix from Kent relating to the percpu reference bits.

		-ben
-- 
"Thought is the essence of where you are now."
