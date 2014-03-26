Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaCZNxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:53:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60206 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbaCZNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:53:52 -0400
Date: Wed, 26 Mar 2014 13:53:46 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org,
        fenghua.yu@intel.com, matt.fleming@intel.com, tony.luck@intel.com,
        x86@kernel.org, tglx@linutronix.de, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, Daniel Kiper <daniel.kiper@oracle.com>,
        konrad.wilk@oracle.com, Tang Liang <liang.tang@oracle.com>,
        eshelton@pobox.com, mingo@redhat.com, linux-efi@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH v3 5/5] xen: Put EFI machinery in place
Message-ID: <20140326135346.GF24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-6-git-send-email-daniel.kiper@oracle.com>
 <20140326131214.GC24856@console-pimps.org>
 <5332E4A802000078000025B6@nat28.tlf.novell.com>
 <20140326134617.GE24856@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326134617.GE24856@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar, at 01:46:17PM, Matt Fleming wrote:
> On Wed, 26 Mar, at 01:31:04PM, Jan Beulich wrote:
> > >>> On 26.03.14 at 14:12, <matt@console-pimps.org> wrote:
> > > 
> > > Is there a reason that you can't just populate an efi_system_table_t
> > > object, which could be used by efi_init(), so that we can save you the
> > > trouble of duplicating all of this code?
> > 
> > Would the generic function cope with all other fields being NULL (or
> > equivalent)?
>  
> I've no idea, but it shouldn't be difficult to make that work. And by
> making it work in the generic code

Guh, hit Send too soon... sorry.

What I was trying to say was that there's a real benefit to keeping all
these idiosyncrasies, such as "This field may be NULL on some platforms,
or this field, or that", in one place, because it gives you an immediate
view of what platforms Linux supports and what assumptions we can make.

It also helps immensely when the time comes to do some refactoring -
because it's all contained in one central place all the use cases are in
front of you.

Obviously this approach doesn't work for super-platform specific stuff,
but it's not clear to me that these patches fall into that category.

-- 
Matt Fleming, Intel Open Source Technology Center
