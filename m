Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab3CLT4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:56:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397Ab3CLT4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:56:51 -0400
Date: Tue, 12 Mar 2013 15:56:47 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130312195647.GB2186@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk>
 <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312194353.GI21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 07:43:53PM +0000, Al Viro wrote:
 > On Tue, Mar 12, 2013 at 08:31:50AM -0700, Linus Torvalds wrote:
 > 
 > > Probably not missing anything subtle. I think all of this code is very
 > > old, and related to previous /proc/<pid>/fd/<n> escapades. And the
 > > semantics for those files were in flux some time long long ago (the
 > > whole "dup vs new struct file" issue), it's all just duct-tape, I
 > > think.
 > 
 > Umm...  How about the following, then?  I think it makes the whole thing
 > simpler and saner...  NOTE: this got only a light beating and we'd
 > just seen an example of long-standing breakage in that area; I'd really
 > like to see it tortured by Dave's scripts before it gets merged into
 > mainline.

I can do that.  I'll holler if I see anything that looks out of place.

	Dave

