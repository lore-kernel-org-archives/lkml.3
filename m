Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbbAIV3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:29:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbbAIV3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:29:08 -0500
Date: Fri, 9 Jan 2015 22:29:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: fix deferred module patching order
In-Reply-To: <47ab47fd3a2e7794edfe9b45b163582eee0a925c.1420833475.git.jpoimboe@redhat.com>
Message-ID: <alpine.LNX.2.00.1501092228010.15299@pobox.suse.cz>
References: <47ab47fd3a2e7794edfe9b45b163582eee0a925c.1420833475.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015, Josh Poimboeuf wrote:

> When applying multiple patches to a module, if the module is loaded
> after the patches are loaded, the patches are applied in reverse order:
> 
>   $ insmod patch1.ko
>   [   43.172992] livepatch: enabling patch 'patch1'
> 
>   $ insmod patch2.ko
>   [   46.571563] livepatch: enabling patch 'patch2'
> 
>   $ modprobe nfsd
>   [   52.888922] livepatch: applying patch 'patch2' to loading module 'nfsd'
>   [   52.899847] livepatch: applying patch 'patch1' to loading module 'nfsd'
> 
> Fix the loading order by storing the klp_patches list in queue order.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Applied and pushed out, thanks.

-- 
Jiri Kosina
SUSE Labs
