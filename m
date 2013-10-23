Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3JWNVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:21:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3JWNVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:21:06 -0400
Message-ID: <5267CD3C.2020004@suse.cz>
Date: Wed, 23 Oct 2013 15:21:00 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Afzal Mohammed <afzal.mohd.ma@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH RFC] kbuild: prevent git private tag altering kernelrelease
References: <1379109004-2411-1-git-send-email-afzal.mohd.ma@gmail.com>
In-Reply-To: <1379109004-2411-1-git-send-email-afzal.mohd.ma@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Afzal,

sorry for the late feedback.

On 13.9.2013 23:49, Afzal Mohammed wrote:
> If a private tag is created after the most recent kernelversion tag, a
> commit after this private tag would feed kernelrelease with commits
> after private tag and kernelversion tag. This may confuse user relying
> on kernelrelease (mostly a developer while debugging), mainly if HEAD
> has a private tag and otherwise w.r.t git distance from kernelversion
> tag.

The solution is simple: Do not use private annotated tags. Or rather, if
you are creating an annotated tag, modify EXTRAVERSION accordingly. Any
automagic based on the tag name is going to fail in some way.


> Instead if such a tag is created at say HEAD~, kernelrelease would be
> v3.11.0-rc1-00001-gdeadbeef, misleading the observer w.r.t git distance
> from nearest kernelversion tag.
> 
> Here an attempt is made to prevent private tag from altering
> kernelrelease.
> 
> Signed-off-by: Afzal Mohammed <afzal.mohd.ma@gmail.com>
> ---
> 
> Hi,
> 
> This seems to work on different scenarios that could be readily thought
> of. I am shaky about this change, but acheives the purpose.

With your change, the script considers e.g. the next-YYYYMMDD tags
"private."


>  define filechk_kernel.release
> -	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
> +	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree) $(KERNELVERSION))" > $@
>  endef

The >$@ should not be there.

Michal
