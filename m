Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaLBOfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:35:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22481 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLBOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:35:13 -0500
Message-ID: <547DCE78.1020906@oracle.com>
Date: Tue, 02 Dec 2014 09:36:40 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        david.vrabel@citrix.com, konrad.wilk@oracle.com, pbonzini@redhat.com,
        gleb@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on paravirt
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com> <20141201220057.GC4730@pd.tnic> <547CEC5C.9070201@oracle.com> <20141201223708.GF4730@pd.tnic>
In-Reply-To: <20141201223708.GF4730@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 05:37 PM, Borislav Petkov wrote:
> On Mon, Dec 01, 2014 at 05:31:56PM -0500, Boris Ostrovsky wrote:
>> I think so. The problem we have now is __pa() macro that we only use
>> on 32-bit. I'll queue this for overnight tests to make sure and if it
>> indeed works then 3.19 should be fine.
> Cool, thanks.

All tests passed.

> I'd still take your patch for 3.19 though because I'm fixing the 32-bit
> reloading path properly and will remove the ifdef afterwards.
>
> And even then, I'd like to prevent loading the module on a paravirt
> guest if it is totally unneeded there.
>

I wonder whether we should prevent all guests (not just paravirt) from 
loading microcode driver (and from doing early microcode loading).

-boris
