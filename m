Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaDCBuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:50:25 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52871 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaDCBuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:50:24 -0400
Message-ID: <1396489816.2913.25.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index
 reflect the start/end section number
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nfont@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org
Date: Thu, 03 Apr 2014 09:50:16 +0800
In-Reply-To: <533C362E.1020605@intel.com>
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
	 <533C362E.1020605@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040301-3864-0000-0000-00000D4AD719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 09:09 -0700, Dave Hansen wrote:
> On 04/02/2014 01:56 AM, Li Zhong wrote:
> > I noticed the phys_index and end_phys_index under 
> > /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
> > (for the test machine, one memory block has 8 sections, that is 
> >  sections_per_block equals 8)
> > 
> > # cd /sys/devices/system/memory/memory100/
> > # cat phys_index end_phys_index 
> > 00000064
> > 00000064
> > 
> > Seems they should reflect the start/end section number respectively, which 
> > also matches what is said in Documentation/memory-hotplug.txt
> 
> This changes a user-visible interface.  Won't this break userspace?

Hi Dave, 

Hmm, I think so... Thank you for the reminder

Do you have some better ideas to fix this? Maybe we should leave the
code unchanged, just change the corresponding document (just it seems
that the end_phys_index will always be the same as phys_index)? And if
the section numbers are really needed, then we could create two new
files later, e.g. start_section_nr, end_section_nr? 

Thanks, 
Zhong
> 


