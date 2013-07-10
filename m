Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3GJNZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab3GJNZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:25:39 -0400
Date: Wed, 10 Jul 2013 16:26:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] virtio tools: strip bad include-path from Makefile
Message-ID: <20130710132646.GA13131@redhat.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
 <1373453820-22517-2-git-send-email-artagnon@gmail.com>
 <20130710121521.GB11386@redhat.com>
 <CALkWK0k49QDWcupnhhgDh4WVP-xT1f2rvDkteChZyjWo48u9qw@mail.gmail.com>
 <20130710124253.GA12645@redhat.com>
 <CALkWK0ky0o-YX7935-sbuunk=HU-=pg8sZiBKiV3P5g9t1zMhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0ky0o-YX7935-sbuunk=HU-=pg8sZiBKiV3P5g9t1zMhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 06:52:09PM +0530, Ramkumar Ramachandra wrote:
> Michael S. Tsirkin wrote:
> > This is usespace code so it needs the cleaned-up version from
> > usr/include, not the internal kernel one.
> 
> Right, thanks for clearing that up.  However, it does seem to depend
> on some code in /include in the linux tree.  From
> tools/virtio/linux/virtio_ring.h:
> 
>   #include "../../../include/linux/virtio_ring.h"

Yes, this is because we take some kernel bits
and compile as userspace. But it's fragile and it only works
for specific headers.

-- 
MST
