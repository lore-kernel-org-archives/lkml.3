Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3JaK55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:57:57 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:39185 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3JaK5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:57:55 -0400
Date: Thu, 31 Oct 2013 14:57:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/6] procfs: Introduce sequential fdinfo engine
Message-ID: <20131031105752.GB24809@moon>
References: <20131030195951.201688764@openvz.org>
 <20131030202221.047149911@openvz.org>
 <CACVxJT8vuh+Jm1LYhiQBLvi6TASpGgKm0CCqVS=g3QE+eHK7Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVxJT8vuh+Jm1LYhiQBLvi6TASpGgKm0CCqVS=g3QE+eHK7Wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 01:32:13PM +0300, Alexey Dobriyan wrote:
> On Wed, Oct 30, 2013 at 10:59 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > At moment the fdinfo operations (ie the output from /proc/$pid/fdinfo/$fd)
> > are generating output in one pass, which makes useless memory pressue
> > if the reader/user provides a buffer with a small size.
> 
> cat(1) uses 64 KB buffer.
> The output doesn't exceed one page anyway.

Yes, good point. I probably need to update changelog (forgot that i'm using
single_open here). What if we meet a file with that big number of epoll
or say notifies assigned that the fdinfo won't fit a page? I didn't meet
such scenario yet, but I think it's possible?
