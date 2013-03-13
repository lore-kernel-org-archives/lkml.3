Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3CMLk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:40:58 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:58100 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3CMLk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:40:57 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Mar 2013 07:40:56 EDT
Date: Wed, 13 Mar 2013 13:30:45 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Florian Fainelli <florian@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] decompressors: fix typo "POWERPC"
Message-ID: <20130313133045.51d44a63@tukaani.org>
In-Reply-To: <1363044544.3137.120.camel@x61.thuisdomein>
References: <1363044544.3137.120.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-12 Paul Bolle wrote:
> Commit 5dc49c75a26b99e86a18441e0b64c1f7c7c6a500 ("decompressors: make
> the default XZ_DEC_* config match the selected architecture") added
> 	default y if POWERPC
> 
> to lib/xz/Kconfig. But there is no Kconfig symbol POWERPC. The most
> general Kconfig symbol for the powerpc architecture is PPC. So let's
> use that.

Thanks.

> 1) By the way: why does the XZ related code use both the macro
> CONFIG_XZ_DEC_POWERPC and the macro XZ_DEC_POWERPC? (Ditto for other
> architectures.) That looks odd.

In a preboot environment the options selected for the xz_dec module are
ignored. If XZ-compressed kernel is selected, lib/decompress_unxz.c
will enable a BCJ filter for that architecture. An alternative could be
to #undef the CONFIG_XZ_DEC_foo symbols in decompress_unxz.c and then
#define what is needed for the selected architecture, but I think the
current method is OK. See also lib/xz/xz_private.h.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
