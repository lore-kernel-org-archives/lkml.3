Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3LJHRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:17:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:49321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3LJHRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:17:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,864,1378882800"; 
   d="scan'208";a="447479036"
Message-ID: <52A6C1D8.7020900@intel.com>
Date: Tue, 10 Dec 2013 09:25:12 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: David Mosberger-Tang <dmosberger@gmail.com>, dedekind1@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: UBIFS recovery taking too long
References: <CACwUX0PEYGsNMDvy85EsrApWzNU3iTyY-1KHMaj1ay0xxKX6RQ@mail.gmail.com> <CACwUX0PGGM99-2H41S0eqOVLsh-7+Dan+gcy9deK1movx_wWPQ@mail.gmail.com> <CAKocOOOT2J_+hmEsAnAJVWV7TOqgApd3Lih+3WaRob4e8Nex4Q@mail.gmail.com>
In-Reply-To: <CAKocOOOT2J_+hmEsAnAJVWV7TOqgApd3Lih+3WaRob4e8Nex4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/13 23:30, Shuah Khan wrote:
> Adding ubifs maintainers.
> 
> -- Shuah
> 
> On Mon, Dec 9, 2013 at 1:53 PM, David Mosberger-Tang
> <dmosberger@gmail.com> wrote:
>> I've had no luck getting any response from the linux-mtd mailing list
>> regarding the issue reported below.
>> I think it is a very serious issue since it can easily render an
>> embedded system unusable.
>>
>>   --david
>>
>> ---------- Forwarded message ----------
>> From: David Mosberger-Tang <dmosberger@gmail.com>
>> Date: Thu, Nov 7, 2013 at 11:44 AM
>> Subject: UBIFS recovery taking too long
>> To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
>>
>>
>> We recently encountered a strange issue where UBIFS recovery is
>> suddenly taking a lot longer than usual (v3.7-based kernel).  In our
>> case, recovery took about 30 seconds.  This caused a serious problem
>> because our watchdog timer was set to 15 seconds, effectively
>> rendering the devices unbootable.
>>
>> Does anybody know what triggers this slow recovery mode?  Also, how
>> can we calculate a worst-case recovery time for a given flash
>> chip-size.

Slowness is probably caused by trying to make free space.  Was the file
system very full?  A smaller journal might help.

Probably the only way to determine worst-case recovery time is to test it.
Worst case conditions are likely to be a full journal and a nearly full file
system.

Ideally you want to capture a file system image that exhibits the slow
behaviour, then you can enable debug messages and see what it is doing.

>>
>> Thanks,
>>
>>   --david
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

