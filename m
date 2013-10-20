Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3JTHur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 03:50:47 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51003 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3JTHur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 03:50:47 -0400
Message-ID: <52638B44.2030800@linux.vnet.ibm.com>
Date: Sun, 20 Oct 2013 13:20:28 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v3 2/3] Support for perf to probe into SDT markers:
References: <20131018143714.10452.83494.stgit@hemant-fedora> <20131018144406.10452.43317.stgit@hemant-fedora> <5262A9C1.5030200@hitachi.com>
In-Reply-To: <5262A9C1.5030200@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102007-9264-0000-0000-000004C1A52C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 09:18 PM, Masami Hiramatsu wrote:
> [...]
> +
> +	/*
> +	 * Find out the .stapsdt.base section.
> +	 * This scn will help us to handle prelinking (if present).
> +	 * Compare the retrieved file offset of the base section with the
> +	 * base address in the description of the SDT note. If its different,
> +	 * then accordingly, adjust the note location.
> +	 */
> +	if (elf_section_by_name(elf, &ehdr, &shdr, SDT_BASE_SCN, NULL))
> +		base_off = shdr.sh_offset;
> +	if (base_off) {
> +		if (tmp->bit32)
> +			key->addr.a32[0] = tmp->addr.a32[0] + base_off -
> +				tmp->addr.a32[1];
> +		else
> +			key->addr.a64[0] = tmp->addr.a64[0] + base_off -
> +				tmp->addr.a64[1];
> +	}
> +	key->bit32 = tmp->bit32;
> +}
> +
> +int search_sdt_note(struct sdt_note *key, struct list_head *sdt_notes,
> +		    const char *target)
> Hmm, this interface looks very odd.
>   - This just finds the first matched sdt_note entry instead of the list.
>     In that case, we don't need to pass the list_head.
>   - If the purpose is just counting the number of matched entries (or just
>     checking existence), we also don't need the list. Just returning the
>     number is enough.
>
> I recommend you to remove the "sdt_notes", and make the caller check
> key->addr is set.

Yeah, list isn't required in this case. Thanks for pointing that out. 
Will change that.

> [...]
>
-- 
Thanks
Hemant Kumar

