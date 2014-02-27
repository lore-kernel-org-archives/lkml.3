Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaB0QLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:11:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28601 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaB0QLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:11:51 -0500
Date: Thu, 27 Feb 2014 19:10:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
        Joe Perches <joe@perches.com>, Ben Pfaff <blp@nicira.com>,
        Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
Message-ID: <20140227161004.GT26722@mwanda>
References: <20140227022857.GC23659@thin>
 <1393469594.24588.71.camel@joe-AO722>
 <20140227025845.GA25145@thin>
 <530EB103.5070406@zytor.com>
 <1393472326.24588.82.camel@joe-AO722>
 <60797a1a-1a83-468e-9629-abf4e8712d65@email.android.com>
 <20140227082529.GA18210@pd.tnic>
 <dbc47544-a6f6-4ab4-80b0-25d93a1666e2@email.android.com>
 <20140227152435.GA7982@thunk.org>
 <530F5E53.5070208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F5E53.5070208@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 07:48:35AM -0800, H. Peter Anvin wrote:
> > Do we have a fairly comprehensive list of what these extrastandard
> > requirements / assumptions are?  It might be a good idea to have one
> > that we can point to, so that (a) people who are trying to define a
> > new architecture knows what they need to handle, (b) and so we can
> > give a list of things that static code analyzers like smatch and
> > coverity and sparse should be able to suppress (perhaps in a Linux
> > kernel-only mode).
> > 
> 
> No, but I think we can certainly make a list... a lot of it right now
> sits in various people's heads.
> 
> Here are a couple:
> 
> - Bytes are 8 bits
> - Signed integers will be 2's complement
> - sizeof char, short, int, long, and long long will be 1, 2, 4, 4, 8 or
>   1, 2, 4, 8, 8 on 32- and 64-bit processors, respectively.
> - sizeof(long) == sizeof(void *)
> - NULL is represented by all zero
> - Structures will not add padding as long as all the members are
>   naturally aligned.
> 

That last assumption has to change for the Meta architecture.

https://lwn.net/Articles/522188/

On meta, the structs and unions are padded to 4 bytes unless they are
explicitly marked as __packed.

regards,
dan carpenter

