Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaKFONg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:13:36 -0500
Received: from mout.gmx.net ([212.227.15.15]:49435 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaKFONd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:13:33 -0500
MIME-Version: 1.0
Message-ID: <trinity-0f66694d-8245-42b3-8a2b-18e1a42aff0a-1415283210789@3capp-gmx-bs40>
From: "Peter Kuemmel" <syntheticpp@gmx.net>
To: "Paul Bolle" <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: =?UTF-8?Q?Aw=3A_Re=3A_=5BPATCH=5D_kconfig=3A_Fix_warnin?=
 =?UTF-8?Q?g_=22=E2=80=98jump=E2=80=99_may_be_used_uninitialized=22?=
Content-Type: text/plain; charset=UTF-8
Date: Thu, 6 Nov 2014 15:13:30 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <1415277392.4390.29.camel@x220>
References: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>,
 <1415277392.4390.29.camel@x220>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:EXx8fjFU71iFQk9FSgtSbojI4jXTDbtdW0K9UhK/NF7
 Mkhsh98elg1QHo3dFpGhsJtgTlt+yVb1L4xopjscpZeGLuvk8j
 UhMmfO6fIGySNmKuxgWmFOslCNShtERCt6lUnS7hIzOB5oJyIm
 yOzdQtq43I5WnjjrWXc+FsAeqpQA6va1lMWlgmR+S8kdoz6ryR
 s2pLgzZ4s9iazdkciW5bFua9lXknMFyF+dYuapMKTGgu/qll0W
 tP23Y9HhFk/m1AHBb/47h3K7Fh8GaEFR1D+9fba1OX5NzMTJ2T vzqfyo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are identical.
lkml is also listed by ./scripts/get_maintainer.pl, so I thought patches should also be send to lkml.

Peter

> Gesendet: Donnerstag, 06. November 2014 um 13:36 Uhr
> Von: "Paul Bolle" <pebolle@tiscali.nl>
> An: "Peter Kümmel" <syntheticpp@gmx.net>
> Cc: linux-kernel@vger.kernel.org
> Betreff: Re: [PATCH] kconfig: Fix warning "‘jump’ may be used uninitialized"
>
> On Thu, 2014-11-06 at 13:03 +0100, Peter Kümmel wrote:
> > Warning:
> > In file included from scripts/kconfig/zconf.tab.c:2537:0:
> > scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> > scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >      jump->offset = strlen(r->s);
> > 
> > Simplifies the test logic because (head && local) means (jump != 0)
> > and makes GCC happy when checking if the jump pointer was initialized.
> > 
> > Signed-off-by: Peter Kümmel <syntheticpp@gmx.net>
> > ---
> 
> Is this patch and the three others patches you just sent identical (or
> not) to the four patches you sent yesterday and the day before yesterday
> to linux-kbuild and Yann Morin? Either way, why are you posting them to
> lkml now?
> 
> >  scripts/kconfig/menu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> > index a26cc5d..72c9dba 100644
> > --- a/scripts/kconfig/menu.c
> > +++ b/scripts/kconfig/menu.c
> > @@ -548,7 +548,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
> >  {
> >  	int i, j;
> >  	struct menu *submenu[8], *menu, *location = NULL;
> > -	struct jump_key *jump;
> > +	struct jump_key *jump = NULL;
> >  
> >  	str_printf(r, _("Prompt: %s\n"), _(prop->text));
> >  	menu = prop->menu->parent;
> > @@ -586,7 +586,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
> >  		str_printf(r, _("  Location:\n"));
> >  		for (j = 4; --i >= 0; j += 2) {
> >  			menu = submenu[i];
> > -			if (head && location && menu == location)
> > +			if (jump && menu == location)
> >  				jump->offset = strlen(r->s);
> >  			str_printf(r, "%*c-> %s", j, ' ',
> >  				   _(menu_get_prompt(menu)));
> 
> 
>
