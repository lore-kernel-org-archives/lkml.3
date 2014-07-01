Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaGAISD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:18:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaGAISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:18:00 -0400
Date: Tue, 1 Jul 2014 01:17:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        joe@perches.com
Subject: Re: [RFC 1/1] proc: constify seq_operations
Message-ID: <20140701081759.GA19708@infradead.org>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
 <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 01:39:39PM -0700, Andrew Morton wrote:
> On Mon, 30 Jun 2014 21:03:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > proc_uid_seq_operations, proc_gid_seq_operations and proc_projid_seq_operations
> > are only called in proc_id_map_open with seq_open as
> > const struct seq_operations so we can constify the 3 structures and update
> > proc_id_map_open prototype.
> 
> There are an absolutely enormous number of places where we could
> constify things.  For sheer sanity's sake I'm not inclined to churn the
> code in this way unless a patch provides some sort of runtime benefit. 
> And this particular patch doesn't appear to change the generated code
> at all.

Unlike a lot of the cleanup patches which provide no benefit at all
constifying op vectors moves them from .text to .data which is not
marked executable and thus reduce the attack vector for kernel exploits.

So I defintively like to see these much more than a lot of the other
things filling up the lists.
