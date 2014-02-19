Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaBSV2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:28:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaBSV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:27:59 -0500
Date: Wed, 19 Feb 2014 13:27:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kelley Nielsen <kelleynnn@gmail.com>
Cc: riel@surriel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        opw-kernel@googlegroups.com, jamieliu@google.com,
        sjenning@linux.vnet.ibm.com, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] mm:prototype for the updated swapoff implementation
Message-Id: <20140219132757.58b61f07bad914b3848275e9@linux-foundation.org>
In-Reply-To: <20140219003522.GA8887@kelleynnn-virtual-machine>
References: <20140219003522.GA8887@kelleynnn-virtual-machine>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 16:35:22 -0800 Kelley Nielsen <kelleynnn@gmail.com> wrote:

> The function try_to_unuse() is of quadratic complexity, with a lot of
> wasted effort. It unuses swap entries one by one, potentially iterating
> over all the page tables for all the processes in the system for each
> one.
> 
> This new proposed implementation of try_to_unuse simplifies its
> complexity to linear. It iterates over the system's mms once, unusing
> all the affected entries as it walks each set of page tables. It also
> makes similar changes to shmem_unuse.
> 
> Improvement
> 
> swapoff was called on a swap partition containing about 50M of data,
> and calls to the function unuse_pte_range were counted.
> 
> Present implementation....about 22.5M calls.
> Prototype.................about  7.0K   calls.

Do you have situations in which swapoff is taking an unacceptable
amount of time?  If so, please update the changelog to provide full
details on this, with before-and-after timing measurements.

Also, please cc Hugh on swap things.


