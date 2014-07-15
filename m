Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbaGOLMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:12:47 -0400
Received: from sym2.noone.org ([178.63.92.236]:37003 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039AbaGOLMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:12:44 -0400
Date: Tue, 15 Jul 2014 13:12:37 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v2 24/29] nios2: Module support
Message-ID: <20140715111237.GF7668@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <1405413956-2772-25-git-send-email-lftan@altera.com>
 <6364841.e2Acy30lOs@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6364841.e2Acy30lOs@wuerfel>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 at 12:24:46 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 July 2014 16:45:51 Ley Foon Tan wrote:
> > +void *module_alloc(unsigned long size)
> > +{
> > +	if (size == 0)
> > +		return NULL;
> > +	return kmalloc(size, GFP_KERNEL);
> > +}
> > +
> > +/* Free memory returned from module_alloc */
> > +void module_free(struct module *mod, void *module_region)
> > +{
> > +	kfree(module_region);
> > +}
> 
> Any particular reason for defining these to use kmalloc rather than
> the default vmalloc based functions?

AFAIR this is due to relocation issues, as the FIXME comment in the
"original" code [1] states. I don't know whether this still applies,
though (or what would be the proper fix for this to overcome the
relocation issues).

[1] https://github.com/tklauser/linux-nios2/blob/nios2/arch/nios2/kernel/module.c#L45

Cheers
Tobias
