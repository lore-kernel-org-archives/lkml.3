Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3F0Jnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:43:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:45169 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab3F0Jnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:43:40 -0400
Message-ID: <1372326166.18612.42.camel@pasglop>
Subject: Re: [PATCH 3/8] vfio: add external user support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Date: Thu, 27 Jun 2013 19:42:46 +1000
In-Reply-To: <20130627165929.3828c261c957845a549ad95b@canb.auug.org.au>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
	 <1372309356-28320-4-git-send-email-aik@ozlabs.ru>
	 <20130627165929.3828c261c957845a549ad95b@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 16:59 +1000, Stephen Rothwell wrote:
> > +/* Allows an external user (for example, KVM) to unlock an IOMMU
> group */
> > +static void vfio_group_del_external_user(struct file *filep)
> > +{
> > +     struct vfio_group *group = filep->private_data;
> > +
> > +     BUG_ON(filep->f_op != &vfio_group_fops);
> 
> We usually reserve BUG_ON for situations where there is no way to
> continue running or continuing will corrupt the running kernel.  Maybe
> WARN_ON() and return?

Not even that. This is a user space provided "fd", we shouldn't oops the
kernel because we passed a wrong argument, just return -EINVAL or
something like that (add a return code).

Ben.



