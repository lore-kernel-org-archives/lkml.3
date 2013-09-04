Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3IDSCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:02:09 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36739 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3IDSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:02:04 -0400
Message-ID: <522771A6.4030504@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 23:15:10 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com> <5225E2C5.3080001@linux.vnet.ibm.com> <87a9jtt72j.fsf@sejong.aot.lge.com>
In-Reply-To: <87a9jtt72j.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090417-9574-0000-0000-0000097AB3E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 12:19 PM, Namhyung Kim wrote:
> On Tue, 03 Sep 2013 18:53:17 +0530, Hemant wrote:
>> On 09/03/2013 02:47 PM, Masami Hiramatsu wrote:
>>> (2013/09/03 17:25), Ingo Molnar wrote:
>>>> * Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com> wrote:
>>>>
>>>>> This series adds support to perf to list and probe into the SDT markers.
>>>>> The first patch implements listing of all the SDT markers present in
>>>>> the ELFs (executables or libraries). The SDT markers are present in the
>>>>> .note.stapsdt section of the elf. That section can be traversed to list
>>>>> all the markers. Recognition of markers follows the SystemTap approach.
>>>>>
>>>>> The second patch will allow perf to probe into these markers. This is
>>>>> done by writing the marker name and its offset into the
>>>>> uprobe_events file in the tracing directory.
>>>>> Then, perf tools can be used to analyze perf.data file.
>>>> Please provide a better high level description that explains the history
>>>> and scope of SDT markers, how SDT markers get into binaries, how they can
>>>> be used for probing, a real-life usage example that shows something
>>>> interesting not possible via other ways, etc.
>>> Indeed, and also I'd like to know what versions of SDT this support,
>>> and where we can see the technical document of that. As far as I know,
>>> the previous(?) SDT implementation also involves ugly semaphores.
>>> Have that already gone?
> It seems it's not. I see the SDT v3 document still mentions semaphores.

Yes, It still mentions semaphores and I will be handling these semaphores.

Thanks
Hemant
>
>
>> This link shows an example of marker probing with Systemtap:
>> https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
> I think the link below would be more helpful for us :)
>
> http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
>
> Thanks,
> Namhyung
>
>> - Markers in binaries :
>> These SDT markers are present in the ELF in the section named
>> ".note.stapsdt".
>> Here, the name of the marker, its provider, type, location, base
>> address, semaphore address, arguments are present.
>> We can retrieve these values using the members name_off and desc_off in
>> Nhdr structure. If these are not enabled, they are present in the ELF
>> as nop.

