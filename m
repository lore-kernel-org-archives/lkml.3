Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3G3PIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:08:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3G3PIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:08:49 -0400
Date: Tue, 30 Jul 2013 08:08:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, bp@suse.de,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH resend] drop_caches: add some documentation and info
 message
Message-Id: <20130730080810.9a0a2d71.akpm@linux-foundation.org>
In-Reply-To: <51F7D1F0.20309@intel.com>
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz>
	<20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
	<20130730074531.GA10584@dhcp22.suse.cz>
	<20130730012544.2f33ebf6.akpm@linux-foundation.org>
	<20130730125525.GB15847@dhcp22.suse.cz>
	<51F7D1F0.20309@intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 07:47:12 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 07/30/2013 05:55 AM, Michal Hocko wrote:
> >> > If we add another flag in the future it can use bit 3?
> > What if we get crazy and need more of them?
> 
> I really hate using bits for these kinds of interfaces.  I'm forgetful
> and never remember which bit is which, and they're possible to run out of.
> 
> I'm not saying do it now, but we can switch over to:
> 
> 	echo 'slab|pagecache' > drop_caches
> or
> 	echo 'quiet|slab' > drop_caches
> 
> any time we want and still have compatibility with the existing bitwise
> interface.

	/bin/drop_caches "slab|pagecache"

That we always insist on doing such things in the kernel instead is
exhibit #1 in Why We Suck.

