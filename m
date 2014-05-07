Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbaEGNgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:36:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45076 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbaEGNgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:36:16 -0400
Date: Wed, 7 May 2014 14:35:47 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, josh@joshtriplett.org,
        David Miller <davem@davemloft.net>, andi@firstfloor.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140507143547.638c6fc2@alan.etchedpixels.co.uk>
In-Reply-To: <1399407478.15399.81.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1399328773-6531-9-git-send-email-andi@firstfloor.org>
	<20140505.231229.136734008603421707.davem@davemloft.net>
	<20140506032114.GP2382@two.firstfloor.org>
	<20140505.232327.578134514220748085.davem@davemloft.net>
	<20140506155703.GA20391@cloud>
	<1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140506183216.GM19657@tassilo.jf.intel.com>
	<1399407478.15399.81.camel@edumazet-glaptop2.roam.corp.google.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2014 13:17:58 -0700
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Tue, 2014-05-06 at 11:32 -0700, Andi Kleen wrote:
> > > We simply can not compete with user space, as a programmer is free to
> > > keep what he really wants/needs.
> > 
> > Not true.
> 
> You can shake the kernel as much as you want, you wont make :
> - a TCP socket
> - a dentry
> - an inode
> - a file structure
> - eventpoll structures (assuming epoll use)
> - 2 dst per flow.
> 
> In 1024 bytes of memory, and keep an efficient kernel to handle
> arbitrary number of sockets using the venerable and slow BSD socket api.

IoT devices don't care. Most embedded devices don't care. A lot of the
current generation of proprietary non Linux very low end RTOS systems
support *one socket*, some even use a wireless controller which has a
proprietary mini tcp/ip and wifi stack that provices *one socket*

If you want Linux to run on the kind of low end 'single chip' systems or
FPGA systems then you want to be able to run in very little memory.
Network performance is usually near irrelevant. If its controlling a
smart plug it doesn't need to do megabit encrypted streams or fast
connect.

Alan
