Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbbAWA2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:28:40 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:32929 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbbAWA2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:28:39 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1501221523390.27807@chino.kir.corp.google.com>
References: <20150107172452.GA7922@node.dhcp.inet.fi>
	<20150114152225.GB31484@google.com>
	<20150114233630.GA14615@node.dhcp.inet.fi>
	<alpine.DEB.2.10.1501211452580.2716@chino.kir.corp.google.com>
	<CA+yH71fNZSYVf1G+UUp3N6BhPhT0VJ4aGY=uPGbSD2raV55E3Q@mail.gmail.com>
	<alpine.DEB.2.10.1501221523390.27807@chino.kir.corp.google.com>
Date: Fri, 23 Jan 2015 00:28:38 +0000
X-Google-Sender-Auth: ZlN7MLkjbdRvx6yilkfdAouOQ4o
Message-ID: <CA+yH71e2ewvA41BNyb=TTPn+yx2zWzY6rn09hRVVgWKoeMgwXQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
From: Primiano Tucci <primiano@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Petr Cermak <petrcermak@chromium.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:27 PM, David Rientjes <rientjes@google.com> wrote:
> If you reset the hwm for a process, rss grows to 100MB, another process
> resets the hwm, and you see a hwm of 2MB, that invalidates the hwm
> entirely.

Not sure I follow this scenario. Where does the 2MB come from? How can
you see a hwm of 2MB, under which conditions? HVM can never be < RSS.
Again, what you are talking about is the case of two profilers racing
for using the same interface (hwm).
This is the same case today of the PG_referenced bit.

> The hwm is already defined as the
> highest rss the process has attained, resetting it and trying to make any
> inference from the result is racy and invalidates the actual value which
> is useful.
The counter arugment is: once you have one very high peak, the hvm
becomes essentially useless for the rest of the lifetime of the
process (until a higher peak comes). This makes very hard to
understand what is going on in the meanwhile (from userspace).

Anyways, are you proposing to pursue a different approach? Is the
approach 2. that petrcermark@ proposed in the beginning of the thread
going to address this concern?
