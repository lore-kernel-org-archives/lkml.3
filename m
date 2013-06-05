Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3FEX3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab3FEX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:29:40 -0400
Date: Wed, 5 Jun 2013 20:29:33 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_balloon: leak_balloon(): only tell host if we got
 pages deflated
Message-ID: <20130605232932.GA30387@optiplex.redhat.com>
References: <20130605171031.7448deea@redhat.com>
 <20130605212449.GB19617@optiplex.redhat.com>
 <20130605190844.1e96bbde@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605190844.1e96bbde@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 07:08:44PM -0400, Luiz Capitulino wrote:
> On Wed, 5 Jun 2013 18:24:49 -0300
> Rafael Aquini <aquini@redhat.com> wrote:
> 
> > On Wed, Jun 05, 2013 at 05:10:31PM -0400, Luiz Capitulino wrote:
> > > The balloon_page_dequeue() function can return NULL. If it does for
> > > the first page being freed, then leak_balloon() will create a
> > > scatter list with len=0. Which in turn seems to generate an invalid
> > > virtio request.
> > > 
> > > Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> > > ---
> > > 
> > > PS: I didn't get this in practice. I found it by code review. On the other
> > >     hand, automatic-ballooning was able to put such invalid requests in
> > >     the virtqueue and QEMU would explode...
> > >
> > 
> > Nice catch! The patch looks sane and replicates the check done at
> > fill_balloon(). I think we also could use this P.S. as a commentary 
> > to let others aware of this scenario. Thanks Luiz!
> 
> Want me to respin?
>

That would be great, indeed. I guess the commentary could also go for the same
if case at fill_balloon(), assuming the tests are placed to prevent the same
scenario you described at changelog. You can stick my Ack on it, if reposting.

Cheers!
-- Rafael
