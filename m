Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888Ab3KTFti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:49:38 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37468 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTFtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:49:36 -0500
MIME-Version: 1.0
In-Reply-To: <87y54kvz87.fsf@tassilo.jf.intel.com>
References: <1384822222-28795-1-git-send-email-andi@firstfloor.org>
 <20131119104203.GB18872@dhcp22.suse.cz> <20131119184200.GD29695@two.firstfloor.org>
 <20131119191135.GA8634@dhcp22.suse.cz> <20131119201333.GD19762@tassilo.jf.intel.com>
 <20131119212123.GA9339@dhcp22.suse.cz> <87y54kvz87.fsf@tassilo.jf.intel.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 20 Nov 2013 00:49:16 -0500
Message-ID: <CAHGf_=py9fq51viTx1RfmAMf=t=TX=86nb8h6F7nW7qw=pCRow@mail.gmail.com>
Subject: Re: [PATCH] Expose sysctls for enabling slab/file_cache interleaving
To: Andi Kleen <andi@firstfloor.org>
Cc: Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 4:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Michal Hocko <mhocko@suse.cz> writes:
>>
>> Another option would be to use sysctl values for the top cpuset as a
>> default. But then why not just do it manually without sysctl?
>
> I want to provide an alternative to having to use cpusets to use this,
> that is actually usable for normal people.
>
> Also this is really a global setting in my mind.
>
>> If you create a cpuset and explicitly disable spreading then you would
>> be quite surprised that your process gets pages from all nodes, no?
>
> If I enable it globally using a sysctl I would be quite surprised
> if some cpuset can override it.
>
> That argument is equally valid :-)
>
> The user configured an inconsistent configuration, and the kernel
> has to make a decision somehow.
>
> In the end it is arbitary, but not having to check the cpuset
> here is a lot cheaper, so I prefer the "sysctl has priority"
> option.

sorry.
I agree with Michael. If there are large scope knob and small scope knob,
the small scope should have high priority. It is one of best practice of the
interface design.

However, I fully agree the basic concept of this patch. sysctl help a
lot of admins.
