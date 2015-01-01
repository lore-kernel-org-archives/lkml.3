Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbbAAVSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:18:52 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58739 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbbAAVSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:18:51 -0500
X-Sasl-enc: +io9DIsl/SgejxnZe0DBv5a8E25ZWkDEpy/6/q1mNszh 1420147130
Message-ID: <54A5B9BB.7050107@imap.cc>
Date: Thu, 01 Jan 2015 22:18:51 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, hjlipp@web.de
CC: isdn@linux-pingi.de, gigaset307x-common@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:isdn: Remove uneeded fix me comment in capi.c
 for the function,decode_ie
References: <1420053714-24661-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1420053714-24661-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Nicholas,

Am 31.12.2014 um 20:21 schrieb Nicholas Krause:
> Removes a no longer needed fix me comment for the
> function,decode_ie in the file, capi.c. This comment is no longer
> needed as the commit this was written in was 2009 when the new
> driver,three was introduced. Due to no breakage related to the 
> newer version of this driver we can safely remove this comment.

I won't oppose removal of that comment. However your commit message is
not quite to the point.

The comment poses the question of whether the conversion to upper case
done by the toupper() calls in the two lines following is actually
necessary. The fact that there is no breakage with the current code
does not answer that question. It could only be answered by *removing*
the toupper() calls and *then* checking for breakage.

However the cost of two toupper() calls seems so small that it's
hardly worth the effort and risk and we should just leave them in.

Regards,
Tilman

> diff --git a/drivers/isdn/gigaset/capi.c
> b/drivers/isdn/gigaset/capi.c index ccec777..d55ba3f 100644 ---
> a/drivers/isdn/gigaset/capi.c +++ b/drivers/isdn/gigaset/capi.c @@
> -182,7 +182,6 @@ static void decode_ie(u8 *in, char *out) { int i =
> *in; while (i-- > 0) { -		/* ToDo: conversion to upper case
> necessary? */ *out++ = toupper(hex_asc_hi(*++in)); *out++ =
> toupper(hex_asc_lo(*in)); }
> 

- -- 
Tilman Schmidt                              E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUpbm7AAoJEFPuqx0v+F+qxFcH/1F6l/1ycTikNdwfsHesZW6Q
TXDO7YfguLDe+wyePEvHdBFW+AwEgGFWTz2EEqfpdu/dHwmWjZh8yTLkJEMfn4fz
jBDm2Kyw+uFzUSXPVCyMUNXgC7yATs6l2AEkX5FSr0BycUVyMIeemChB4Pf5DfQD
B1Lz86xKhM3HpdI/KIDXqqHK88mT/B+7+rUL6lyJ6GRU/168EetD5PzjXoQ67DUw
JaSpCTjf1nUQAL1Nw623QVT4le/vPXLhwpIIAhLmvwO3nn8XWx4WdiCGVm6bGgrV
coWwo8LRB/IMCwoZGh2RhmDy2nOYwj1k9NYLjrx+izhbQUSpwqoLUCZe6vhBTks=
=Ppmw
-----END PGP SIGNATURE-----
