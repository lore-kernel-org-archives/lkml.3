Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaFPXmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:42:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaFPXmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:42:39 -0400
Date: Mon, 16 Jun 2014 16:42:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Yucong <slaoub@gmail.com>
Cc: mhocko@suse.cz, hannes@cmpxchg.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
Message-Id: <20140616164237.5fcba7baaec83d509c9683e0@linux-foundation.org>
In-Reply-To: <1402923474.3958.34.camel@debian>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
	<1402923474.3958.34.camel@debian>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 20:57:54 +0800 Chen Yucong <slaoub@gmail.com> wrote:

> On Mon, 2014-06-09 at 21:27 +0800, Chen Yucong wrote:
> > Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> > original scan targets introduces extra 40 bytes on the stack. This patch
> > is able to avoid this situation and the call to memcpy(). At the same time,
> > it does not change the relative design idea.
> > 
> > ratio = original_nr_file / original_nr_anon;
> > 
> > If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
> >  x = nr_file - ratio * nr_anon;
> > 
> > if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
> >  x = nr_anon - nr_file / ratio;
> > 
> Hi Andrew Morton,
> 
> I think the patch
>  
> [PATCH]
> mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec-fix.patch
> 
> which I committed should be discarded.

OK, thanks.

I assume you're referring to
mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
- I don't think a -fix.patch existed?

