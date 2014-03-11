Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaCKREf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:04:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaCKREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:04:33 -0400
Message-ID: <531F421F.3010402@infradead.org>
Date: Tue, 11 Mar 2014 10:04:31 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Holger Waechtler <holger@convergence.de>,
        Oliver Endriss <o.endriss@gmx.de>
Subject: Re: mmotm 2014-03-10-15-35 uploaded (media/pci/ttpci/av7110)
References: <20140310223701.0969C31C2AA@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20140310223701.0969C31C2AA@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 03:37 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-03-10-15-35 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (3.x
> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
> 
> The file broken-out.tar.gz contains two datestamp files: .DATE and
> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> followed by the base kernel version against which this patch series is to
> be applied.
> 
> This tree is partially included in linux-next.  To see which patches are
> included in linux-next, consult the `series' file.  Only the patches
> within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
> linux-next.
> 

on i386:
(not from mmotm patches, so must be from linux-next or mainline)

CONFIG_INPUT=m
CONFIG_INPUT_EVDEV=m
CONFIG_DVB_AV7110=y


drivers/built-in.o: In function `input_sync':
av7110_ir.c:(.text+0x14b999): undefined reference to `input_event'
drivers/built-in.o: In function `av7110_emit_key':
av7110_ir.c:(.text+0x14ba4b): undefined reference to `input_event'
av7110_ir.c:(.text+0x14ba63): undefined reference to `input_event'
av7110_ir.c:(.text+0x14bb20): undefined reference to `input_event'
av7110_ir.c:(.text+0x14bb35): undefined reference to `input_event'
drivers/built-in.o:av7110_ir.c:(.text+0x14bb76): more undefined references to `input_event' follow
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x14bec7): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x14bf95): undefined reference to `input_register_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x14bfa5): undefined reference to `input_free_device'
drivers/built-in.o: In function `av7110_ir_exit':
(.text+0x14c0ad): undefined reference to `input_unregister_device'


Possibly just make DVB_AV7110 depend on INPUT.

-- 
~Randy
