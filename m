Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbaHZMzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:55:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941AbaHZMzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:55:00 -0400
Message-ID: <53FC83A1.5040000@suse.com>
Date: Tue, 26 Aug 2014 14:54:57 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, stefan.bader@canonical.com,
        toshi.kani@hp.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [Xen-devel] [PATCH 3/3] Support Xen pv-domains using PAT
References: <1409033783-12136-1-git-send-email-jgross@suse.com> <1409033783-12136-4-git-send-email-jgross@suse.com> <53FC689D.7020507@citrix.com>
In-Reply-To: <53FC689D.7020507@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 12:59 PM, David Vrabel wrote:
> On 26/08/14 07:16, Juergen Gross wrote:
>> With the dynamical mapping between cache modes and pgprot values it is now
>> possible to use all cache modes via the Xen hypervisor PAT settings in a
>> pv domain.
>>
>> All to be done is to read the PAT configuration MSR and set up the translation
>> tables accordingly.
> [...]
>> +void xen_init_cache_types(void)
>> +{
>> +	pat_init_cache_modes();
>> +}
>
> No need to introduce xen_init_cache_types(), just call
> pat_init_cache_modes() directly.

Indeed. This was a leftover from a previous version.

>
>>   void xen_set_pat(u64 pat)
>>   {
>> -	/* We expect Linux to use a PAT setting of
>> -	 * UC UC- WC WB (ignoring the PAT flag) */
>> -	WARN_ON(pat != 0x0007010600070106ull);
>> +	xen_init_cache_types();
>>   }
>
> Remove xen_set_pat() and remove the special-cased handling of the PAT
> MSR from xen_write_msr_safe().

Hmm, why not. Reduces Xen specific handling even more.


Juergen
