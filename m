Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3JBFdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:33:52 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42941 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3JBFdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:33:50 -0400
Date: Tue, 1 Oct 2013 22:33:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Martin Walch <walch.martin@web.de>
cc: Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        Alan Cox <alan@linux.intel.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kconfig: adjust warning message for conflicting
 types
In-Reply-To: <2865108.QhoiiS6j3s@tacticalops>
Message-ID: <alpine.DEB.2.02.1310012230090.5682@chino.kir.corp.google.com>
References: <2865108.QhoiiS6j3s@tacticalops>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, Martin Walch wrote:

> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index b970101..e511df5 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -119,7 +119,7 @@ void menu_set_type(int type)
>  		sym->type = type;
>  		return;
>  	}
> -	menu_warn(current_entry, "type of '%s' redefined from '%s' to '%s'",
> +	menu_warn(current_entry, "type of '%s' not redefined from '%s' to '%s'",
>  	    sym->name ? sym->name : "<choice>",
>  	    sym_type_name(sym->type), sym_type_name(type));
>  }

The warning is stating that the symbol was attempted to be redefined from 
one type to another, not that it was successful, so I don't think this 
patch actually helps make anything clearer.  (gcc warns when a symbol is 
redefined by saying "redefintion of `blah`".)  Perhaps include that the 
redefinition was ignored?
