Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab3GQAFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:05:15 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49197 "HELO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755248Ab3GQAFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:05:10 -0400
Date: Wed, 17 Jul 2013 12:03:47 +1200
From: Michael Cree <cree@waikato.ac.nz>
To: Rob Landley <rob@landley.net>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 0/7] Minor Alpha updates for 3.11
Message-ID: <20130717000347.GB2483@stolen.phys.waikato.ac.nz>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
 <1374017707.3719.11@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374017707.3719.11@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 06:35:07PM -0500, Rob Landley wrote:
> On 07/16/2013 12:04:33 PM, Richard Henderson wrote:
> >Here's a set of minor updates for arch/alpha that should not
> >be controversial.
> 
> I also note that I had to do this to get busybox to build against
> uClibc:
> -#define __NR_umount		 22
> +#define __NR_umount2		 22
> -#define __NR_oldumount		321
> +#define __NR_umount		321

I anticipate that this will likely break userspace.

busybox should be fixed to test for __NR_oldumount and then call the
correct functions, namely oldumount and umount if __NR_oldumount is defined
and umount and umount2 if it is not defined.

Cheers
Michael.
