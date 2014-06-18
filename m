Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaFRBm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:42:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbaFRBm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:42:28 -0400
Message-ID: <53A0EE13.9070208@oracle.com>
Date: Wed, 18 Jun 2014 09:40:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, stefanr@s5r6.in-berlin.de, joro@8bytes.org,
        jejb@parisc-linux.org, deller@gmx.de, bhelgaas@google.com, clm@fb.com,
        Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com, bharrosh@panasas.com,
        bhalevy@primarydata.com, ccaulfie@redhat.com, teigland@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, cm224.lee@samsung.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        casey@schaufler-ca.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/24] kobject: return actual error on kset_create_and_add
References: <53A04FF7.5050900@oracle.com> <1403016160.27991.1.camel@dabdike.int.hansenpartnership.com> <53A05704.4070203@oracle.com> <20140617155030.GA14259@kroah.com>
In-Reply-To: <20140617155030.GA14259@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/17/2014 23:50 PM, Greg KH wrote:
> On Tue, Jun 17, 2014 at 10:56:04PM +0800, Jeff Liu wrote:
>>
>> On 06/17/2014 22:42 PM, James Bottomley wrote:
>>> On Tue, 2014-06-17 at 22:25 +0800, Jeff Liu wrote:
>>>> From: Jie Liu <jeff.liu@oracle.com>
>>>>
>>>> It's better to return the actual error rather than NULL because
>>>> kset_register() can failed due to other reasons.
>>>>

<snip>

>>>> 
>>>
>>> This patch series isn't bisectable.  When changing an error signal from
>>> NULL to non-NULL, you have to do it as one patch, otherwise if a
>>> bisection lands in here we'll get error returns from all our kobject
>>> kset code and the kernel won't boot.
>>
>> Thanks for pointing this out.
>>
>>> It's fine if you're sending it out as 24 patches for review, but it has
>>> to be applied as a single one.
>>
>> Ok, I'll post the v2 patch as a single one once this series has been reviewed.
> 
> Also, now that you sent a bunch of different patches out, some
> maintainers will not realize that this first one has to be applied (i.e.
> you gave them no sense that there was a dependancy.)
> 
> You will have to watch very carefully to ensure that those patches do
> not now get accepted, as they will break the existing code.

Ok, and I'll inform every other maintainers do not apply their patch individually.


Cheers,
-Jeff
