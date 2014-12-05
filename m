Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaLESuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:50:21 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44426 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaLESuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:50:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141205095423.GB4963@mwanda>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFzyDC=o_Beg+8hjW8+TQXYWCgQo_yfjgHsTz0LRTiomWA@mail.gmail.com>
	<547620E6.10306@oracle.com>
	<CA+55aFyiCg23eL=y0nE8a-6_tBAtB097J8v_BtpUcHU8sc3hyQ@mail.gmail.com>
	<20141127204257.GA11014@mwanda>
	<20141205095423.GB4963@mwanda>
Date: Fri, 5 Dec 2014 10:50:19 -0800
X-Google-Sender-Auth: ZgR7INhRF2pFP4iiIg3TeTp6F_M
Message-ID: <CA+55aFxs=mF9vEMh1JN=UpF4UZ9-ojiN==PW8PJNWQ6D18NWFg@mail.gmail.com>
Subject: Re: [RFC 1/2] compiler: use compiler to detect integer overflows
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 1:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> There are some false positives which do:
>
>         if ((u16)(u16_foo + u16_bar) < u16_foo) {

Actually, the worse false positive is the ones that are pointer comparisons.

A compiler that does those as signed is just broken. It's happened,
but it's *still* completely broken.

                  Linus
