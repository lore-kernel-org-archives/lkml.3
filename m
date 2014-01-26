Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaAZQbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 11:31:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaAZQbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 11:31:01 -0500
Date: Sun, 26 Jan 2014 17:30:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Geng Hui <hui.geng@huawei.com>
Subject: Re: [PATCH] Use realpath for srctree and objtree
Message-ID: <20140126163045.GA1126@krava.brq.redhat.com>
References: <1390730778-30366-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390730778-30366-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 06:06:18PM +0800, Wang Nan wrote:
> When BUILD_SRC contains a tailing '/', the file name used in compiling command
> will contain '//', and it then goes to .o's debuginfo, confuses debugedit:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=304121
> 
> This patch uses realpath to makesure srctree and objtree don't have tailing '/'.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Geng Hui <hui.geng@huawei.com>
> 
> ---
>  tools/lib/lockdep/Makefile    | 4 ++--
>  tools/lib/traceevent/Makefile | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
> index da8b7aa..e638dd5 100644
> --- a/tools/lib/lockdep/Makefile
> +++ b/tools/lib/lockdep/Makefile
> @@ -87,8 +87,8 @@ endif # BUILD_SRC
>  # We process the rest of the Makefile if this is the final invocation of make
>  ifeq ($(skip-makefile),)
>  
> -srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
> -objtree		:= $(CURDIR)
> +srctree		:= $(realpath $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR)))
> +objtree		:= $(realpath $(CURDIR))
>  src		:= $(srctree)
>  obj		:= $(objtree)
>  
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index 56d52a3..dd23171 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -107,8 +107,8 @@ endif # BUILD_SRC
>  # We process the rest of the Makefile if this is the final invocation of make
>  ifeq ($(skip-makefile),)
>  
> -srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
> -objtree		:= $(CURDIR)
> +srctree		:= $(realpath $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR)))
> +objtree		:= $(realpath $(CURDIR))
>  src		:= $(srctree)
>  obj		:= $(objtree)

ack for the traceevent change

thanks,
jirka
