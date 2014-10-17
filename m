Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaJQPjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:39:52 -0400
Received: from mail.efficios.com ([78.47.125.74]:48243 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaJQPju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:39:50 -0400
Date: Fri, 17 Oct 2014 15:39:37 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <2089672226.10912.1413560376993.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141016222145.GM11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com> <1411677218-29146-7-git-send-email-matthew.r.wilcox@intel.com> <20141016133355.GT19075@thinkos.etherlink> <20141016135903.GA11522@wil.cx> <837939598.10389.1413468726146.JavaMail.zimbra@efficios.com> <20141016222145.GM11522@wil.cx>
Subject: Re: [PATCH v11 06/21] vfs: Add copy_to_iter(), copy_from_iter() and
 iov_iter_zero()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.156.150.204]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: Add copy_to_iter(), copy_from_iter() and iov_iter_zero()
Thread-Index: L92CEuZ1l+5z0rN5sYTHitzU0dObLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Matthew Wilcox" <willy@linux.intel.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <willy@linux.intel.com>, "Matthew Wilcox" <matthew.r.wilcox@intel.com>,
> linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Sent: Friday, October 17, 2014 12:21:46 AM
> Subject: Re: [PATCH v11 06/21] vfs: Add copy_to_iter(), copy_from_iter() and iov_iter_zero()
> 
> On Thu, Oct 16, 2014 at 02:12:06PM +0000, Mathieu Desnoyers wrote:
> > > The access_ok() check is done higher up the call-chain if it's
> > > appropriate.
> > > These functions can be (intentionally) called to access kernel addresses,
> > > so it wouldn't be appropriate to do that here.
> > 
> > If the access_ok() are expected to be already done higher in the
> > call-chain,
> > we might want to rename e.g. copy_to_iter_iovec to
> > __copy_to_iter_iovec(). It helps clarifying the check expectations for the
> > caller.
> 
> I'm following the existing convention in this file; it already had
> copy_page_to_iter() and copy_page_from_iter() as exported symbols.  I
> just added copy_to_iter() and copy_from_iter().
> 

I understand you follow the local style. However, since these style
nits have been known to let security issues creep into the kernel
in the past,it would be good to change the style of this file to add
those also to the pre-existing functions, perhaps in a separate patch.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
