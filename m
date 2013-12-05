Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3LEAA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:00:26 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:38382 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3LEAAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:00:23 -0500
Date: Wed, 4 Dec 2013 16:00:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sima Baymani <sima.baymani@gmail.com>
cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org, tangchen@cn.fujitsu.com,
        akpm@linux-foundation.org, linux-mm@kvack.org, aquini@redhat.com,
        linux-kernel@vger.kernel.org, gang.chen@asianux.com,
        aneesh.kumar@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        kirill.shutemov@linux.intel.com, sjenning@linux.vnet.ibm.com,
        darrick.wong@oracle.com
Subject: Re: linux-next: Tree for Dec 3 (mm/Kconfig)
In-Reply-To: <CAL8k4FwmVmCq8jPWNoRXKPtnSdRc3pwaMCE+AZoq_VoZphpR_A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312041558280.6329@chino.kir.corp.google.com>
References: <CAL8k4FwmVmCq8jPWNoRXKPtnSdRc3pwaMCE+AZoq_VoZphpR_A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Sima Baymani wrote:

> When generating randconfig, got following warning:
> 
> warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR
> which has unmet direct dependencies (PROC_FS && MMU)
> 
> I would have liked to form a patch for it, but not sure whether to
> simply add PROC_FS && MMU as dependencies for HWPOISON_INJECT and
> MEM_SOFT_DIRTY, or if some other fix would be more suitable?
> 

CONFIG_HWPOISON_INJECT is unrelated, it already depends on CONFIG_PROC_FS.

CONFIG_PROC_PAGE_MONITOR is obviously only useful for CONFIG_PROC_FS, so 
the correct fix would be to make CONFIG_MEM_SOFT_DIRTY depend on 
CONFIG_PROC_FS.

Want to try sending a patch?
