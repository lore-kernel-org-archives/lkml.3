Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaDKWGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:06:08 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36112 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaDKWGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <53485B63.1030305@vmware.com>
References: <5347E32B.1080002@vmware.com>
	<CANq1E4Rr5XDR3+WLRHSw6aYw6uDq90JJZOhmUKDJj=kFGcvJ8g@mail.gmail.com>
	<53485B63.1030305@vmware.com>
Date: Fri, 11 Apr 2014 18:05:59 -0400
Message-ID: <CAF6AEGtRf3kFoOuJWQVtRPi7ONkTh09+42Cb9h0fGsGOk9CjJw@mail.gmail.com>
Subject: Re: DRM security flaws and security levels.
From: Rob Clark <robdclark@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 5:15 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> On 04/11/2014 10:31 PM, David Herrmann wrote:
>> Hi
>>
>> On Fri, Apr 11, 2014 at 2:42 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>>> as was discussed a while ago, there are some serious security flaws with
>>> the current drm master model, that allows a
>>> user that had previous access or current access to an X server terminal
>>> to access the GPU memory of the active X server, without being
>>> authenticated to the X server and thereby also access other user's
>>> secret information
>> 1a) and 1b) are moot if you disallow primary-node access but require
>> clients to use render-nodes with dma-buf. There're no gem-names on
>> render-nodes so no way to access other buffers (assuming the GPU does
>> command-stream checking and/or VM).
>
> Disallowing primary node access will break older user-space drivers and
> non-root
> EGL clients. I'm not sure that's OK, even if the change is done from
> user-space.
> A simple gem fix would also do the trick.
>
>>
>> 2) There is no DRM-generic data other than buffers that is global. So
>> imho this is a driver-specific issue.
>>
>> So I cannot see why this is a DRM issue. The only leaks I see are
>> legacy interfaces and driver-specific interfaces. The first can be
>> disabled via chmod() for clients, and the second is something driver
>> authors should fix.
>
> Yeah, but some driver authors can't or won't fix the drivers w r t this,
> hence the security levels.

fwiw, I do think we want security level reporting for drivers that
don't have per-process pagetables (either the hw doesn't support, or
simply just not implemented yet) to avoid giving a false sense of
security with rendernodes.  It might be useful to even be able to
request a security level.. ie. some hw might be able to support
process isolation of gpu buffers, but at a performance penalty..  Joe
Gamer might be ok with the tradeoff in return for moar fps.  Ideally
you could request on a per process basis (via some sort of egl/glx
extension) to firewall off, say, your online banking session.

note, sencario 1a is, I think, only an issue for shared buffers (ie.
ones that have an flink name).. so, ok, another process can see the
video game you were playing.  Ok, that is not quite true, since
browsers use gpu accel (but maybe they want to decide to
enable/disable that, at least for certain sites (like your online
banking) based on the max-security-level of the driver).  And gl
compositing window managers.

I doubt any of that is worse than any closed src gpu driver.  But
either way, for really classified/sensitive material you might want to
think about a computer with no gpu.  I wouldn't be surprised if the
NSA knew as much or more about these gpu's as we do.

BR,
-R

> Thanks,
> /Thomas
>
>
>>
>> Thanks
>> David
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
