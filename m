Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3JNPqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:46:21 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56768 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3JNPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:46:19 -0400
MIME-Version: 1.0
In-Reply-To: <1420251.G1iR4tbUp8@tauon>
References: <2579337.FPgJGgHYdz@tauon>
	<3593500.a7fOuGKlEX@tauon>
	<CACXcFm=M2Jrra3tttWyhwfs-a6iVm0joiKi=wHKuANe_s_F-Sw@mail.gmail.com>
	<1420251.G1iR4tbUp8@tauon>
Date: Mon, 14 Oct 2013 11:46:18 -0400
Message-ID: <CACXcFm=OHeAwbJ6WNv4kxF-FOpvc7eep5n-xTg9bMMjcw41j+A@mail.gmail.com>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
From: Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 11:26 AM, Stephan Mueller <smueller@chronox.de> wrote:

>>Why not declare some 64-bit constant C with a significant
>
> Which constant would you take? The CRC twist values? The SHA-1 initial
> values? Or the first few from SHA-256?

The only essential requirement is that it not be something stupidly
regular like a 64-bit string 0x5555555555555555.

I'd pick an odd number so the low bit always changes, and a
constant with about half the bits set, maybe 24 < n < 40 or
some such. I'm not certain either of those is strictly required
but I'd do them anyway.
