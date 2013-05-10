Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3EJOYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:24:54 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:40819 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab3EJOYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:24:51 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 10:24:51 EDT
Date: Fri, 10 May 2013 18:15:27 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: =?utf-8?Q?Jean-Fran=C3=A7ois?= Dagenais <jeff.dagenais@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH V2] w1: ds2408: add magic sequence to disable P0 test
 mode
Message-ID: <20130510141526.GA6755@ioremap.net>
References: <1367930422-25972-2-git-send-email-jeff.dagenais@gmail.com>
 <1367935248-12118-1-git-send-email-jeff.dagenais@gmail.com>
 <20130509110333.f6ba3b4cc22e87c7adb30993@linux-foundation.org>
 <1A322F9E-F2A7-42E6-8C37-8A5C3F2E28FD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1A322F9E-F2A7-42E6-8C37-8A5C3F2E28FD@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 03:33:23PM -0400, Jean-François Dagenais (jeff.dagenais@gmail.com) wrote:
> To be honest, I didn't really thought about it that much, I just copy pasted that from Evgeniy Polyakov's hunk at drivers/w1/w1_io.c, function w1_reset_select_slave(struct w1_slave *sl) exept I changed the MATCH_ROM with magic 0x96 and appended magic 0x3C. I have tested it only on the available platform I have which is x86. I agree it looks dodgy. Do you have an alternative? You are certainly more familiar with the kernel's fancy bit and endian tools than I am. I'd be willing to test prior to sending V3.
> 
> 
> struct w1_reg_num
> {
> #if defined(__LITTLE_ENDIAN_BITFIELD)
> 	__u64	family:8,
> 		id:48,
> 		crc:8;
> #elif defined(__BIG_ENDIAN_BITFIELD)
> 	__u64	crc:8,
> 		id:48,
> 		family:8;
> #else
> #error "Please fix <asm/byteorder.h>"
> #endif
> };
> 
> On the wire, the family byte should be sent first, then the MSB of id, then the rest of id and finally the crc.
> 
> Perhaps Evgeniy can chime in here?

That's transform is only used to cast structure to uint64_t, nothing
fancy. In-memory structure should be ok because of above definition on
every endian.

-- 
	Evgeniy Polyakov
