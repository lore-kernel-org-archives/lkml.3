Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaAQGAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:00:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:42963 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaAQGAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:00:02 -0500
Message-ID: <1389938353.7406.22.camel@pasglop>
Subject: Re: [Q] Why does kexec use device_shutdown rather than ubind them
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org
Date: Fri, 17 Jan 2014 16:59:13 +1100
In-Reply-To: <871u07fbvl.fsf@xmission.com>
References: <1389929988.7406.18.camel@pasglop> <871u07fbvl.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 20:52 -0800, Eric W. Biederman wrote:
> 
> I think we have largely survied until now because kdump is so popular
> and kdump winds up having to reinitialize devices from any random
> state.

kdump also doesn't care too much if the device is still DMA'ing to the
old kernel memory :-)

> But like I said I am all for reducing the burden on device driver
> developers.

Right. I'm experimenting with a variant of device_shutdown() that tries
remove() first and if it doesn't exist and shutdown() does, call that
(is that ever the case ?). I'm keeping this kexec-specific for now.

I'll try to hammer that on some of our machines see if it breaks
anything, I think it's a much better approach for kexec.

As for actual machine shutdown, we *might* have some corner cases where
shutdown is actually different from remove for good reasons, so that
will have to be investigated a bit more in depth.

I'll post my results when I have them.

Cheers,
Ben.


