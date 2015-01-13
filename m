Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbbAMQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:05:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbbAMQFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:05:18 -0500
Date: Tue, 13 Jan 2015 18:05:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 23/40] tile: enable sparse checks for get/put_user
Message-ID: <20150113160504.GA19487@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-24-git-send-email-mst@redhat.com>
 <54B46204.1010003@ezchip.com>
 <20150113094554.GB4434@redhat.com>
 <54B53FEE.2090903@ezchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B53FEE.2090903@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:55:26AM -0500, Chris Metcalf wrote:
> On 1/13/2015 4:45 AM, Michael S. Tsirkin wrote:
> >On Mon, Jan 12, 2015 at 07:08:36PM -0500, Chris Metcalf wrote:
> >>The key changes are to copy the x86 definition of __inttype(), and then to
> >>arrange to use an intermediate integral type that gets assigned to or from
> >>the actual typed value so as to expose any sparse issues.
> >>
> >>If this works for you, I'm happy to queue it in the tile tree, or I can
> >>provide a proper git commit for you to include in your series, whichever
> >>works better for you.
> >Please queue it up for 3.20. Extra __force is needed in a couple of
> >places - would you like to fix this up yourself, or do you want me to
> >write a patch on top?
> 
> I'll fold in your suggestions to my patch.
> 
> >>@@ -178,7 +178,7 @@ extern int fixup_exception(struct pt_regs *regs);
> >>                              "9:"                                       \
> >>                              : "=r" (ret), "=r" (__a), "=&r" (__b)      \
> >>                              : "r" (ptr), "i" (-EFAULT));               \
> >>-               (x) = (__typeof(x))(__typeof((x)-(x)))                  \
> >>+               (x) = (__typeof(x))(__inttype(x))                       \
> >>                         (((u64)__hi32(__a, __b) << 32) |                \
> >>                          __lo32(__a, __b));                             \
> >>         })
> >This cast to __typeof(x) needs to be done with __force, otherwise
> >there will be a warning with bitwise types.
> 
> Actually, this place no longer needs any casting at all, on reflection.
> I've changed the __get_user() code to do the "get" into an __inttype
> uniformly, so __get_user_8 will always have a u64 type for "x" here.
> 
> I'll cc you on the updated patch, so if you'd like to add your
> Reviewed-by tag to it, let me know.

Sure.

> -- 
> Chris Metcalf, EZChip Semiconductor
> http://www.ezchip.com
