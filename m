Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaEWIVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:21:50 -0400
Received: from mail.phunq.net ([184.71.0.62]:41217 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaEWIVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:21:47 -0400
From: Daniel Phillips <daniel@phunq.net>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Dave Chinner <david@fromorbit.com>, <linux-fsdevel@vger.kernel.org>,
        <tux3@tux3.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Tux3 for review
Date: Fri, 23 May 2014 01:21:41 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <44e6c054-0c32-47e5-8c03-f04b3128bb5c@phunq.net>
In-Reply-To: <20140522095227.GA9176@gmail.com>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
 <20140522095227.GA9176@gmail.com>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dongsu,

On Thursday, May 22, 2014 2:52:27 AM PDT, Dongsu Park wrote:
> First of all, thank you for trying to merge it to mainline.
> Maybe I cannot say the code is clean enough, but basically
> the filesystem seems to work at least.

Thank you for confirming that. We test Tux3 extensively so we know it works 
pretty well (short of enospc handling) but independent confirmation carries 
more weight than anything we could say. Our standard disclaimer: Tux3 is 
for developers right now, not for users.

>> ...The files named "*_hack" were kept as close as
>> possible to the original core code to clarify exactly where core
>> needs to change in order to remove our workarounds. If you think we
>> should pretty up that code then we will happily do it. Or maybe we
>> can hammer out acceptable core patches right now, and include those
>  ...
>
> Looking up kallsyms is not only hacky, but also making the filesystem
> unable to be mounted at all, when CONFIG_KALLSYMS_ALL is not defined.
> I'll send out patches to fix that separately to tux3 mailing list.

Thank you for improving the hack. We are working on getting rid of that 
flusher hack completely. There is a patch under development to introduce a 
new super_operationss.writeback() operation that allows a filesystem to 
flush its own inodes instead of letting core do it. This will allow Tux3 to 
enforce its strong ordering semantics efficiently without needing to 
reimplement part of fs-writeback.c.

Regards,

Daniel
