Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3F1WoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:44:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab3F1WoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:44:24 -0400
Message-ID: <51CE11C2.5020406@suse.cz>
Date: Sat, 29 Jun 2013 00:44:18 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?5byg5b+g5bGx?= <zzs0213@gmail.com>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] let kbuild mkdir for dir/file.o
References: <1370335532-17891-1-git-send-email-zzs0213@gmail.com> <1370335532-17891-2-git-send-email-zzs0213@gmail.com>
In-Reply-To: <1370335532-17891-2-git-send-email-zzs0213@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for the late feedback.

Dne 4.6.2013 10:45, 张忠山 napsal(a):
> when add a obj with dir to obj-y, like this
> 
>     obj-y += dir/file.o
> 
> the $(obj)/dir not created, this patch fix this
> 
> this bug caused by commit
>    f5fb976520a53f45f8bbf2e851f16b3b5558d485

Please also include the wonderful explanation including the error
message that you posted separately
(http://permalink.gmane.org/gmane.linux.kbuild.devel/10050). Also,
please CC linux-kernel in addition to linux-kbuild.


> 
> Signed-off-by: 张忠山 <zzs0213@gmail.com>
> ---
>  scripts/Makefile.lib |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 51bb3de..6bae5a9 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -63,7 +63,8 @@ multi-objs   := $(multi-objs-y) $(multi-objs-m)
>  subdir-obj-y := $(filter %/built-in.o, $(obj-y))
>  
>  # $(obj-dirs) is a list of directories that contain object files
> -obj-dirs := $(dir $(multi-objs) $(subdir-obj-y))
> +__subdir-obj-y := $(foreach o,$(obj-y),$(if $(filter-out $(o),$(notdir $(o))),$(o)))

This complicated filter returns entries from $(obj-y) that contain a
slash, is that correct? If so, is it really necessary? Why not simply
add whole $(obj-y) to $(obj-dirs) and be done? $(multi-objs) is also
added without any filtering.

> +obj-dirs := $(dir $(multi-objs) $(__subdir-obj-y))


thanks,
Michal
