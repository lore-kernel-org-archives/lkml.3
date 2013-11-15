Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3KOO0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:26:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab3KOO0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:26:43 -0500
Date: Fri, 15 Nov 2013 09:26:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Baoquan He <bhe@redhat.com>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Young <dyoung@redhat.com>, WANG Chao <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Message-ID: <20131115142617.GC6637@redhat.com>
References: <20131113204130.GD7613@redhat.com>
 <5284A689.70903@jp.fujitsu.com>
 <20131114151359.GA3913@redhat.com>
 <5285EC60.1060906@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5285EC60.1060906@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 06:41:52PM +0900, HATAYAMA Daisuke wrote:

[..]
> >Given the fact that hpa does not like fixing it in kernel. We are left
> >with option of fixing it in following places.
> >
> >- Drop partial pages in kexec-tools
> >- Drop partial pages in makeudmpfile.
> >- Read partial pages using read() interface in makedumpfile
> >- Modify /proc/vmcore to copy partial pages in second kernel's memory.
> >
> >It is not clear to me that partial pages are really useful.  So I want
> >to avoid modifying /proc/vmcore to deal with partial pages and increase
> >complexity.
> >
> >So fixing makedumpfile (either option2 or option 3) seems least risky
> >to me. In fact I would say let us keep it simple and truncate partial
> >pages in makedumpfile to keep it simple. And look at option 3 once we
> >have a strong use case for partial pages.
> >
> >What do you think?
> >
> 
> As you say, it's not clear that partial pages are really useful, but on
> the other hand, it seems to me not clear that they are really useless.
> I think we should get them as long as we have access to them.
> 
> It seems best to me the option 3). Switching between read and mmap would
> be not so complex and also it's by far flexible in makedumpfile than in
> kernel.

Ok, I am fine with option 3. It is more complicated option but safe
option.

Is there any chance that you could look into fixing this. I have no
experience writing code for makedumpfile.

Thanks
Vivek
