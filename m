Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaJUBFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 21:05:05 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61951 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaJUBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 21:05:03 -0400
Date: Mon, 20 Oct 2014 18:05:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC][PATCH] add pagesize field to /proc/pid/numa_maps
In-Reply-To: <1413847634-20039-1-git-send-email-pholasek@redhat.com>
Message-ID: <alpine.DEB.2.02.1410201803540.2345@chino.kir.corp.google.com>
References: <1413847634-20039-1-git-send-email-pholasek@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Petr Holasek wrote:

> There were some similar attempts to add vma's pagesize to numa_maps in the past,
> so I've distilled the most straightforward one - adding pagesize field
> expressing size in kbytes to each line. Although page size can be also obtained
> from smaps file, adding pagesize to numa_maps makes the interface more compact
> and easier to use without need for traversing other files.
> 
> New numa_maps output looks like that:
> 
> 2aaaaac00000 default file=/dev/hugepages/hugepagefile huge pagesize=2097152 dirty=1 N0=1
> 7f302441a000 default file=/usr/lib64/libc-2.17.so pagesize=4096 mapped=65 mapmax=38 N0=65
> 
> Signed-off-by: Petr Holasek <pholasek@redhat.com>

I guess the existing "huge" is insufficient on platforms that support 
multiple hugepage sizes.
