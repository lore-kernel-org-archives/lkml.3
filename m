Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaFRQMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:12:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaFRQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:12:33 -0400
Message-ID: <53A1BA70.2070702@infradead.org>
Date: Wed, 18 Jun 2014 09:12:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Documentation: Fix DocBook build with relative $(srctree)
References: <539F2926.4020004@infradead.org> <1403105262-16367-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1403105262-16367-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/14 08:27, Michal Marek wrote:
> After commits 890676c6 (kbuild: Use relative path when building in the source
> tree) and 9da0763b (kbuild: Use relative path when building in a subdir
> of the source tree), the $(srctree) variable can be a relative path.
> This breaks Documentation/DocBook/media/Makefile, because it tries to
> create symlinks from a subdirectory of the object tree to the source
> tree. Fix this by using a full path in this case.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

Please merge to Linus sooner instead of later.


> ---
>  Documentation/DocBook/media/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
> index 1d27f0a..639e748 100644
> --- a/Documentation/DocBook/media/Makefile
> +++ b/Documentation/DocBook/media/Makefile
> @@ -202,8 +202,8 @@ $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
>  
>  $(MEDIA_OBJ_DIR)/v4l2.xml: $(OBJIMGFILES)
>  	@$($(quiet)gen_xml)
> -	@(ln -sf $(MEDIA_SRC_DIR)/v4l/*xml $(MEDIA_OBJ_DIR)/)
> -	@(ln -sf $(MEDIA_SRC_DIR)/dvb/*xml $(MEDIA_OBJ_DIR)/)
> +	@(ln -sf `cd $(MEDIA_SRC_DIR) && /bin/pwd`/v4l/*xml $(MEDIA_OBJ_DIR)/)
> +	@(ln -sf `cd $(MEDIA_SRC_DIR) && /bin/pwd`/dvb/*xml $(MEDIA_OBJ_DIR)/)
>  
>  $(MEDIA_OBJ_DIR)/videodev2.h.xml: $(srctree)/include/uapi/linux/videodev2.h $(MEDIA_OBJ_DIR)/v4l2.xml
>  	@$($(quiet)gen_xml)
> 


-- 
~Randy
