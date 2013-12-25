Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3LYTPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 14:15:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab3LYTPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 14:15:43 -0500
Date: Wed, 25 Dec 2013 21:19:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Dalton <mwdalton@google.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Eric Dumazet <edumazet@google.com>, Jason Wang <jasowang@redhat.com>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable 1/2] virtio_net: fix error handling for mergeable
 buffers
Message-ID: <20131225191932.GB22071@redhat.com>
References: <1387983339-1172-1-git-send-email-mst@redhat.com>
 <1387983339-1172-2-git-send-email-mst@redhat.com>
 <CANJ5vPK-rs2d_TvZ3wuAXMK8ctoSvg2km8MpncMU+0cdk=TAsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANJ5vPK-rs2d_TvZ3wuAXMK8ctoSvg2km8MpncMU+0cdk=TAsw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 25, 2013 at 10:33:37AM -0800, Michael Dalton wrote:
> Hi Michael, quick question below:
> 
> On Wed, Dec 25, 2013 at 6:56 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >                 if (i >= MAX_SKB_FRAGS) {
> >                         pr_debug("%s: packet too long\n", skb->dev->name);
> >                         skb->dev->stats.rx_length_errors++;
> > -                       return -EINVAL;
> > +                       return NULL;
> >                 }
> 
> Should this error handling path free the SKB before returning NULL?
> It seems like if we just return NULL we may leak memory.
> 
> Best,
> 
> Mike

It's a device error, but
I agree, if we touch this code anyway there's no reason not to handle
this consistently and do goto toward end of file.
It's not a backport anymore though - this code is gone upstream,
so I'll make it a separate patch I think.

-- 
MST
