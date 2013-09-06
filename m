Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750803Ab3IFGh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:37:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50861 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3IFGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:37:58 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-70-52297844a6b2
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora>
	<20130903073655.4793.20013.stgit@hemant-fedora>
	<87ioyht7e4.fsf@sejong.aot.lge.com>
	<52276FF5.9050808@linux.vnet.ibm.com>
Date: Fri, 06 Sep 2013 15:37:56 +0900
In-Reply-To: <52276FF5.9050808@linux.vnet.ibm.com> (Hemant's message of "Wed,
	04 Sep 2013 23:07:57 +0530")
Message-ID: <87fvtisbej.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Wed, 04 Sep 2013 23:07:57 +0530, Hemant wrote:
> On 09/04/2013 12:12 PM, Namhyung Kim wrote:
>> On Tue, 03 Sep 2013 13:06:55 +0530, Hemant Kumar wrote:
>>> +	/*
>>> +	 * Look for Section type = SHT_NOTE, flags = no SHF_ALLOC
>>> +	 * and name = .note.stapsdt
>>> +	 */
>>> +	scn = elf_section_by_name(elf, &ehdr, &shdr, NOTE_SCN, NULL);
>>> +	if (scn == NULL) {
>>> +		pr_err("%s section not found!\n", NOTE_SCN);
>>> +		goto out_end;
>>> +	}
>>> +
>>> +	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC))
>>> +		goto out_end;
>>> +
>>> +	data = elf_getdata(scn, NULL);
>>> +
>>> +	/* Get the notes */
>>> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
>>> +					      &desc_off)) > 0; offset = next) {
>>> +		tmp = populate_note(&elf, (const char *)((long)(data->d_buf) +
>>> +							 (long)desc_off),
>>> +				    nhdr.n_descsz, nhdr.n_type);
>> Shouldn't we check the name of note being "stapsdt" as well as version
>> (type) 3?
>
> Since, we are already fetching the section NOTE_SCN (".note.stapsdt")
> and then we check for the type being SHT_NOTE and SHF_ALLOC, is it
> required to do the same for the individual notes?

I don't know.  Now it seems only includes SDT notes with name being
"stapsdt" and type being 3.  But things can be changed in future..

Thanks,
Namhyung
