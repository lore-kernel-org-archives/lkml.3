Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaAVSYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:24:11 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62946 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAVSYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:24:07 -0500
MIME-Version: 1.0
In-Reply-To: <52E008F0.3060602@redhat.com>
References: <20140121232708.GA29787@amazon.com>
	<20140122014908.GG18164@kroah.com>
	<CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
	<52E008F0.3060602@redhat.com>
Date: Wed, 22 Jan 2014 10:24:06 -0800
X-Google-Sender-Auth: NRMmZS28ntsWXPBhZEoF6YKjA_o
Message-ID: <CA+55aFypCEec_15J-bPAuc1G=GtnQXjnnW5+dzwODq2DNW4Bsg@mail.gmail.com>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Steven Noonan <steven@uplinklabs.net>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:07 AM, Rik van Riel <riel@redhat.com> wrote:
>
> The difference between a numa pte and a protnone pte is
> the VMA permissions.

If that is indeed the only difference, then we should damn well get
rid of that f*cking stupid _PAGE_NUMA name entirely.

It's misleading crap. Really. Just do a quick grep for that bit, and
you see just *how* confused people are about it:

   #define _PAGE_NUMA _PAGE_PROTNONE
   ...
        if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &

think about it. Just *THINK* about how broken that code is. The whole
thing is a disaster. _PAGE_NUMA must die. It's shit.

                 Linus
