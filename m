Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3BHFQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:16:42 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:64554 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3BHFQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:16:41 -0500
Message-ID: <51148A28.4030307@synopsys.com>
Date: Fri, 8 Feb 2013 10:46:24 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.next,gmane.linux.kernel
To: James Hogan <james.hogan@imgtec.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next build conflict between modules and metag trees (LOCKDEP_NOW_UNRELIABLE)
References: <51138CFC.9000508@imgtec.com>
In-Reply-To: <51138CFC.9000508@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013 04:46 PM, James Hogan wrote:
> Hi Rusty,
> 
> The metag architecture tree adds an add_taint(TAINT_DIE) like other
> architectures do, and the modules-next tree adds the
> LOCKDEP_NOW_UNRELIABLE flag to all uses of add_taint (but obviously
> misses arch/metag since it doesn't exist yet), causing a compile error
> on metag in -next when the two are merged together.
> 
> Is it okay for me to merge your commit 373d4d0 ("taint: add explicit
> flag to show whether lock dep is still OK.") in modules-next into the
> base of the metag tree and expect it not to be rebased, so that I can
> then squash the fix into the metag tree?
> 
> The only commits this would include are:
> $ git log --oneline linus/master..373d4d0
> 373d4d0 taint: add explicit flag to show whether lock dep is still OK.
> 64748a2 module: printk message when module signature fail taints kernel.
> 
> Thanks
> James
> 

Being in the same situation as metag (ARC Port), what's the recommended practice
here - do we simply cherry-pick these changes into our tree - or do we merge the
"other" tree on top - ofcourse with premise that "other" tree will not rebase.

Thx,
-Vineet
