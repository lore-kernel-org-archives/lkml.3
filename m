Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaB0IZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:25:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55966 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbaB0IZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:25:35 -0500
Date: Thu, 27 Feb 2014 09:25:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Ben Pfaff <blp@nicira.com>,
        Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
Message-ID: <20140227082529.GA18210@pd.tnic>
References: <530E6F76.1070605@zytor.com>
 <1393462087.24588.50.camel@joe-AO722>
 <530E8C2E.7080307@zytor.com>
 <1393466619.24588.65.camel@joe-AO722>
 <20140227022857.GC23659@thin>
 <1393469594.24588.71.camel@joe-AO722>
 <20140227025845.GA25145@thin>
 <530EB103.5070406@zytor.com>
 <1393472326.24588.82.camel@joe-AO722>
 <60797a1a-1a83-468e-9629-abf4e8712d65@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <60797a1a-1a83-468e-9629-abf4e8712d65@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 07:42:37PM -0800, H. Peter Anvin wrote:
> sizeof(_Bool), like for many other types, is ABI-dependent, but that
> doesn't mean it is illegitimate.
>
> I don't think C99 says that it is invalid (which means C99 doesn't
> permit is to be a packed bitmap.)

Ok, but what can be said about the __pcpu_size_call() use case where we
do sizeof(bool)? We have there accessors for sizes 1,2,4 and 8. Can we
simply assume that the ABI will give us a size of bool which is one of
those?

What if sizeof(bool) is 3?

Or, are we saying that sizeof(bool) will always be of some natural,
native size like byte, short, int or long so we're good there?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
