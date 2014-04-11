Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaDKUbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:31:05 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60988 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDKUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:31:02 -0400
MIME-Version: 1.0
In-Reply-To: <5347E32B.1080002@vmware.com>
References: <5347E32B.1080002@vmware.com>
Date: Fri, 11 Apr 2014 22:31:01 +0200
Message-ID: <CANq1E4Rr5XDR3+WLRHSw6aYw6uDq90JJZOhmUKDJj=kFGcvJ8g@mail.gmail.com>
Subject: Re: DRM security flaws and security levels.
From: David Herrmann <dh.herrmann@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Apr 11, 2014 at 2:42 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> as was discussed a while ago, there are some serious security flaws with
> the current drm master model, that allows a
> user that had previous access or current access to an X server terminal
> to access the GPU memory of the active X server, without being
> authenticated to the X server and thereby also access other user's
> secret information

1a) and 1b) are moot if you disallow primary-node access but require
clients to use render-nodes with dma-buf. There're no gem-names on
render-nodes so no way to access other buffers (assuming the GPU does
command-stream checking and/or VM).

2) There is no DRM-generic data other than buffers that is global. So
imho this is a driver-specific issue.

So I cannot see why this is a DRM issue. The only leaks I see are
legacy interfaces and driver-specific interfaces. The first can be
disabled via chmod() for clients, and the second is something driver
authors should fix.

Thanks
David
