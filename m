Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3ILF5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:57:31 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:17500 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab3ILF52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:57:28 -0400
Message-ID: <523157C6.4010404@c-s.fr>
Date: Thu, 12 Sep 2013 07:57:26 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
References: <201309111644.r8BGiuDZ016325@localhost.localdomain>  <1378939017.12204.409.camel@snotra.buserror.net> <1378944911.4066.12.camel@pasglop>
In-Reply-To: <1378944911.4066.12.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 12/09/2013 02:15, Benjamin Herrenschmidt a écrit :
> On Wed, 2013-09-11 at 17:36 -0500, Scott Wood wrote:
>> I wonder why we don't start from entry 31 so we can actually make use of
>> that autodecrement.  What will happen when we load the first normal TLB
>> entry later on?  I don't see any setting of SPRN_MD_CTR after this code,
>> so won't it overwrite entry 30 (the middle 8M) in the CONFIG_PIN_TLB
>> case?
>>
>> Ben, would patches like this be considered bugfixes as far as merging
>> goes, or would they be for next given that it's something that's never
>> really worked right and hasn't been touched in years?
> Since they don't affect anything outside of 8xx, I'm happy to take them
> until around -rc2 or 3. But it's your call really.
>
>
Scott, you're right, I didn't see that other consequence.
I'll come with a more complete patch this afternoon.
Thanks
