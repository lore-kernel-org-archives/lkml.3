Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151Ab3IDGta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:49:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43262 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762139Ab3IDGt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:49:26 -0400
X-AuditID: 9c930197-b7b44ae00000347f-56-5226d7f47110
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant <hkshaw@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora>
	<20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com>
	<5225E2C5.3080001@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 15:49:24 +0900
In-Reply-To: <5225E2C5.3080001@linux.vnet.ibm.com> (Hemant's message of "Tue,
	03 Sep 2013 18:53:17 +0530")
Message-ID: <87a9jtt72j.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Sep 2013 18:53:17 +0530, Hemant wrote:
> On 09/03/2013 02:47 PM, Masami Hiramatsu wrote:
>> (2013/09/03 17:25), Ingo Molnar wrote:
>>> * Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com> wrote:
>>>
>>>> This series adds support to perf to list and probe into the SDT markers.
>>>> The first patch implements listing of all the SDT markers present in
>>>> the ELFs (executables or libraries). The SDT markers are present in the
>>>> .note.stapsdt section of the elf. That section can be traversed to list
>>>> all the markers. Recognition of markers follows the SystemTap approach.
>>>>
>>>> The second patch will allow perf to probe into these markers. This is
>>>> done by writing the marker name and its offset into the
>>>> uprobe_events file in the tracing directory.
>>>> Then, perf tools can be used to analyze perf.data file.
>>> Please provide a better high level description that explains the history
>>> and scope of SDT markers, how SDT markers get into binaries, how they can
>>> be used for probing, a real-life usage example that shows something
>>> interesting not possible via other ways, etc.
>> Indeed, and also I'd like to know what versions of SDT this support,
>> and where we can see the technical document of that. As far as I know,
>> the previous(?) SDT implementation also involves ugly semaphores.
>> Have that already gone?

It seems it's not. I see the SDT v3 document still mentions semaphores.


> This link shows an example of marker probing with Systemtap:
> https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps

I think the link below would be more helpful for us :)

http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

Thanks,
Namhyung

>
> - Markers in binaries :
> These SDT markers are present in the ELF in the section named
> ".note.stapsdt".
> Here, the name of the marker, its provider, type, location, base
> address, semaphore address, arguments are present.
> We can retrieve these values using the members name_off and desc_off in
> Nhdr structure. If these are not enabled, they are present in the ELF
> as nop.
