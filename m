Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaAXOSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:18:24 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:63618 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaAXOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:18:22 -0500
Date: Fri, 24 Jan 2014 08:15:30 -0600
From: Andrew Ruder <andy@aeruder.net>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sk == 0xffffffff fix - not for commit
Message-ID: <20140124141530.GC20804@gmail.com>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Nazarewicz <mina86@mina86.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
References: <1386589672-5830-1-git-send-email-andrzej.p@samsung.com>
 <20140124133831.GB20804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124133831.GB20804@gmail.com>
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 07:38:31AM -0600, Andrew Ruder wrote:
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg574770.html
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854

Just a little further confirmation.  This appears in
__inet_lookup_established as the last four instructions before
returning.

   <+440>:       bl      <__rcu_read_unlock>
   <+444>:       sub     sp, r11, #40    ; 0x28
   <+448>:       ldr     r0, [r11, #-48] ; 0x30
   <+452>:       ldm     sp, {r4, r5, r6, r7, r8, r9, r10, r11, sp, pc}
