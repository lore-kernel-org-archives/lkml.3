Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaFPXwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:52:41 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57845 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFPXwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:52:39 -0400
Message-ID: <1402962603.3958.36.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
From: Chen Yucong <slaoub@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mhocko@suse.cz, hannes@cmpxchg.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 07:50:03 +0800
In-Reply-To: <20140616164237.5fcba7baaec83d509c9683e0@linux-foundation.org>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
	 <1402923474.3958.34.camel@debian>
	 <20140616164237.5fcba7baaec83d509c9683e0@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 16:42 -0700, Andrew Morton wrote:
> On Mon, 16 Jun 2014 20:57:54 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> 
> > On Mon, 2014-06-09 at 21:27 +0800, Chen Yucong wrote:
> > > Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> > > original scan targets introduces extra 40 bytes on the stack. This patch
> > > is able to avoid this situation and the call to memcpy(). At the same time,
> > > it does not change the relative design idea.
> > > 
> > > ratio = original_nr_file / original_nr_anon;
> > > 
> > > If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
> > >  x = nr_file - ratio * nr_anon;
> > > 
> > > if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
> > >  x = nr_anon - nr_file / ratio;
> > > 
> > Hi Andrew Morton,
> > 
> > I think the patch
> >  
> > [PATCH]
> > mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec-fix.patch
> > 
> > which I committed should be discarded.
> 
> OK, thanks.
> 
> I assume you're referring to
> mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
> - I don't think a -fix.patch existed?

Yes. the patch that should be discarded is 
mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch

thx!
cyc


