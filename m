Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbbAUOgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:36:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbbAUOgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:36:32 -0500
Date: Wed, 21 Jan 2015 08:36:20 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Li Bin <huawei.libin@huawei.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, xiexiuqi@huawei.com
Subject: Re: [PATCH 1/2] livepatch: Revert "livepatch: enforce patch stacking
 semantics"
Message-ID: <20150121143620.GA2943@cerebellum.variantweb.net>
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com>
 <1421831262-27869-2-git-send-email-huawei.libin@huawei.com>
 <alpine.LNX.2.00.1501211505180.10817@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501211505180.10817@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 03:06:38PM +0100, Jiri Kosina wrote:
> On Wed, 21 Jan 2015, Li Bin wrote:
> 
> > This reverts commit 83a90bb1345767f0cb96d242fd8b9db44b2b0e17.
> > 
> > The method that only allowing the topmost patch on the stack to be
> > enabled or disabled is unreasonable. Such as the following case:
> > 
> > 	- do live patch1
> > 	- disable patch1
> > 	- do live patch2 //error
> >
> > Now, we will never be able to do new live patch unless disabing the
> > patch1 although there is no dependencies.
> 
> Unregistering disabled patch still works and removes it from the list no 
> matter the position.
> 
> So what exactly is the problem?

>From a quick glance, it seems that what this set does is it only
enforces the stacking requirements if two patches patch the same
function.

I'm not sure if that is correct logically or correctly implemented by
these patches yet.

Seth

> 
> -- 
> Jiri Kosina
> SUSE Labs
