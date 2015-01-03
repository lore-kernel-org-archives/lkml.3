Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbbACBIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 20:08:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbbACBIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 20:08:31 -0500
Date: Fri, 2 Jan 2015 17:08:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH akpm/next] lib: crc32: conditionally constify crc32
 lookup table
Message-Id: <20150102170828.3bb15c0a.akpm@linux-foundation.org>
In-Reply-To: <54A733FB.8010904@redhat.com>
References: <1420052608-30515-1-git-send-email-dborkman@redhat.com>
	<20150102153537.2251ca287e96446eaf229ae2@linux-foundation.org>
	<54A733FB.8010904@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Jan 2015 01:12:43 +0100 Daniel Borkmann <dborkman@redhat.com> wrote:

> > Seems a lot of fuss.  Why are these tables cacheline aligned anyway?
> > To avoid one cache miss (most of the time, presumably) in a 16k table.
> > Pretty marginal benefit, I suspect.
> 
> I guess, it actually came in with the slice-by-8 algorithm (e.g. used
> in SCTP checksumming if no offloading is available) that was added back
> then, that is, commit 324eb0f17d9dc ("crc32: add slice-by-8 algorithm
> to existing code").

non-responsive ;)  By far the simplest solution is to remove the
cacheline alignment.

Are there other places where CC_HAVE_CONST_ALIGN can be used?  I'm seeing

z:/usr/src/linux-3.19-rc2> grep -r cacheline_aligned . | grep const
./arch/x86/um/sys_call_table_32.c:const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
./arch/x86/um/sys_call_table_64.c:const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
./include/net/netfilter/nf_tables.h:    const struct nft_set_ops        *ops ____cacheline_aligned;
./net/ethernet/eth.c:const struct header_ops eth_header_ops ____cacheline_aligned = {

