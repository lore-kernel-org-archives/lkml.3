Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbaFRJGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:06:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964813AbaFRJGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:06:17 -0400
Message-ID: <53A15684.9000002@suse.cz>
Date: Wed, 18 Jun 2014 11:06:12 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: relative objtree change broke tar builds?
References: <20140617223854.GC6168@fieldses.org>
In-Reply-To: <20140617223854.GC6168@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 18.6.2014 00:38, J. Bruce Fields napsal(a):
> The scripts I use for my kernel testing rely on the targz-pkg make
> target.  After updating to 3.16-rc1 my scripts started failing.  In
> scripts/package/buildtar:
> 
>   tmpdir="${objtree}/tar-install"
>   tarball="${objtree}/linux-${KERNELRELEASE}-${ARCH}.tar"
> ..
>   #
>   # Create the tarball
>   #
>   (
>         cd "${tmpdir}"
>         opts=
>         if tar --owner=root --group=root --help >/dev/null 2>&1; then
>                 opts="--owner=root --group=root"
>         fi
>         tar cf - boot/* lib/* $opts | ${compress} > "${tarball}${file_ext}"
>   )

Thanks for the report, I'll fix it.


> The changelog there says
> 
> 	The main Makefile sets its working directory to the object tree
> 	and never changes it again. Therefore, we can use '.' instead of
> 	the absolute path.
> 
> But the main Makefile also exports objtree, and a quick grep suggests
> lots of other uses outside the main Makefile.

Do you have examples? Besides your report, I'm only aware of make
deb-pkg and make *docs. What else?

Thanks,
Michal

