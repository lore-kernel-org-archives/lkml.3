Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3DZGf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:35:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42477 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3DZGf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:35:56 -0400
Date: Fri, 26 Apr 2013 09:35:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christopher Li <sparse@chrisli.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        Jingoo Han <jg1.han@samsung.com>, kbuild-all@01.org,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] forced argument Was Re: sparse: incorrect type in
 argument 1 (different address spaces)
Message-ID: <20130426063538.GA5072@mwanda>
References: <5171d93a.0NZAGYYKNj8hjsAs%fengguang.wu@intel.com>
 <20130422165629.bae79e6c5251bf148a3bae73@linux-foundation.org>
 <CANeU7QmDXRj-rNWvb0qhXCmzyJBFv=1URzzjEZN6ARaAf15-hw@mail.gmail.com>
 <20130423061600.GN6638@mwanda>
 <5179E1E1.4050304@chrisli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5179E1E1.4050304@chrisli.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:09:37PM -0700, Christopher Li wrote:
> On 04/22/2013 11:16 PM, Dan Carpenter wrote:
> > That didn't work.  It's the the void * in the parameter list that's
> > the problem.  We'd need to do something like the patch below:
> > 
> > Otherwise we could add "__ok_to_cast" thing to Sparse maybe?
> 
> Thanks for the insight. I make a small patch to test the __ok_to_cast
> feature. The syntax is adding the force attribute to the argument
> declaration.
> 
> it will look like this:
> static inline long __must_check PTR_ERR( __force const void *ptr)
> 
> That means the "ptr" argument will perform a forced cast when receiving
> the argument. It is OK to pass __iomem pointer to "ptr".
> 
> The example are in the patch. It need to patch both sparse and the
> Linux tree.
> 
> What do you say?

That's looks great.  :)

I tested a patched kernel with an unpatched kernel as well and that
doesn't cause any new problems.

regards,
dan carpenter

