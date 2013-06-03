Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3FCUgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:36:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab3FCUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:35:59 -0400
Message-ID: <51ACFDF2.4040600@infradead.org>
Date: Mon, 03 Jun 2013 13:34:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>, linux-fbdev@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 3 (fonts.c & vivi)
References: <20130603163717.a6f78476e57d92fadd6f6a23@canb.auug.org.au>
In-Reply-To: <20130603163717.a6f78476e57d92fadd6f6a23@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/13 23:37, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130531:
> 


on x86_64:

warning: (VIDEO_VIVI && USB_SISUSBVGA && SOLO6X10) selects FONT_SUPPORT which has unmet direct dependencies (HAS_IOMEM && VT)
warning: (VIDEO_VIVI && FB_VGA16 && FB_S3 && FB_VT8623 && FB_ARK && USB_SISUSBVGA_CON && SOLO6X10) selects FONT_8x16 which has unmet direct dependencies (HAS_IOMEM && VT && FONT_SUPPORT)


drivers/built-in.o: In function `vivi_init':
vivi.c:(.init.text+0x1a3da): undefined reference to `find_font'

when CONFIG_VT is not enabled.

Just make CONFIG_VIDEO_VIVI depend on VT ?


-- 
~Randy
