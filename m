Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3JKMSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab3JKMSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:18:44 -0400
Message-ID: <1381493921.8305.63.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: add PAGE_ALIGNED_DATA to linker script
From: Mark Salter <msalter@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Date: Fri, 11 Oct 2013 08:18:41 -0400
In-Reply-To: <20131009101447.GC5985@mudshark.cambridge.arm.com>
References: <1381264659-11132-1-git-send-email-msalter@redhat.com>
	 <20131009101447.GC5985@mudshark.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 11:14 +0100, Will Deacon wrote:
> > @@ -110,6 +110,7 @@ SECTIONS
> >                */
> >               INIT_TASK_DATA(THREAD_SIZE)
> >               NOSAVE_DATA
> > +             PAGE_ALIGNED_DATA(PAGE_SIZE)
> >               CACHELINE_ALIGNED_DATA(64)
> >               READ_MOSTLY_DATA(64)
> 
> Can we just replace this chunk with RW_DATA_SECTION(64, PAGE_SIZE,
> THREAD_SIZE) instead?
> 

I took a look at this. It can be done, but the RW_DATA_SECTION aligns
data to PAGE_SIZE where the existing alignment is THREAD_SIZE. So using
RW_DATA_SECTION would waste some space if using 64K pagesize.

--Mark


