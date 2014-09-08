Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaIHMPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:15:40 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:34016 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbaIHMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:15:37 -0400
Message-ID: <540D9DC5.8010101@vmware.com>
Date: Mon, 8 Sep 2014 14:15:01 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Emil Velikov <emil.l.velikov@gmail.com>
CC: Josh Boyer <jwboyer@fedoraproject.org>, Brian Paul <brianp@vmware.com>,
        David Airlie <airlied@linux.ie>, <dmarlin@redhat.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm/vmwgfx: Fix drm.h include
References: <20140905171959.GO5216@hansolo.jdub.homelinux.org> <540D9A9B.6070706@gmail.com>
In-Reply-To: <540D9A9B.6070706@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.246]
X-ClientProxiedBy: EX13-CAS-013.vmware.com (10.113.191.65) To
 EX13-MBX-024.vmware.com (10.113.191.44)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 09/08/2014 02:01 PM, Emil Velikov wrote:
> Hi Josh
>
> On 05/09/14 18:19, Josh Boyer wrote:
>> The userspace drm.h include doesn't prefix the drm directory.  This can lead
>> to compile failures as /usr/include/drm/ isn't in the standard gcc include
>> paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
>> header files that get installed into /usr/include/drm.
>>
> Is this an actual issue or a hypothetical one ? Afaict no-one is using the
> kernel drm headers, but instead the ones from libdrm are in place.
> linux-headers does not even ship /usr/include/drm on my Archlinux box.
>
> Additionally most (all?) vmwgfx components (mesa, ddx) use a local version of
> the header, which albeit not ideal should not cause issues.
>
> Or perhaps I'm missing something ?
>
>
> To the VMware guys,
>
> Any objections if we update the libdrm header and drop the mesa/ddx copies ?
>
> Cheers,
> Emil
Hi!

vmwgfx libdrm is pretty obsolete and AFAIK not used by anyone.
As such, it's unnecessary to release a new version of libdrm each time
the vmwgfx header is updated, and I'd like to avoid that dependency.
Better to keep the local copies in the gallium winsys and the DDX. Since
the ioctl interface is backwards compatible, it doesn't really matter if
the headers are slightly out of sync.

/Thomas






>
> P.S. I'm against the patch in any way :)
>
>> Red Hat Bugzilla: https://urldefense.proofpoint.com/v1/url?u=https://bugzilla.redhat.com/show_bug.cgi?id%3D1138759&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=YR9QcTDSKJ%2BRxDHr%2BlEBv%2Fo37iPucyP5QKdoQnUPjcU%3D%0A&s=c8f9a09bb72428883d57b5ba757295a82326cfc0cac094c56c7754836054ae13
>>
>> Fixes: 1d7a5cbf8f74e
>> Reported-by: Jeffrey Bastian <jbastian@redhat.com>
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>> ---
>>  include/uapi/drm/vmwgfx_drm.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/drm/vmwgfx_drm.h b/include/uapi/drm/vmwgfx_drm.h
>> index 4fc66f6b12ce..c472bedbe38e 100644
>> --- a/include/uapi/drm/vmwgfx_drm.h
>> +++ b/include/uapi/drm/vmwgfx_drm.h
>> @@ -29,7 +29,7 @@
>>  #define __VMWGFX_DRM_H__
>>  
>>  #ifndef __KERNEL__
>> -#include <drm.h>
>> +#include <drm/drm.h>
>>  #endif
>>  
>>  #define DRM_VMW_MAX_SURFACE_FACES 6
>>

