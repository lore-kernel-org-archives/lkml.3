Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbaGPGYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:24:05 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39092 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbaGPGYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:24:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140715191440.GB30497@dhcp22.suse.cz>
References: <CAGc_3jE=oECerrgPWpHt=oLAEBCJ+jmfsaEx7=qbzurBJxqz-Q@mail.gmail.com>
 <20140715191440.GB30497@dhcp22.suse.cz>
From: Alexei Fedotov <alexei.fedotov@gmail.com>
Date: Wed, 16 Jul 2014 10:23:22 +0400
Message-ID: <CAGc_3jHXGsv8uWNVejt5mEGLf2LbrfYk5jSgMC0Acap6jnrMOw@mail.gmail.com>
Subject: Re: Where in the code mmap + MAP_ANONYMOUS clears returned pages?
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Michal!
--
With best regards / с наилучшими пожеланиями,
Alexei Fedotov / Алексей Федотов,
http://dataved.ru/
+7 916 562 8095

[1] Start using Apache Openmeetings today, http://openmeetings.apache.org/
[2] Join Alexei Fedotov @linkedin, http://ru.linkedin.com/in/dataved/
[3] Join Alexei Fedotov @facebook, http://www.facebook.com/openmeetings


On Tue, Jul 15, 2014 at 11:14 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 15-07-14 21:55:03, Alexei Fedotov wrote:
>> Guys,
>>
>> I look into mmap.c code [1] and try to understand where anonymous
>> memory mapping (mmap + MAP_ANONYMOUS) sets memory to zero. My best
>> guess is I should dig that somewhere in mmap_region.
>>
>> Could you please help me locating the code which makes returned memory
>> pages clean? Thank you in advance.
>
> mmap doesn't allocate pages which back the mapping directly unless it is
> told to by MAP_POPULATE. So the clean pages are either allocated during
> the page fault path when the memory is accessed (see do_anonymous_page
> for private 4k pages fault, do_huge_pmd_anonymous_page for THP page and
> MAP_SHARED is left as an excercise for the reader ;)) or in mmap path
> directly when MAP_POPULATE is specified (see vm_mmap_pgoff which calls
> mm_populate)
>
>>
>> [1] http://code.ohloh.net/file?fid=RPa2fuiQ5j_IwR1nymptYBBC3X4&cid=w6qrXNDsMqk
>>
>> --
>> With best regards / с наилучшими пожеланиями,
>> Alexei Fedotov / Алексей Федотов,
>> http://dataved.ru/
>> +7 916 562 8095
>>
>> [1] Start using Apache Openmeetings today, http://openmeetings.apache.org/
>> [2] Join Alexei Fedotov @linkedin, http://ru.linkedin.com/in/dataved/
>> [3] Join Alexei Fedotov @facebook, http://www.facebook.com/openmeetings
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Michal Hocko
> SUSE Labs
