Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaFVLXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:23:45 -0400
Received: from mout.gmx.net ([212.227.15.15]:55524 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaFVLXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:23:43 -0400
Message-ID: <1403436214.26292.4.camel@schoellingm.dzne.de>
Subject: Re: [PATCH] xilinx: Fix compiler warning
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: michal.simek@xilinx.com, anirudh@xilinx.com, John.Linn@xilinx.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2014 13:23:34 +0200
In-Reply-To: <53A6BAC5.80206@cogentembedded.com>
References: <1403432461-18296-1-git-send-email-manuel.schoelling@gmx.de>
	 <53A6BAC5.80206@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:f12ucX/iqhHMWUrQyOJ8L+nzFOLl8HETL2UqekTMQg7oB3qwKrm
 cCkeY2ztt77FbX+0dTJ7sxTgCooU9GXyCrnkiv4rV5i1DyNfr17W/6UaarlcLMvPQWf707T
 MuVkAVZMo3kzksvrrBtgOQLpGznFTsmjQIs3G4ldnjHun8BOVGeD7nnm7tvQeUTK/1xQTa4
 svSus5fCLMqt9R/h4cIfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 2014-06-22 at 15:15 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 06/22/2014 02:21 PM, Manuel Schölling wrote:
> 
> > The time comparsion functions require arguments of type unsigned long
> > instead of (signed) long.
> 
> > Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> 
> [...]
> 
> > diff --git a/init/do_mounts.c b/init/do_mounts.c
> > index 60c4196..2d069a3 100644
> > --- a/init/do_mounts.c
> > +++ b/init/do_mounts.c
> > @@ -351,7 +351,6 @@ static void __init get_fs_names(char *page)
> >   				continue;
> >   			line++;
> >
> > -			/* append fsname */
> >   			memmove(fsnames, line, strlen(line)+1);
> >   			fsnames += strlen(fsnames)+1;
> >   		} while (page != NULL);
> >
> 
>    Seems like unrelated random change.
Thanks, you are right: somehow this change made it into my patch.
Probably I was not careful enough when using 'git commit -a'.

Sorry, I will resend a fixed patch in a second.

> 
> WBR, Sergei
> 


