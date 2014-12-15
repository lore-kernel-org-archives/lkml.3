Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaLOFUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:20:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaLOFUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:20:46 -0500
Message-ID: <548E6FAA.4070204@suse.com>
Date: Mon, 15 Dec 2014 06:20:42 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] xen: build infrastructure for generating hypercall
 depending symbols
References: <1418321065-10212-1-git-send-email-jgross@suse.com> <1418321065-10212-2-git-send-email-jgross@suse.com> <548B70B3.7030807@oracle.com>
In-Reply-To: <548B70B3.7030807@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 11:48 PM, Boris Ostrovsky wrote:
> On 12/11/2014 01:04 PM, Juergen Gross wrote:
>> diff --git a/scripts/xen-hypercalls.sh b/scripts/xen-hypercalls.sh
>> new file mode 100644
>> index 0000000..e6447b7
>> --- /dev/null
>> +++ b/scripts/xen-hypercalls.sh
>> @@ -0,0 +1,11 @@
>> +#!/bin/sh
>> +out="$1"
>> +shift
>> +in="$@"
>> +
>> +for i in $in; do
>> +    eval $CPP $LINUXINCLUDE -dD -imacros "$i" -x c /dev/null
>> +done | \
>> +awk '$1 == "#define" && $2 ~ /__HYPERVISOR_[a-z][a-z_0-9]*/ { v[$3] =
>> $2 }
>> +    END {for (i in v) if (!(v[i] in v))
>> +        print "HYPERCALL("substr(v[i], 14)")"}' | sort -u >$out
>
> Why do you 'sort -u'? Do you expect multiple definitions of the same
> hypercall?

Paranoia related to the use of wildcards for files scanned:

$(srctree)/include/xen/interface/xen*.h


Juergen
