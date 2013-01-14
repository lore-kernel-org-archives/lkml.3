Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab3ANWe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:34:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab3ANWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:34:58 -0500
Date: Mon, 14 Jan 2013 14:34:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, jiang.liu@huawei.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
Message-Id: <20130114143456.3962f3bd.akpm@linux-foundation.org>
In-Reply-To: <50F440F5.3030006@zytor.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
	<50F440F5.3030006@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 09:31:33 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 01/14/2013 01:15 AM, Tang Chen wrote:
> >
> > For now, users can disable this functionality by not specifying the boot option.
> > Later, we will post SRAT support, and add another option value "movablecore_map=acpi"
> > to using SRAT.
> >
> 
> I still think the option "movablecore_map" is uglier than hell.  "core" 
> could just as easily refer to CPU cores there, but it is a memory mem. 
> "movablemem" seems more appropriate.
> 
> Again, without SRAT I consider this patchset to be largely useless for 
> anything other than prototyping work.
> 

hm, why.  Obviously SRAT support will improve things, but is it
actually unusable/unuseful with the command line configuration?

Also, "But even if we can use SRAT, users still need an interface to
enable/disable this functionality if they don't want to loose their
NUMA performance.  So I think, an user interface is always needed."


There's also the matter of other architectures.  Has any thought been
given to how (eg) powerpc would hook into here?

And what about VMs (xen, KVM)?  I wonder if there is a case for those
to implement memory hotplug.  
