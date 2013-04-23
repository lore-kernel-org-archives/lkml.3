Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3DWVn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:43:28 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:44498 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3DWVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:43:27 -0400
Date: Tue, 23 Apr 2013 16:50:11 -0400
From: Anton Vorontsov <anton@enomsg.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: jason.wessel@windriver.com, sasha.levin@oracle.com,
        vincent.stehle@laposte.net, john.blackwood@ccur.com,
        kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: debug: kdb: strncpy issue, using strlcpy instead
 of strncpy.
Message-ID: <20130423205011.GA5915@teo>
References: <5161526F.8070306@asianux.com>
 <516E6EB1.70100@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <516E6EB1.70100@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:43:13PM +0800, Chen Gang wrote:
> Hello maintainers:
> 
>   please help check this patch, when you have time, thanks.
> 

The patch looks good. I would add to the description: "..., otherwise the
destination string might end up not being terminted with the NUL, causing
all sorts of misbehaviour."

	Acked-by: Anton Vorontsov <anton@enomsg.org>

Thanks!

> On 2013年04月07日 19:03, Chen Gang wrote:
> > 
> >   cmd_cur and cmd_hist[] are all NUL terminated string.
> >   need using strlcpy instead of strncpy.
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  kernel/debug/kdb/kdb_main.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> > index 00eb8f7..a2b04d7 100644
> > --- a/kernel/debug/kdb/kdb_main.c
> > +++ b/kernel/debug/kdb/kdb_main.c
> > @@ -1063,12 +1063,12 @@ static int handle_ctrl_cmd(char *cmd)
> >  	case CTRL_P:
> >  		if (cmdptr != cmd_tail)
> >  			cmdptr = (cmdptr-1) % KDB_CMD_HISTORY_COUNT;
> > -		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
> > +		strlcpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
> >  		return 1;
> >  	case CTRL_N:
> >  		if (cmdptr != cmd_head)
> >  			cmdptr = (cmdptr+1) % KDB_CMD_HISTORY_COUNT;
> > -		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
> > +		strlcpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
> >  		return 1;
> >  	}
> >  	return 0;
> > @@ -1260,7 +1260,7 @@ do_full_getstr:
> >  		if (*cmdbuf != '\n') {
> >  			if (*cmdbuf < 32) {
> >  				if (cmdptr == cmd_head) {
> > -					strncpy(cmd_hist[cmd_head], cmd_cur,
> > +					strlcpy(cmd_hist[cmd_head], cmd_cur,
> >  						CMD_BUFLEN);
> >  					*(cmd_hist[cmd_head] +
> >  					  strlen(cmd_hist[cmd_head])-1) = '\0';
> > @@ -1270,7 +1270,7 @@ do_full_getstr:
> >  				cmdbuf = cmd_cur;
> >  				goto do_full_getstr;
> >  			} else {
> > -				strncpy(cmd_hist[cmd_head], cmd_cur,
> > +				strlcpy(cmd_hist[cmd_head], cmd_cur,
> >  					CMD_BUFLEN);
> >  			}
> >  
> > 
> 
> 
> -- 
> Chen Gang
> 
> Asianux Corporation
