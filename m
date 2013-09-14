Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3INMXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab3INMXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:23:52 -0400
Date: Sat, 14 Sep 2013 14:23:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexander Graf <agraf@suse.de>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] arm: kvm: clamp NR_VCPUS to MAX_VCPUS
Message-ID: <20130914122310.GC2596@hawk.usersys.redhat.com>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
 <1379160656-28050-2-git-send-email-drjones@redhat.com>
 <AC39CB35-1EE1-49DE-A2E4-F544699A516B@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AC39CB35-1EE1-49DE-A2E4-F544699A516B@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 07:14:02AM -0500, Alexander Graf wrote:
> 
> 
> Am 14.09.2013 um 07:10 schrieb Andrew Jones <drjones@redhat.com>:
> 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> > arch/arm/kvm/arm.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index 741f66a2edbd7..9ebf8ac3a12ff 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -201,7 +201,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> >        r = 1;
> >        break;
> >    case KVM_CAP_NR_VCPUS:
> > -        r = num_online_cpus();
> > +        r = min(num_online_cpus(), KVM_MAX_VCPUS);
> 
> Is there any real reason to prohibit overcommit?

This doesn't prohibit it. Users can attempt to configure anything they'd
like, but only selections KVM_MAX_VCPUS and below will work.

drew

> 
> Alex
> 
> >        break;
> >    case KVM_CAP_MAX_VCPUS:
> >        r = KVM_MAX_VCPUS;
> > -- 
> > 1.8.1.4
> > 
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/cucslists/listinfo/kvmarm
