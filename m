Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3IZNNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:13:32 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:45749 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab3IZNN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:13:29 -0400
Message-ID: <524431FF.50904@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 18:39:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        dave@sr71.net, hannes@cmpxchg.org, tony.luck@intel.com,
        matthew.garrett@nebula.com, riel@redhat.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        santosh.shilimkar@ti.com, kosaki.motohiro@gmail.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, thomas.abraham@linaro.org,
        amit.kachhap@linaro.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <20130925234734.GK18242@two.firstfloor.org> <52438A6B.30202@linux.intel.com>
In-Reply-To: <52438A6B.30202@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092613-2000-0000-0000-00000DE00AD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 06:44 AM, Arjan van de Ven wrote:
> On 9/25/2013 4:47 PM, Andi Kleen wrote:
>>> Also, the changelogs don't appear to discuss one obvious downside: the
>>> latency incurred in bringing a bank out of one of the low-power states
>>> and back into full operation.  Please do discuss and quantify that to
>>> the best of your knowledge.
>>
>> On Sandy Bridge the memry wakeup overhead is really small. It's on by
>> default
>> in most setups today.
> 
> yet grouping is often defeated (in current systems) due to hw level
> interleaving ;-(
> sometimes that's a bios setting though.
> 

True, and I plan to tweak those hardware settings in the prototype powerpc
platform and evaluate the power vs performance trade-offs of various
interleaving schemes in conjunction with this patchset.

> in internal experimental bioses we've been able to observe a "swing" of
> a few watts
> (not with these patches but with some other tricks)...

Great! So, would you have the opportunity to try out this patchset as well
on those systems that you have? I can modify the patchset to take memory
region info from whatever source you want me to take it from and then we'll
have realistic power-savings numbers to evaluate this patchset and its benefits
on Intel/x86 platforms.

> I'm curious to see how these patches do for Srivatsa
> 

As I mentioned in my other mail, I don't yet have a setup for doing actual
power-measurements. Hence, so far I was focussing on the algorithmic aspects
of the patchset and was trying to get an excellent consolidation ratio,
without hurting performance too much. Going forward, I'll work on getting the
power-measurements as well on the powerpc platform that I have.
 
Regards,
Srivatsa S. Bhat

