Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaGIKMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:12:22 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:46929 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaGIKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:12:20 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
Date: Wed, 9 Jul 2014 12:12:15 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, xen-devel@lists.xenproject.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] mmap_vmcore: skip non-ram pages reported by
 hypervisors
Message-ID: <20140709101215.GA31182@aepfle.de>
References: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
 <20140708191159.GA17746@redhat.com>
 <87mwciooe7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87mwciooe7.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, Vitaly Kuznetsov wrote:

> > Also I am wondering why it was not done as part of copy_oldmem_page()
> > so that respective arch could hide all the details.
> Afaiac that wouldn't solve the mmap issue I'm trying to address but we
> can ask Olaf why he preferred pfn_is_ram() path.

Every copy_oldmem_page would need to know about the pfn_is_ram function,
so I think its better to keep that part of the code private to
fs/proc/vmcore.c

Perhaps pfn_is_ram could be named pfn_is_backed_by_ram, but the comments
make it clear what the function does.


Olaf
