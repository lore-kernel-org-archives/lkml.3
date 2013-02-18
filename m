Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3BRSVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:21:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3BRSVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:21:18 -0500
Date: Mon, 18 Feb 2013 13:21:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130218182114.GB25922@redhat.com>
References: <20130212185725.GC23410@redhat.com>
 <CALLzPKaD==fj3GSE3SnaWg5=VVNW7A_+caFzoh=_cBv8+BVKEA@mail.gmail.com>
 <20130213132920.GA3540@redhat.com>
 <CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
 <20130213143807.GC3540@redhat.com>
 <CALLzPKZ=eRWDtW6eSKPX5Qbvs_N37daiULw+T7o+DpoGfw_Z_A@mail.gmail.com>
 <20130213153013.GB6750@redhat.com>
 <1360794421.3524.495.camel@falcor1.watson.ibm.com>
 <20130214150303.GA16671@redhat.com>
 <1360855815.3524.615.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360855815.3524.615.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:30:15AM -0500, Mimi Zohar wrote:
> On Thu, 2013-02-14 at 10:03 -0500, Vivek Goyal wrote:
> > On Wed, Feb 13, 2013 at 05:27:01PM -0500, Mimi Zohar wrote:
> > 
> > [..]
> > > > Yep, I got that. Default policy gets overruled when a new policy is
> > > > loaded.
> > > > 
> > > > In secureboot mode, somehow above rule needs to take effect by default.
> > > > One option would be that kernel can enforce above rule.
> > > > (I guess by adding it to both default_list as well as policy list).
> > > 
> > > The default policy is empty, but can be replaced with boot command line
> > > options.  The existing options are ima_tcb and/ ima_appraise_tcb.
> > > Please feel free to define an additional policy.
> > 
> > I think just defining a new command line option is not sufficient
> > for secureboot use case.
> > 
> > - One can easily remove kernel command line option without breaking
> >   booting and easily bypass secureboot restrictions.
> 
> > - I guess this is one mandated rule by secureboot. There might still
> >   be a user policy which can co-exist with this rule.
> > 
> > So to me this is not a new policy. It is just one mandatory rule which
> > gets appended to any policy in secureboot mode. Think of it as mandatory
> > rule imposed by kernel for any policy user can define. And in secureboot
> > mode a user can not get rid of this rule. (Otherwise it breaks user
> > space signing and one can bypass secureboot and boot into unsigned
> > kernel).
> 
> Your rule allows both signed and unsigned files to be executed.  Signed
> files will just have more capabilities.  The ima_appraise_tcb option
> requires all files owned by root to be signed, otherwise access is
> denied.  The two policies simply can not co-exist.

Thinking loud. I guess we might have to extend ima policy/rules to allow
multiple appraise rules to co-exist. And access permission will finally
depend on if all the rules in same category return success.

Thanks
Vivek
