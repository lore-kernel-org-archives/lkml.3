Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaEOPD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaEOPD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:03:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140515022238.GL28907@ld-irv-0074>
References: <20140515022238.GL28907@ld-irv-0074>
To: Brian Norris <computersforpeace@gmail.com>
Cc: dhowells@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: roundup_pow_of_two() may not handle 64-bit integers
Date: Thu, 15 May 2014 16:03:09 +0100
Message-ID: <29314.1400166189@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Norris <computersforpeace@gmail.com> wrote:

> I'm looking to use roundup_pow_of_two() (actually, order_base_2())
> from <linux/log2.h>, but it seems that it only supports 64-bit integers
> if your toolchain uses a 64-bit 'unsigned long' type. This is strange,
> considering that ilog2() is explicitly designed for 32-bit or 64-bit
> compatibility.

ilog2() was explicitly designed for use with 'unsigned long'.  See the commit
description (f0d1b0b30d250a07627ad8b9fbbb5c7cc08422e8).  It may work with
unsigned long long, however...

David


