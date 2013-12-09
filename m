Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3LIU5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:57:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010Ab3LIU5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:57:22 -0500
Date: Mon, 9 Dec 2013 21:57:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
In-Reply-To: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, H.J. Lu wrote:

> Normally, a PIE executable has zero virtual address on the first PT_LOAD
> segment and kernel will load such executable at random address when
> randomization is enabled.  If randomization is disabled, kernel will load
> it at a fixed address.  But if a PIE executable has non-zero virtual
> address on the first PT_LOAD segment, kernel will load such executable
> at the non-zero virtual address when randomization is enabled. But when
> randomization is disabled, kernel ignores the non-zero virtual address
> at the non-zero virtual address when randomization is enabled. 

Hmm ... isn't actually this the thing that needs to be fixed instead? 

IOW, when randomization is enabled, is there a reason not to load on 
randomized address? (even if the first PT_LOAD segment has non-zero 
vaddr?)

> But when randomization is disabled, kernel ignores the non-zero virtual 
> address on the first PT_LOAD segment and loads it at the fixed address.  
> This patch makes kernel consistent by loading PIE executable with 
> non-zero virtual address at the non-zero virtual address, regardless if 
> randomization is enabled or disabled.

-- 
Jiri Kosina
SUSE Labs
