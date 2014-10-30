Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161577AbaJ3XsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161293AbaJ3XsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:48:12 -0400
From: Paul Moore <pmoore@redhat.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 19:39:36 -0400
Message-ID: <5113482.YUK8i6Rueb@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.17.1-gentoo-r1; KDE/4.14.2; x86_64; ; )
In-Reply-To: <545297CC.6020306@samsung.com>
References: <54520A21.20404@samsung.com> <20141030144709.GA19721@kroah.com> <545297CC.6020306@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 30, 2014 08:55:56 PM Karol Lewandowski wrote:
> On 2014-10-30 15:47, Greg Kroah-Hartman wrote:
> > Other than that, I don't know exactly what your patches do, or why they
> > are needed, care to go into details?
> 
> Patches in question were supposed to add few hooks for kdbus-specific
> operations that doesn't seem to have compatible semantics with hooks
> currently available in LSM.
> 
> kdbus' bus introduces quite a few new concepts that we wanted to be able
> to limit based on MAC label/context, eg.
> 
>  - check flags at HELO stage (say disallow fd passing),
> 
>  - restrict ability to acquire name to certain subjects (for system bus),
> 
>  - disallow creation of new buses,
> 
>  - limit scope of broadcasts,
> 
>  - etc.
> 
> Please take a look at hook list - I think most of names are
> self-explanatory:
> 
>  
> https://github.com/lmctl/linux/blob/a9fe4c33b6e5ab25a243e0590df406aabb6add1
> 2/include/linux/security.h#L1874
> 
> kdbus modifications were pretty light - with most visible change being
> addition of opaque security pointer to kdbus_bus and similar structs.

[NOTE: we really should add the LSM list to this discussion and future 
patchset postings.]

Also, to be completely honest, I don't think we ever really arrived at any 
final conclusion about those LSM/kdbus hooks either.  At least I don't think I 
ever really satisfied myself that what we had was the "right" solution.

We both got busy and kinda drifted away from this effort.  Karol, did you do 
any further work on the hooks?

-- 
paul moore
security and virtualization @ redhat

