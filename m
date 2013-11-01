Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3KAVTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:19:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33446 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752852Ab3KAVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:19:15 -0400
Date: Fri, 1 Nov 2013 17:19:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Romain Naour <romain.naour@openwide.fr>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH 1/1] trace-cmd: use pkg-config instead of python-config
Message-ID: <20131101171911.274da55e@gandalf.local.home>
In-Reply-To: <1383241182-11162-1-git-send-email-romain.naour@openwide.fr>
References: <1383241182-11162-1-git-send-email-romain.naour@openwide.fr>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc me on trace-cmd patches.

Johannes and Darren,

Since you handle the python bindings in trace-cmd, can you give me an
ack or nack.

Thanks!

-- Steve


On Thu, 31 Oct 2013 18:39:42 +0100
Romain Naour <romain.naour@openwide.fr> wrote:

> From: Romain <romain.naour@openwide.fr>
> 
> trace-cmd use python-config to find out which headers
> and libraries should be used to link against the Python libraries.
> By default, python-config returns paths that are inappropriate for
> cross-compilation.
> 
> Add PYTHON_VERS to build trace-cmd with python2 or python3
> 
> Signed-off-by: Romain Naour <romain.naour@openwide.fr>
> ---
>  Makefile | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 1964949..2f862ec 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -81,8 +81,10 @@ ifndef NO_PYTHON
>  PYTHON		:= ctracecmd.so
>  PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
>  
> +PYTHON_VERS ?= python
> +
>  # Can build python?
> -ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
> +ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo y"), y)
>  	PYTHON_PLUGINS := plugin_python.so
>  	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
>  	PYTHON_SO_INSTALL := ctracecmd.install
> @@ -550,8 +552,8 @@ clean:
>  
>  ##### PYTHON STUFF #####
>  
> -PYTHON_INCLUDES = `python-config --includes`
> -PYTHON_LDFLAGS = `python-config --ldflags` \
> +PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
> +PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
>  		$(shell python -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LINKFORSHARED')")
>  PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
>  

