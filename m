Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaAHLwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:52:36 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44630 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbaAHLwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:52:33 -0500
Message-ID: <52CD3DBD.401@linux.vnet.ibm.com>
Date: Wed, 08 Jan 2014 17:29:57 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3] mm readahead: Fix the readahead fail in case of
 empty numa node
References: <1389003715-29733-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140106105620.GC3312@quack.suse.cz> <52CD0E2F.8000903@linux.vnet.ibm.com> <20140108103843.GA8256@quack.suse.cz>
In-Reply-To: <20140108103843.GA8256@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010811-9574-0000-0000-00000B660E55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 04:08 PM, Jan Kara wrote:
> On Wed 08-01-14 14:07:03, Raghavendra K T wrote:
>> On 01/06/2014 04:26 PM, Jan Kara wrote:
>>> On Mon 06-01-14 15:51:55, Raghavendra K T wrote:
>> ---
>> test file looked something like this:
>>
>> char buf[4096];
>>
>> int main()
>> {
>> int fd = open("testfile", O_RDONLY);
>> unsigned long read_bytes = 0;
>> int sz;
>> posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
>    Hum, but this call should have rather been:
> struct stat st;
>
> fstat(fd, &st);
> posix_fadvise(fd, 0, st.st_size, POSIX_FADV_WILLNEED);
>
> The posix_fadvise() call you had doesn't do anything...
>
> 								Honza

I reran the test with that change, no change the outcome though.
(I had earlier tested with hardcoded size etc.. but fstat was the
correct thing to do.. thanks). will include the result in V4

>
>> do {
>> 	sz = read(fd, buf, 4096);
>> 	read_bytes += sz;
>> } while (sz > 0);
>>
>> close(fd);
>> printf (" Total bytes read = %lu \n", read_bytes);
>> return 0;
>> }

