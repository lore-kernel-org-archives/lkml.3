Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3LFBDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:03:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3LFBDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:03:49 -0500
Date: Thu, 5 Dec 2013 17:03:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: stable@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.10] aio: restore locking of ioctx list on removal
Message-ID: <20131206010347.GA25404@kroah.com>
References: <1386238142-21792-1-git-send-email-mguzik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386238142-21792-1-git-send-email-mguzik@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 11:09:02AM +0100, Mateusz Guzik wrote:
> Commit 36f5588905c10a8c4568a210d601fe8c3c27e0f0
> "aio: refcounting cleanup" resulted in ioctx_lock not being held
> during ctx removal, leaving the list susceptible to corruptions.
> 
> In mainline kernel the issue went away as a side effect of
> db446a08c23d5475e6b08c87acca79ebb20f283c "aio: convert the ioctx list to
> table lookup v3".
> 
> Fix the problem by restoring appropriate locking.

Why can't I just take db446a08c23d5475e6b08c87acca79ebb20f283c instead?
Does it not work well enough, or is there other issues involved in it
that would keep it out of stable?

Also, it seems like the performance increase of that patch would be good
to have backported, right?

thanks,

greg k-h
