Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaK0IYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:24:42 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44104 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaK0IYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:24:41 -0500
Message-ID: <5476DFC5.6020709@plexistor.com>
Date: Thu, 27 Nov 2014 10:24:37 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        Michal Marek <mmarek@suse.cz>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Romer <benjamin.romer@unisys.com>
Subject: Re: linux-next: manual merge of the staging tree with the kbuild
 tree
References: <20141127190508.3305dfe8@canb.auug.org.au>
In-Reply-To: <20141127190508.3305dfe8@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict
> in .gitignore between commit dfe0487249e5 (".gitignore: Add Kdevelop4
> project files") from the kbuild tree and commit 75185f57f110 ("staging:
> unisys: fix CamelCase macro names in controlframework.h") from the
> staging tree.
> 

Hi Greg Michal

I suggest to unify the two like:

+# IDE project files
+*.kdev4
+.project
+.cproject

And put the one patch from one tree. There is no need to
comment about every IDE out there, just the one section for
them all, I think

Tell me if you guys need a patch and/or which tree should take
it?

Thanks
Boaz

> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc .gitignore
> index ce57b79670a5,6bfac06d79ca..000000000000
> --- a/.gitignore
> +++ b/.gitignore
> @@@ -97,5 -97,6 +97,9 @@@ x509.genke
>   # Kconfig presets
>   all.config
>   
>  +# Kdevelop4
>  +*.kdev4
> ++
> + #eclipse files
> + .project
> + .cproject

