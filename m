Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaD3A5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:57:13 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50035 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaD3A5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:57:12 -0400
MIME-Version: 1.0
In-Reply-To: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
Date: Tue, 29 Apr 2014 17:57:11 -0700
X-Google-Sender-Auth: _3SORkMfAO1jAiddHcDMvX7J2_4
Message-ID: <CA+55aFwTKzSgt2fk8gYbA67hfEWV6_a18Dfhw2D9jzHzs2GSEg@mail.gmail.com>
Subject: Re: [PATCH] x86-64, espfix: Don't leak bits 31:16 of %esp returning
 to 16-bit stack
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Andrew Lutomriski <amluto@gmail.com>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 5:15 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> Linus, this is technically a (functionality) regression fix.  Will you
> want this for 3.15?

Too scary. If people complain, I think we should just replace the

        if (!ldt_info.seg_32bit) {

with something like

        if (!ldt_info.seg_32bit && !sysctl_allow_16bit_segments) {

and handle the regression that way.

Then, after way more testing, maybe we can backport the espfix thing.

            Linus
