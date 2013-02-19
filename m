Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab3BSSdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:33:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51593 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab3BSSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:33:22 -0500
Message-ID: <5123C558.5080909@oracle.com>
Date: Tue, 19 Feb 2013 13:32:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, mpm@selenic.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: slab: odd BUG on kzalloc
References: <5120FDA4.2060704@oracle.com> <0000013cefe056e0-daedd018-43cd-472f-9b20-27b2a897ae2a-000000@email.amazonses.com> <5123C1F1.6050102@oracle.com> <20130219182952.GB27141@redhat.com>
In-Reply-To: <20130219182952.GB27141@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 01:29 PM, Dave Jones wrote:
> On Tue, Feb 19, 2013 at 01:18:25PM -0500, Sasha Levin wrote:
> 
>  > >> [  169.930103] ---[ end trace 4d135f3def21b4bd ]---
>  > >>
>  > >> The code translates to the following in fs/pipe.c:alloc_pipe_info :
>  > >>
>  > >>         pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
>  > >>         if (pipe) {
>  > >>                 pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL); <=== this
>  > >>                 if (pipe->bufs) {
>  > >>                         init_waitqueue_head(&pipe->wait);
>  > 
>  > Looks like it's not specific to pipe(). I've also got this one now:
>  > 
>  > Since I've managed to reproduce it, I'll go ahead and add slub_debug and see what it tells us.
> 
> I'm curious, did you recently upgrade gcc, or other parts of the toolchain ?
> This, and one of the other 'weird' bugs you reported recently have me wondering
> if perhaps you're seeing a compiler bug.

It happened once on a kernel built on my gentoo box with is generally up to date,
but the other time the kernel was built on my mini-server running ubuntu, which
isn't updated that often.

So I don't think compiler trickery is involved.


Thanks,
Sasha

