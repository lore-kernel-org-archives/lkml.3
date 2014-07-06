Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaGFLTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 07:19:48 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:33591 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGFLTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 07:19:47 -0400
Date: Sun, 6 Jul 2014 12:19:46 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jonas Gorski <jogo@openwrt.org>
cc: Emil Goode <emilgoode@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Crispin <blogic@openwrt.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] MIPS: Remove incorrect NULL check in
 local_flush_tlb_page()
In-Reply-To: <CAOiHx==kyY9ce5jjv5m36OXpG9Vk4NsPa9m+nfWuYWjxOnMisA@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1407061218090.15455@eddie.linux-mips.org>
References: <1404602638-16447-1-git-send-email-emilgoode@gmail.com> <CAOiHx==kyY9ce5jjv5m36OXpG9Vk4NsPa9m+nfWuYWjxOnMisA@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2014, Jonas Gorski wrote:

> On Sun, Jul 6, 2014 at 1:23 AM, Emil Goode <emilgoode@gmail.com> wrote:
> > We check that the struct vm_area_struct pointer vma is NULL and then
> > dereference it a few lines below. The intent was to make sure vma is
> > not NULL but this is not necessary since the bug pre-dates GIT history
> > and seem to never have caused a problem. The tlb-4k and tlb-8k versions
> > of local_flush_tlb_page() don't bother checking if vma is NULL, also
> > vma is dereferenced before being passed to local_flush_tlb_page(),
> > thus it is safe to remove this NULL check.
> >
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> 
> Looks good.
> 
> Reviewed-by: Jonas Gorski <jogo@openwrt.org>

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

(as per the observations at the previous version).

  Maciej
