Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbbAUOGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:06:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbbAUOGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:06:40 -0500
Date: Wed, 21 Jan 2015 15:06:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Bin <huawei.libin@huawei.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, xiexiuqi@huawei.com
Subject: Re: [PATCH 1/2] livepatch: Revert "livepatch: enforce patch stacking
 semantics"
In-Reply-To: <1421831262-27869-2-git-send-email-huawei.libin@huawei.com>
Message-ID: <alpine.LNX.2.00.1501211505180.10817@pobox.suse.cz>
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com> <1421831262-27869-2-git-send-email-huawei.libin@huawei.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Li Bin wrote:

> This reverts commit 83a90bb1345767f0cb96d242fd8b9db44b2b0e17.
> 
> The method that only allowing the topmost patch on the stack to be
> enabled or disabled is unreasonable. Such as the following case:
> 
> 	- do live patch1
> 	- disable patch1
> 	- do live patch2 //error
>
> Now, we will never be able to do new live patch unless disabing the
> patch1 although there is no dependencies.

Unregistering disabled patch still works and removes it from the list no 
matter the position.

So what exactly is the problem?

-- 
Jiri Kosina
SUSE Labs
