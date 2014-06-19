Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965497AbaFSVGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:06:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418AbaFSVGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:06:53 -0400
Date: Thu, 19 Jun 2014 14:06:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, ryabinin.a.a@gmail.com,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] mm: slub: SLUB_DEBUG=n: use the same alloc/free hooks
 as for SLUB_DEBUG=y
Message-Id: <20140619140651.c3c49cf70a7f349db595239e@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.11.1406191555110.4002@gentwo.org>
References: <1403193138-7677-1-git-send-email-a.ryabinin@samsung.com>
	<alpine.DEB.2.11.1406191555110.4002@gentwo.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 15:56:56 -0500 (CDT) Christoph Lameter <cl@gentwo.org> wrote:

> On Thu, 19 Jun 2014, Andrey Ryabinin wrote:
> 
> > I see no reason why calls to other debugging subsystems (LOCKDEP,
> > DEBUG_ATOMIC_SLEEP, KMEMCHECK and FAILSLAB) are hidden under SLUB_DEBUG.
> > All this features should work regardless of SLUB_DEBUG config, as all of
> > them already have own Kconfig options.
> 
> The reason for hiding this under SLUB_DEBUG was to have some way to
> guarantee that no instrumentations is added if one does not want it.
> 
> SLUB_DEBUG is on by default and builds in a general
> debugging framework that can be enabled at runtime in
> production kernels.
> 
> If someone disabled SLUB_DEBUG then that has been done with the intend to
> get a minimal configuration.
> 

(Is that a nack?)

The intent seems to have been implemented strangely.  Perhaps it would
be clearer and more conventional to express all this using Kconfig
logic.

Anyway, if we plan to leave the code as-is then can we please get a
comment in there so the next person is not similarly confused?

