Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaKRA4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:56:01 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36684 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaKRAz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141117150821.45ac5aa8dca4b43392f563a8@linux-foundation.org>
References: <1416106197-8784-1-git-send-email-zzhsuny@gmail.com>
	<20141117150821.45ac5aa8dca4b43392f563a8@linux-foundation.org>
Date: Mon, 17 Nov 2014 19:55:58 -0500
Message-ID: <CADFvMYLm2BTqaf1rjSVxQ9TqYjhvkkdm+pe3HSwjY=MZWVz-aA@mail.gmail.com>
Subject: Re: [PATCH] [mempolicy] remove unnecessary is_valid_nodemask()
From: Zhihui Zhang <zzhsuny@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The filtering occurs in mpol_set_nodemask(), it reads like this:

                if (pol->flags & MPOL_F_RELATIVE_NODES)
                        mpol_relative_nodemask(&nsc->mask2, nodes,&nsc->mask1);
                else
                        nodes_and(nsc->mask2, *nodes, nsc->mask1);

so mask2 is based on mask1. mask2 is only used when nodes is not NULL
later. so we don't care the
case of (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes)).

-Zhihui

On Mon, Nov 17, 2014 at 6:08 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 15 Nov 2014 21:49:57 -0500 Zhihui Zhang <zzhsuny@gmail.com> wrote:
>
>> When nodes is true, nsc->mask2 has already been filtered by nsc->mask1, which has
>> already factored in node_states[N_MEMORY].
>>
>
> Please be more specific.  Where does that filtering occur?
>
