Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162816Ab3LFNvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:51:39 -0500
Received: from kanga.kvack.org ([205.233.56.17]:35527 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161709Ab3LFNvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:51:37 -0500
Date: Fri, 6 Dec 2013 08:51:35 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mateusz Guzik <mguzik@redhat.com>, stable@vger.kernel.org,
        Eryu Guan <eguan@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.10] aio: restore locking of ioctx list on removal
Message-ID: <20131206135135.GA13581@kvack.org>
References: <1386238142-21792-1-git-send-email-mguzik@redhat.com> <20131206010347.GA25404@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206010347.GA25404@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:03:47PM -0800, Greg KH wrote:
> On Thu, Dec 05, 2013 at 11:09:02AM +0100, Mateusz Guzik wrote:
> > Commit 36f5588905c10a8c4568a210d601fe8c3c27e0f0
> > "aio: refcounting cleanup" resulted in ioctx_lock not being held
> > during ctx removal, leaving the list susceptible to corruptions.
> > 
> > In mainline kernel the issue went away as a side effect of
> > db446a08c23d5475e6b08c87acca79ebb20f283c "aio: convert the ioctx list to
> > table lookup v3".
> > 
> > Fix the problem by restoring appropriate locking.
> 
> Why can't I just take db446a08c23d5475e6b08c87acca79ebb20f283c instead?
> Does it not work well enough, or is there other issues involved in it
> that would keep it out of stable?
> 
> Also, it seems like the performance increase of that patch would be good
> to have backported, right?

There are several aio patches that have to be applied to -stable, but I've 
just been waiting for some feedback now that they're in Linus' tree for a 
bit before pushing them to -stable.  I'll review which ones are needed 
today and send out a recommended list of patches to apply.

		-ben

> thanks,
> 
> greg k-h
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
"Thought is the essence of where you are now."
