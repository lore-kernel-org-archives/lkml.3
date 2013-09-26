Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab3IZNUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:20:43 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:47321 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3IZNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:20:41 -0400
Message-ID: <524433AF.8010102@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 18:46:31 +0530
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
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <20130925234734.GK18242@two.firstfloor.org> <52438AA9.3020809@linux.intel.com>
In-Reply-To: <52438AA9.3020809@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092613-3864-0000-0000-00000A415CD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 06:45 AM, Arjan van de Ven wrote:
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
> btw note that those kind of memory power savings are content-preserving,
> so likely a whole chunk of these patches is not actually needed on SNB
> (or anything else Intel sells or sold)
> 

Umm, why not? By consolidating the allocations to fewer memory regions,
this patchset also indirectly consolidates the *references* as well. And
its the lack of memory references that really makes the hardware transition
the unreferenced banks to low-power (content-preserving) states. So from what
I understand, this patchset should provide noticeable benefits on Intel/SNB
platforms as well.

(BTW, even in the prototype powerpc hardware that I mentioned, the primary
memory power savings is expected to come from content-preserving states. So
its not like this patchset was designed only for content-losing/full-poweroff
type of scenarios).

Regards,
Srivatsa S. Bhat

