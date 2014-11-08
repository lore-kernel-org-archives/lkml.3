Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaKHLgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 06:36:35 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:43684 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbaKHLge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 06:36:34 -0500
Date: Sat, 8 Nov 2014 12:36:25 +0100
From: Alban <albeu@free.fr>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Aban Bedel <albeu@free.fr>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/2] MIPS: FW: Fix parsing u-boot environment
Message-ID: <20141108123625.5bf49656@tock>
In-Reply-To: <545CBE5E.3050906@cogentembedded.com>
References: <1415359381-27257-1-git-send-email-albeu@free.fr>
	<545CBE5E.3050906@cogentembedded.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 15:43:10 +0300
Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:

> Hello.
> 
> On 11/7/2014 2:23 PM, Alban Bedel wrote:
> 
> > When reading u-boot's key=value pairs it should skip the '=' and not
> > use the next argument.
> 
> > Signed-off-by: Alban Bedel <albeu@free.fr>
> > ---
> >   arch/mips/fw/lib/cmdline.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> > diff --git a/arch/mips/fw/lib/cmdline.c b/arch/mips/fw/lib/cmdline.c
> > index ffd0345..cc5d168 100644
> > --- a/arch/mips/fw/lib/cmdline.c
> > +++ b/arch/mips/fw/lib/cmdline.c
> > @@ -68,7 +68,7 @@ char *fw_getenv(char *envname)
> >   					result = fw_envp(index +
> > 1); break;
> >   				} else if (fw_envp(index)[i] ==
> > '=') {
> > -					result = (fw_envp(index +
> > 1) + i);
> > +					result = (fw_envp(index) +
> > i + 1);
> 
>     Perhaps it's time to drop the useless outer parens?

I agree, I'm sending a new serie.

Alban
