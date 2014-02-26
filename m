Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaBZH6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:58:07 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56845 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaBZH6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:58:05 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-24-530d9e8a2500
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [RFC PATCH v1 1/2] perf/sdt : Listing of SDT markers by perf
In-Reply-To: <530C5C69.9080800@linux.vnet.ibm.com> (Hemant Kumar's message of
	"Tue, 25 Feb 2014 14:33:37 +0530")
References: <20140224090833.7998.5416.stgit@hemant-fedora>
	<20140224091449.7998.25624.stgit@hemant-fedora>
	<87vbw3vfxy.fsf@sejong.aot.lge.com>
	<530C5C69.9080800@linux.vnet.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Wed, 26 Feb 2014 16:58:01 +0900
Message-ID: <87ppmauwza.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Tue, 25 Feb 2014 14:33:37 +0530, Hemant Kumar wrote:
> On 02/25/2014 12:26 PM, Namhyung Kim wrote:
>>> +	/* Translation from file representation to memory representation */
>>> +	if (gelf_xlatetom(*elf, &dst, &src,
>>> +			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)
>> Do we really need this xlate function?  It seems elf_getdata() already
>> did necessary conversions so only thing we need to do is checking its
>> class and read out the addresses in a proper length, no?
>>
>
> Hmm, alright. I thought the conversion was necessary for cross
> developed binaries.
> But I guess elf_getdata() should do all these conversions. Will remove that.

Looking at the source, it seems we still need to xlate() anyway.  The
conversion function (elf_cvt_note) only handles the header part since it
cannot know what the content is.

But obviously we cannot enable/disable the marker as we cannot run the
cross-built binary - it only can be used to show the list of SDT markers
in the binary.  Or else, we can simply deny to do it..

Thanks,
Namhyung
