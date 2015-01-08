Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbbAHIIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:08:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbbAHIIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:08:39 -0500
Date: Thu, 8 Jan 2015 10:08:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Greg Kurz <gkurz@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/net: length miscalculation
Message-ID: <20150108080829.GA12425@redhat.com>
References: <1420620847-24477-1-git-send-email-mst@redhat.com>
 <54AD9DD8.2080008@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD9DD8.2080008@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 11:58:00PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 01/07/2015 11:55 AM, Michael S. Tsirkin wrote:
> 
> >commit 8b38694a2dc8b18374310df50174f1e4376d6824
> >     vhost/net: virtio 1.0 byte swap
> >had this chunk:
> >-       heads[headcount - 1].len += datalen;
> >+       heads[headcount - 1].len = cpu_to_vhost32(vq, len - datalen);
> 
> >This adds datalen with the wrong sign, causing guest panics.
> 
> >Fixes: 8b38694a2dc8b18374310df50174f1e4376d6824
> 
>    The format of this tag assumes 12-digit SHA1 hash and the commit
> description enclosed in parens and double quotes. See
> Documentation/SubmittingPatches.
> 
> >Reported-by: Alex Williamson <alex.williamson@redhat.com>
> >Suggested-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> WBR, Sergei

I pushed the patches to Linus unfortunately - there's
some urgency since many people are hitting the bug.
Will do my best to do it right next time.

-- 
MST
