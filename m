Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbaGPR6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:58:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934593AbaGPR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:58:08 -0400
Date: Wed, 16 Jul 2014 10:58:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, pramod.gurav.etc@gmail.com,
        viro@zeniv.linux.org.uk, Jason Cooper <jason@lakedaemon.net>,
        Markus Mayer <markus.mayer@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/direct-io.c: Fix compilation warning for
 uninitialized variables
Message-ID: <20140716175803.GA3631@infradead.org>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
 <20140713115022.GA6054@infradead.org>
 <53C6B199.2070606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C6B199.2070606@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:08:41PM +0300, Boaz Harrosh wrote:
> This is the wrong fix. GCC is wrong here. As shown by Paul Bolle if
> you move the from / to set from dio_get_page() to here the warning goes away.
> 
> The minimal fix must use uninitialized_var() in this case. See patch below
> 
> But I think the proper fix Is the one Paul Bolle <pebolle@tiscali.nl> sent (above)

I don't think the initialization is wrong.  The fix of moving the code
defintively looks nicer, while I think uninitialized_var is horrible
wart that won't get anywhere near my code.

Either way we should merge one of those fixes ASAP..

