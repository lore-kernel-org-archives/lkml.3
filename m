Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3GJMlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:41:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3GJMlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:41:45 -0400
Date: Wed, 10 Jul 2013 15:42:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] virtio tools: strip bad include-path from Makefile
Message-ID: <20130710124253.GA12645@redhat.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
 <1373453820-22517-2-git-send-email-artagnon@gmail.com>
 <20130710121521.GB11386@redhat.com>
 <CALkWK0k49QDWcupnhhgDh4WVP-xT1f2rvDkteChZyjWo48u9qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0k49QDWcupnhhgDh4WVP-xT1f2rvDkteChZyjWo48u9qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 05:50:04PM +0530, Ramkumar Ramachandra wrote:
> Michael S. Tsirkin wrote:
> >> CFLAGS contains a mysterious "-I ../../usr/include", but no such path
> >> exists in the linux tree.  The line was originally introduced in
> >> 4e53f78e (tools/virtio: virtio_test tool, 2010-11-29), but no such path
> >> existed in the tree even then.
> >
> > It exists if you do make headers_install.
> 
> I see.  Why do we need these (or userspace headers) when /include
> exists in the linux tree though?

This is usespace code so it needs the cleaned-up version from
usr/include, not the internal kernel one.

> > So it's handy for old distos where userspace headers don't
> > exist or are out of date.
> 
> I thought userspace headers (linux-kernel-headers package in my
> distribution) are used for building kernel modules that exist as
> independent projects outside the linux tree (?).

userspace headers are for userspace, not for external modules.
I don't know what does your distro puts in a linux-kernel-headers
package.

-- 
MST
