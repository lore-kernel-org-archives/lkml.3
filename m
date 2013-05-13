Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3EMUBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:01:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab3EMUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:01:30 -0400
Date: Mon, 13 May 2013 16:01:26 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, riel@redhat.com,
        amit.shah@redhat.com, anton@enomsg.org
Subject: Re: [RFC 2/2] virtio_balloon: auto-ballooning support
Message-ID: <20130513160126.4d196719@redhat.com>
In-Reply-To: <20130513190250.GA2496@redhat.com>
References: <1368111229-29847-1-git-send-email-lcapitulino@redhat.com>
	<1368111229-29847-3-git-send-email-lcapitulino@redhat.com>
	<20130509211516.GC16446@optiplex.redhat.com>
	<20130510092046.17be9bbb@redhat.com>
	<20130513143441.GA13910@optiplex.redhat.com>
	<20130513142511.3c2bde18@redhat.com>
	<20130513190250.GA2496@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 22:02:50 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, May 13, 2013 at 02:25:11PM -0400, Luiz Capitulino wrote:
> > On Mon, 13 May 2013 11:34:41 -0300
> > Rafael Aquini <aquini@redhat.com> wrote:
> > 
> > > You're right, and the host's member is used to communicate the configured size
> > > to guest's balloon device, however, by not changing it when the shrinker causes 
> > > the balloon to deflate will make the balloon thread to be woken up again 
> > > in order to chase the balloon size target again, won't it? Check
> > 
> > I don't see the balloon thread waking up after the shrinker executes in my
> > testing. Maybe this is so because it will only wake up when QEMU notifies
> > a config change.
> 
> Well that's also a problem.
> Need some mechanism to re-inflate balloon

In this implemention this is done by QEMU, have you looked at the QEMU
patch yet?

 https://lists.gnu.org/archive/html/qemu-devel/2013-05/msg01295.html

> when guest memory pressure is down.

In this implementation we do this when there's pressure in the host. I expect
things to balance over time, and this seems to be what I'm observing in my
testing, but of course we need more testing.

> virtio fs mechanism worth a look?

Can you elaborate?
