Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaDKVPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:15:22 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:33859 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbaDKVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:15:21 -0400
Message-ID: <53485B63.1030305@vmware.com>
Date: Fri, 11 Apr 2014 23:15:15 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: DRM security flaws and security levels.
References: <5347E32B.1080002@vmware.com> <CANq1E4Rr5XDR3+WLRHSw6aYw6uDq90JJZOhmUKDJj=kFGcvJ8g@mail.gmail.com>
In-Reply-To: <CANq1E4Rr5XDR3+WLRHSw6aYw6uDq90JJZOhmUKDJj=kFGcvJ8g@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:31 PM, David Herrmann wrote:
> Hi
>
> On Fri, Apr 11, 2014 at 2:42 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>> as was discussed a while ago, there are some serious security flaws with
>> the current drm master model, that allows a
>> user that had previous access or current access to an X server terminal
>> to access the GPU memory of the active X server, without being
>> authenticated to the X server and thereby also access other user's
>> secret information
> 1a) and 1b) are moot if you disallow primary-node access but require
> clients to use render-nodes with dma-buf. There're no gem-names on
> render-nodes so no way to access other buffers (assuming the GPU does
> command-stream checking and/or VM).

Disallowing primary node access will break older user-space drivers and
non-root
EGL clients. I'm not sure that's OK, even if the change is done from
user-space.
A simple gem fix would also do the trick.

>
> 2) There is no DRM-generic data other than buffers that is global. So
> imho this is a driver-specific issue.
>
> So I cannot see why this is a DRM issue. The only leaks I see are
> legacy interfaces and driver-specific interfaces. The first can be
> disabled via chmod() for clients, and the second is something driver
> authors should fix.

Yeah, but some driver authors can't or won't fix the drivers w r t this,
hence the security levels.

Thanks,
/Thomas


>
> Thanks
> David
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
