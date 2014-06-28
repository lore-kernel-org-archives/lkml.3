Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaF1WEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 18:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaF1WEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 18:04:32 -0400
Date: Sun, 29 Jun 2014 00:04:21 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lib/argv_split.c : should argv be kfree'ed ?
Message-ID: <20140628220421.GA24883@mguzik.redhat.com>
References: <53AF3925.7070300@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53AF3925.7070300@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 11:52:37PM +0200, Toralf Förster wrote:
> /me wonders if this patch is needed here :
> 
> 
> diff --git a/lib/argv_split.c b/lib/argv_split.c
> index e927ed0..7de4cb4 100644
> --- a/lib/argv_split.c
> +++ b/lib/argv_split.c
> @@ -85,6 +85,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
>                         *argv++ = argv_str;
>                 }
>         }
> +       kfree (argv);
>         *argv = NULL;
> 
>         if (argcp)
> 

No, see argv_free.

-- 
Mateusz Guzik
