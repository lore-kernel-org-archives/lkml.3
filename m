Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935904Ab3BOPbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:31:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935780Ab3BOPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:31:10 -0500
Message-ID: <511E54B7.2080709@suse.cz>
Date: Fri, 15 Feb 2013 16:31:03 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sunil Beta Baskar <betasam@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix: build aborts if SPACE characters are found in path.
References: <CAK2BWApu9PjkmDdV4HoFXcq9KTh4e57iEdwYn9muVmYRwRNXgw@mail.gmail.com>
In-Reply-To: <CAK2BWApu9PjkmDdV4HoFXcq9KTh4e57iEdwYn9muVmYRwRNXgw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.1.2013 15:33, Sunil Beta Baskar wrote:
> Signed-off-by: Sunil Beta <betasam@gmail.com>
> ---
>  Makefile |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 07bc925..48bfd8e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -10,6 +10,8 @@ NAME = "Divemaster Edition"
>  # Comments in this file are targeted only to the developer, do not
>  # expect to learn how to build the kernel reading this file.
> 
> +CURDIRSPC := $(echo $(CURDIR) | sed "s/ /\\\ /g" )
> +$(ifneq $(CURDIR),$(CURDIRSPC), $(error directory $(CURDIR) contains spaces.))

You do not need to call shell and sed here. Use the findstring make
function and the $(space) variable from scripts/Kbuild.include. Also,
while at it, could you also add a check for colon? This breaks the build
in similar way.

Thanks,
Michal
