Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaLVV03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:26:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:26:28 -0500
Date: Mon, 22 Dec 2014 13:26:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] lib: proportions.c:  Remove some unused functions
Message-Id: <20141222132626.2697567529c7708804c4061a@linux-foundation.org>
In-Reply-To: <1419087113-4087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419087113-4087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014 15:51:53 +0100 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> Removes some functions that are not used anywhere:
> prop_change_shift() prop_descriptor_init() prop_fraction_percpu() prop_fraction_single() __prop_inc_percpu_max() prop_local_destroy_percpu() prop_local_destroy_single() prop_local_init_percpu() prop_local_init_single()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> ---
>  include/linux/proportions.h |   14 ----
>  lib/proportions.c           |  177 -------------------------------------------
>  2 files changed, 191 deletions(-)

Gee, that's a heck of a lot of dead code.

Peter, what was the thinking here?  Was this code once used, or added
for API completeness or what?

Perhaps we should just ifdef it out, so the code is still sitting there if
someone wishes to resurrect it.

