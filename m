Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaIPVko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:40:44 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49406 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaIPVkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:40:42 -0400
Date: Tue, 16 Sep 2014 23:40:37 +0200
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 10/13] eeepc-laptop: compare proper return values in
 get_cpufv
Message-ID: <20140916214037.GB23674@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-11-git-send-email-fransklaver@gmail.com>
 <20140915214902.GB64909@vmdeb7>
 <20140915215125.GA21435@kroah.com>
 <20140915215527.GC7867@gmail.com>
 <CAH6sp9N1y3=LLju85ZHgc05ENUYLgUdYBYpemc6_oNhbsZ+r6g@mail.gmail.com>
 <20140916205247.GA6856@vmdeb7>
 <20140916212715.GB6856@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140916212715.GB6856@vmdeb7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 02:27:15PM -0700, Darren Hart wrote:
> 
> - When reading and writing sysfs device attribute files, avoid dependency
>   on specific error codes wherever possible. This minimizes coupling to
>   the error handling implemementation within the kernel.
> 
>   In general, failures to read or write sysfs device attributes shall
>   propogate errors wherever possible. Common errors include, but are not
>   limited to:
> 
>   -EIO: The read or store operation is not supported, typically returned by
>         the sysfs system itself if the read or store pointer is NULL.
> 
>   -ENXIO: The read or store operation failed
> 
>   Error codes will not be changed without good reason, and should a change
>   to error codes result in user-space breakage, it will be fixed, or the
>   the offending change will be reverted.

sysfs-rules.txt is written for user space? In that case, reverting the
change is as much a fix as patching it.

> 
>   Userspace applications can, however, expect the format and contents of
>   the attribute files to remain consistent in the absence of a version
>   attribute change in the context of a given attributes.

...attribute.

That's it for the nit-picking.

Frans
