Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3CNWPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:15:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58938 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273Ab3CNWPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:15:03 -0400
X-Sasl-enc: l891YlDm52nqoZGitaBHY3HoDOFdPJ09ucVFW1oEsoYK 1363299302
Date: Thu, 14 Mar 2013 15:15:01 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Tony Jones <tonyj@suse.de>, Andrew Vagin <avagin@openvz.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [stable revert request] ... of doubled commit
Message-ID: <20130314221501.GA30053@kroah.com>
References: <513A5FC7.8040409@suse.cz>
 <513A663B.3090506@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A663B.3090506@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 11:29:15PM +0100, Jiri Slaby wrote:
> On 03/08/2013 11:01 PM, Jiri Slaby wrote:
> > Hi,
> > 
> > Tony Jones found that the following commit:
> >   perf: Fix parsing of __print_flags() in TP_printk()
> > is applied to 3.0 twice.
> > 
> > Once as:
> > commit 248f3235861683bb1ffc7316b56bf783b162666f
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Fri Nov 4 16:32:25 2011 -0400
> > 
> >     perf: Fix parsing of __print_flags() in TP_printk()
> > 
> >     commit d06c27b22aa66e48e32f03f9387328a9af9b0625 upstream.
> > 
> > ===== and =====
> > The second one is this:
> > commit 2431496fbdd142ccc83138d94f3f510a36ce9270
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Fri Nov 4 16:32:25 2011 -0400
> > 
> >     perf: Fix parsing of __print_flags() in TP_printk()
> > 
> >     commit 49908a1b25d448d68fd26faca260e1850201575f upstream.
> > 
> > =====
> > 
> > The latter is not an upstream commit, it is from pm-fixes, hence the
> > difference in commit SHAs.
> 
> git command I used was not perfect. It is an upstream commit (git is
> kind of confused with these two commit. So am I.). However the rest of
> the email is correct.

Thanks for pointing this out, now reverted.

greg k-h
