Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaKZMjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:39:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43287 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKZMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:39:46 -0500
Message-ID: <5475C9FE.8020003@oracle.com>
Date: Wed, 26 Nov 2014 07:39:26 -0500
From: boris ostrovsky <boris.ostrovsky@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        David Vrabel <david.vrabel@citrix.com>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
References: <20141125184351.GC4128@pd.tnic> <5474D0A1.2020600@oracle.com> <20141125190849.GF4128@pd.tnic> <5474D86E.6020608@oracle.com> <20141125202628.GG4128@pd.tnic> <20141125203634.GA6433@laptop.dumpdata.com> <20141125211708.GH4128@pd.tnic> <5474FBC6.7090603@oracle.com> <20141125221800.GI4128@pd.tnic> <54755E7D.3060903@oracle.com> <20141126105517.GA29982@pd.tnic>
In-Reply-To: <20141126105517.GA29982@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/26/2014 5:55 AM, Borislav Petkov wrote:
> On Wed, Nov 26, 2014 at 12:00:45AM -0500, Boris Ostrovsky wrote:
>> Sigh... I take this back. It breaks 32-bit baremetal. I haven't looked any
>> further but it seems to be dying very early. I suspect cpuid pv_op is not
>> set up yet. If that's true, perhaps you could check whether it is valid in
>> x86_guest()?
> Right, this is why we're using the native variants in the early loader.
> So we need a different method for detecting very early whether we're
> running as a guest.
>
> What I'd like more, though, is if we continue debugging the original
> issue where we fail in load_ucode_intel_ap(). Does it happen on this line:
>
> initrd_start_addr = (unsigned long)__pa_nodebug(*initrd_start_p);

I don't have access to my test setup right now (and won't be until late 
today at best) but I am pretty sure this was the line when I was looking 
at this yesterday.

>
> where we deref the initrd_start_p? Do you have a full splat with a Code:
> section?

https://lkml.org/lkml/2014/11/25/973 is all I have right now.


-boris
