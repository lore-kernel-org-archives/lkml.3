Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3IPHYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:24:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab3IPHYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:24:12 -0400
Date: Mon, 16 Sep 2013 10:26:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why does test_bit() take a volatile addr?
Message-ID: <20130916072603.GA11007@redhat.com>
References: <87ioy11k8s.fsf@rustcorp.com.au>
 <20130916165344.144f0d0f1b58111f1c8c87cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916165344.144f0d0f1b58111f1c8c87cc@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 04:53:44PM +1000, Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Mon, 16 Sep 2013 13:38:35 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > Predates git, does anyone remember the rationale?
> > 
> > ie:
> >         int test_bit(int nr, const volatile unsigned long *addr)
> 
> Because we sometimes pass volatile pointers to it and gcc will complain
> if you pass a volatile to a non volatile  (I think).

Where are these? I did git grep -W test_bit and looked for volatile,
couldn't find anything.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


