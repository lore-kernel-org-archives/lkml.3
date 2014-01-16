Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaAPEFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:05:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59843 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbaAPEFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:05:15 -0500
Message-ID: <52D75A55.2080503@zytor.com>
Date: Wed, 15 Jan 2014 20:04:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>
CC: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
References: <20140113053240.GA11237@dhcp-16-126.nay.redhat.com> <20140113101822.GA5388@pd.tnic> <20140113122320.GA1900@darkstar.nay.redhat.com> <52D3FCAA.7070004@linux.intel.com> <20140114014003.GB4327@dhcp-16-126.nay.redhat.com> <52D57F75.7060308@zytor.com> <20140115011609.GD23767@dhcp-16-126.nay.redhat.com> <52D6970D.3050701@zytor.com> <20140116014457.GA3807@dhcp-16-126.nay.redhat.com> <52D746D9.7030206@linux.intel.com> <20140116030343.GF3807@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20140116030343.GF3807@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 07:03 PM, Dave Young wrote:
>>
>> making something harder to grep and less standardized is hardly cleaner
>> and these things compile to nothing for non-modules.
> 
> It's not nothing, just very small increasement:
>    text	   data	    bss	    dec	    hex	filename
> 7636121	1391824	9355264	18383209	1188169	vmlinux
> 
>    text	   data	    bss	    dec	    hex	filename
> 7636113	1391824	9355264	18383201	1188161	vmlinux
> 
> I do not want to insist on this minor problem, if you want please keep it.
> 

Now *that* we can fix by making these macros expand to nothing if you
are compiling for a nonmodule, right?  That will benefit code that
legitimately can compile as a module but is configured "y", too.

	-hpa




