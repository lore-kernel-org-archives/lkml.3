Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab3DYSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:00:22 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34081 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154Ab3DYSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:00:20 -0400
Message-ID: <51796E78.20203@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 23:27:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: akpm@linux-foundation.org, mgorman@suse.de, matthew.garrett@nebula.com,
        rientjes@google.com, riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, kamezawa.hiroyu@jp.fujitsu.com,
        lenb@kernel.org, rjw@sisk.pl, gargankita@gmail.com,
        paulmck@linux.vnet.ibm.com, amit.kachhap@linaro.org,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org, wujianguo@huawei.com,
        kmpark@infradead.org, thomas.abraham@linaro.org,
        santosh.shilimkar@ti.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/15][Sorted-buddy] mm: Memory Power Management
References: <20130409214443.4500.44168.stgit@srivatsabhat.in.ibm.com> <517028F1.6000002@sr71.net>
In-Reply-To: <517028F1.6000002@sr71.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042517-5564-0000-0000-000007A82DBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 10:40 PM, Dave Hansen wrote:
> On 04/09/2013 02:45 PM, Srivatsa S. Bhat wrote:
>> 2. Performance overhead is expected to be low: Since we retain the simplicity
>>    of the algorithm in the page allocation path, page allocation can
>>    potentially remain as fast as it would be without memory regions. The
>>    overhead is pushed to the page-freeing paths which are not that critical.
> 

[...]
 
> I still also want to see some hard numbers on:
>> However, memory consumes a significant amount of power, potentially upto
>> more than a third of total system power on server systems.

Please find below, the reference to the publicly available paper I had in
mind, when I made that statement:

C. Lefurgy, K. Rajamani, F. Rawson, W. Felter, M. Kistler, and Tom Keller.
Energy management for commercial servers. In IEEE Computer, pages 39–48,
Dec 2003.

Here is a quick link to the paper:
researcher.ibm.com/files/us-lefurgy/computer2003.pdf

On page 40, the paper shows the power-consumption breakdown for an IBM p670
machine, which shows that as much as 40% of the system energy is consumed by
the memory sub-system in a mid-range server.

I admit that the paper is a little old (I'll see if I can find anything more
recent that is publicly available, or perhaps you can verify the same if you
have data-sheets for other platforms handy), but given the trend of increasing
memory speeds and increasing memory density/capacity in computer systems, the
power-consumption of memory is certainly not going to become insignificant all
of a sudden.

IOW, the above data supports the point I was trying to make - Memory hardware
contributes to a significant portion of the power consumption of a system. And
since the hardware is now exposing ways to reduce the power consumption, it
would be worthwhile to try and exploit it by doing memory power management.

Regards,
Srivatsa S. Bhat

