Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3LTBA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:00:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab3LTBA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:00:56 -0500
Date: Thu, 19 Dec 2013 20:00:42 -0500
From: Dave Jones <davej@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: bad page state in 3.13-rc4
Message-ID: <20131220010042.GA32112@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kent Overstreet <kmo@daterainc.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20131219155313.GA25771@redhat.com>
 <CA+55aFyoXCDNfHb+r5b=CgKQLPA1wrU_Tmh4ROZNEt5TPjpODA@mail.gmail.com>
 <20131219181134.GC25385@kmo-pixel>
 <20131219182920.GG30640@kvack.org>
 <CA+55aFzCo_r7ZGHk+zqUjmCW2w7-7z9oxEJjhR66tZ4qZPxnvw@mail.gmail.com>
 <20131219192621.GA9228@kvack.org>
 <CA+55aFz=tEkVAx9VndtCXApDxcw+5T-BxMsVuXp+vMSb05f8Aw@mail.gmail.com>
 <20131219195352.GB9228@kvack.org>
 <20131219202416.GA14519@redhat.com>
 <20131219233854.GD10905@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219233854.GD10905@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:38:54PM -0500, Benjamin LaHaise wrote:
 > On Thu, Dec 19, 2013 at 03:24:16PM -0500, Dave Jones wrote:
 > > Yes. Note the original trace in this thread was a VM_BUG_ON(atomic_read(&page->_count) <= 0);
 > > 
 > > Right after these crashes btw, the box locks up solid. So bad that traces don't
 > > always make it over usb-serial. Annoying.
 > 
 > I think I finally have an idea what's going on now.  Kent's changes in 
 > e34ecee2ae791df674dfb466ce40692ca6218e43 are broken and result in a memory 
 > leak of the aio kioctx.  This eventually leads to the system running out of 
 > memory, which ends up triggering the otherwise hard to hit error paths in 
 > aio_setup_ring().  Linus' suggested changes should fix the badness in the 
 > aio_setup_ring(), but more work has to be done to fix up the percpu 
 > reference counting tie in with the aio code.  I'll fix this up in the 
 > morning if nobody beats me to it over night, as I'm just heading out right 
 > now.

That would explain why I'm having difficulty repeating it in a hurry if it
takes hours of runtime for the leak to reach a point where it becomes a problem.

	Dave

