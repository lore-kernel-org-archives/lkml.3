Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3KMF0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:26:06 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:64975 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3KMF0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:26:02 -0500
Message-ID: <52830D61.5040806@synopsys.com>
Date: Wed, 13 Nov 2013 10:55:53 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/17] <asm/sections.h> related cleanups
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 01:12 AM, Geert Uytterhoeven wrote:
> Most of this has been compile-tested. Notable exceptions are the changes
> to arc, c6x, and score code, due to lack of cross-compilers.

Mainline buildroot will enable you to build a cross compiler for ARC. It is not
relocatable (pending issue in Buildroot itself) but should suffice your needs.

Then a defconfig kernel build will be good enough (allmodconfig tends to select a
uncommon configuration - e.g. Big endian, -Os and since the default tools are not
multilib'ed, it will fail to link.

To avoid fiailure all*config builds I probably need to invert a few config items
on ARC (CONFIG_CPU_BIG_ENDIAN => CONFIG_CPU_LITTLE_ENDIAN)
