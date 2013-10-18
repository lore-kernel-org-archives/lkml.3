Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab3JRXDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:03:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3JRXDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:03:24 -0400
Date: Fri, 18 Oct 2013 15:57:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
Message-ID: <20131018225702.GA13090@kroah.com>
References: <1381296747.2040.17.camel@joe-AO722>
 <20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
 <CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
 <CAGa+x86aS+C8iEb1P4ZYxPBix=Anjh4JZoAof=R-i9fGw=bq6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGa+x86aS+C8iEb1P4ZYxPBix=Anjh4JZoAof=R-i9fGw=bq6w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:04:11AM -0700, Kevin Hilman wrote:
> > A handful of boot panics on ARM platforms were bisected to point at
> > the version of this commit that's in linux-next (commit
> > 64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
> > makes things happy again.
> >
> > Upon further digging, it seems that users of devres_alloc() are
> > relying on the previous behavior of having the memory zero'd which is
> > no longer the case after $SUBJECT patch.  The change below on top of
> > -next makes these ARM boards happy again.
> 
> Oops, it should've fixed __devres_alloc() also.  Updated patch below.

Can you send this in a format that I can apply it in?  It was whitespace
damaged.

thanks,

greg k-h
