Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3EPN3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:29:02 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33284 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3EPN27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:28:59 -0400
Date: Thu, 16 May 2013 09:28:39 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] coredump: format_corename() fixes/cleanups
Message-ID: <20130516132839.GA3430@neilslaptop.think-freely.org>
References: <20130515201158.GA14606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515201158.GA14606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:11:58PM +0200, Oleg Nesterov wrote:
> Hello.
> 
> On 05/13, Oleg Nesterov wrote:
> >
> > With the patch below we can trivially fix the problem,
> >
> >       +       char *fmt = ispipe ? "\e%s\e" : "%s";
> >       ...
> >       -       err = cn_printf(cn, "%s", current->comm);
> >       +       err = cn_printf(cn, fmt, current->comm);
> >
> > Or this ESC hack is too ugly or can break something?
> 
> OK, nobody really nacked "[PATCH] teach argv_split() to ignore the spaces
> surrounded by \e", see http://marc.info/?l=linux-kernel&m=136845597401674
> 
> I am going to send this patch "officially" and fix format_corename/argv_split
> interaction.
> 
> But lets fix other format_corename() bugs first: leak and use-after-free.
> Plus some cleanups.
> 
> Oleg.
> 
>  fs/coredump.c |  120 +++++++++++++++++++++++++++-----------------------------
>  1 files changed, 58 insertions(+), 62 deletions(-)
> 
> 
For the series

Acked-by: Neil Horman <nhorman@tuxdriver.com>

