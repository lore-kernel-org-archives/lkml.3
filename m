Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FYHZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:25:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62743 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3FYHZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:25:02 -0400
X-Spam-Score: -100.8
Message-ID: <51C94599.1020707@asianux.com>
Date: Tue, 25 Jun 2013 15:24:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        cornelia.huck@de.ibm.com, mtosatti@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: s390: kernel: reset 'c->hotpluggable' when failure
 occurs
References: <51C8F685.6000209@asianux.com> <20130625064832.GA4999@osiris>
In-Reply-To: <20130625064832.GA4999@osiris>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 02:48 PM, Heiko Carstens wrote:
> On Tue, Jun 25, 2013 at 09:46:45AM +0800, Chen Gang wrote:
>> > When smp_add_present_cpu() fails, it has reset all things excluding
>> > 'c->hotpluggable', so need reset it as original state completely.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  arch/s390/kernel/smp.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
>> > index 15a016c..c4c6f42 100644
>> > --- a/arch/s390/kernel/smp.c
>> > +++ b/arch/s390/kernel/smp.c
>> > @@ -1016,6 +1016,7 @@ out_cpu:
>> >  	unregister_cpu(c);
>> >  #endif
>> >  out:
>> > +	c->hotpluggable = 0;
>> >  	return rc;
> No, that doesn't make sense. All cpus on s390 are always hotplugable.
> It really doesn't matter if the value of this field is 0 or 1 after
> an error.
> 

If so, is it better to set 'c->hotpluggable' for all cpus on s390 during
initializing ?


Thanks.
-- 
Chen Gang

Asianux Corporation
