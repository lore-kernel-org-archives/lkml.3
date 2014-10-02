Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaJBNz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:55:28 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:56727 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaJBNz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:55:27 -0400
Date: Thu, 02 Oct 2014 22:55:14 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kbuild: Do not reference *-n variables in the Makefile
Cc: linux-kbuild@vger.kernel.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <542D54A7.604@suse.cz>
References: <1412256796-4111-1-git-send-email-mmarek@suse.cz> <542D54A7.604@suse.cz>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20141002225513.350B.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Thu, 02 Oct 2014 15:35:35 +0200
Michal Marek <mmarek@suse.cz> wrote:

> On 2014-10-02 15:33, Michal Marek wrote:
> > Kconfig options are either 'y', 'm', or undefined.
> > 
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > ---
> >  Makefile | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index efbd2cb..106f300 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -868,9 +868,7 @@ vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
> >  		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
> >  
> >  vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
> > -		     $(init-n) $(init-) \
> > -		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
> > -		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
> > +		     $(init-) $(core-) $(drivers-) $(net-) $(libs-))))
> 
> Actually, all the directories are hardcoded in
> {init,code,drivers,net,libs}-y; there are currently no Kconfig variables
> involved. But let's keep this generic and handle *-m and *- just in case.
> 

Agreed and thank you!

Best Regards
Masahiro Yamada

