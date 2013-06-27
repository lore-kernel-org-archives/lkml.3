Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3F0Kso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:48:44 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33306 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3F0Ksl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:48:41 -0400
Message-ID: <51CC1881.5060500@ozlabs.ru>
Date: Thu, 27 Jun 2013 20:48:33 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 3/8] vfio: add external user support
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>  <1372309356-28320-4-git-send-email-aik@ozlabs.ru>  <20130627165929.3828c261c957845a549ad95b@canb.auug.org.au> <1372326166.18612.42.camel@pasglop>
In-Reply-To: <1372326166.18612.42.camel@pasglop>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 07:42 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-06-27 at 16:59 +1000, Stephen Rothwell wrote:
>>> +/* Allows an external user (for example, KVM) to unlock an IOMMU
>> group */
>>> +static void vfio_group_del_external_user(struct file *filep)
>>> +{
>>> +     struct vfio_group *group = filep->private_data;
>>> +
>>> +     BUG_ON(filep->f_op != &vfio_group_fops);
>>
>> We usually reserve BUG_ON for situations where there is no way to
>> continue running or continuing will corrupt the running kernel.  Maybe
>> WARN_ON() and return?
> 
> Not even that. This is a user space provided "fd", we shouldn't oops the
> kernel because we passed a wrong argument, just return -EINVAL or
> something like that (add a return code).

I'll change to WARN_ON but...
This is going to be called on KVM exit on a file pointer previously
verified for correctness. If it is a wrong file*, then something went
terribly wrong.


-- 
Alexey
