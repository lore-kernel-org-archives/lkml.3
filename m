Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3JTHrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 03:47:35 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:49834 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3JTHre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 03:47:34 -0400
Message-ID: <52638A84.7000706@linux.vnet.ibm.com>
Date: Sun, 20 Oct 2013 13:17:16 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v3 1/3] SDT markers listing by perf:
References: <20131018143714.10452.83494.stgit@hemant-fedora> <20131018144231.10452.65885.stgit@hemant-fedora> <5262A4F6.3000609@hitachi.com>
In-Reply-To: <5262A4F6.3000609@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102007-5490-0000-0000-000004594269
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On 10/19/2013 08:57 PM, Masami Hiramatsu wrote:
> (2013/10/18 23:44), Hemant Kumar wrote:
[...]
>> +int show_sdt_notes(const char *target)
>> +{
>> +	int ret;
>> +	LIST_HEAD(sdt_notes);
>> +
>> +	ret = get_sdt_note_list(&sdt_notes, target);
>> +	if (!list_empty(&sdt_notes)) {
>> +		if (!ret)
> Hmm, why don't you check the ret first? And I think the
> empty check should be done in display_sdt_note_info() and
> cleanup_sdt_note_list() (anyway, since both uses list_for_each*()
> it is already done).

Okay, will do that.

>
>> +			display_sdt_note_info(&sdt_notes);
>> +		cleanup_sdt_note_list(&sdt_notes);
>> +	}
>> +	return ret;
>> +}
> Others are good for me. :)

Great! thanks for the review. :)

-- 
Thanks
Hemant Kumar

