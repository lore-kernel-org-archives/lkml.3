Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaKYTZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:25:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29588 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKYTZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:25:22 -0500
Message-ID: <5474D71E.8070603@oracle.com>
Date: Tue, 25 Nov 2014 12:23:10 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: Thomas Gleixner <tglx@linutronix.de>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, peterz@infradead.org, riel@redhat.com,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com,
        atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org,
        serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com,
        vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org,
        yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com,
        axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>	 <alpine.DEB.2.11.1411242317380.6439@nanos> <54749617.5030309@oracle.com> <1416940024.26209.2.camel@linux-t7sj.site>
In-Reply-To: <1416940024.26209.2.camel@linux-t7sj.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 11:27 AM, Davidlohr Bueso wrote:
> On Tue, 2014-11-25 at 07:45 -0700, Khalid Aziz wrote:
>> This solution has been used by both database and java on other OSs and
>> has shown performance improvement. Andrew had asked for performance
>> numbers on Linux with this patch last time I sent this out and it took
>> me a while to get performance folks to run a full TPC-C workload. They
>> did see a 3% improvement in tpcc as I noted in commit log and that is a
>> significant improvement.
>
> 3% for such a change seems pretty worthless... I would have expected
> this having to impact performance much more.
>

Performance impact will depend upon how big a bottleneck the spinlock 
was creating and how severe the resulting convoy problem was. Database 
guys try to squeeze every bit out of the system and 3% is considered to 
be very good gain. 10% gain would have been nicer :)

--
Khalid
