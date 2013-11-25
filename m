Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3KYKRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:17:06 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53781 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab3KYKRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:17:01 -0500
Message-ID: <1385374617.2354.22.camel@dabdike>
Subject: Re: [PATCH 0024] asm-generic: Rename int-ll64.h to types.h
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 25 Nov 2013 14:16:57 +0400
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 09:55 +0100, Geert Uytterhoeven wrote:
> This patchset aims to rename <asm-generic/int-ll64.h> to
> <asm-generic/types.h> in kernelspace, as suggested by Arnd.
> 
> While userspace still has both include/uapi/asm-generic/int-l64.h and
> include/uapi/asm-generic/int-ll64.h (int-l64.h may still be used on legacy
> 64-bit systems), kernelspace always uses "(unsigned) long long" for 64-bit
> integer values ("u64" and "s64").  Hence there's no longer a need to
> distinguish between int-l64 and int-ll64 in kernelspace, and int-ll64.h can
> just be called types.h

Is this a good idea?  I thought some versions of gcc used long long for
128 bit integers, in which case int-ll64.h will give the wrong types for
u64 and s64.  I think gcc is changing to use the __int128 type, so this
may be historical, but someone would need to validate that we have no
architectures with the old long long behaviour.

James


