Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbbATRNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:13:45 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33907 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbbATRNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:13:42 -0500
MIME-Version: 1.0
In-Reply-To: <yw1x8ugxe8t9.fsf@unicorn.mansr.com>
References: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com>
 <CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com>
 <CAMuHMdWnjawtgkKGuL8b4A17EhDS6B0L-1_uhSnvEXXk5dNjwQ@mail.gmail.com>
 <25E49021-E94D-4DFA-AC37-1D4A3AAE9F88@konsulko.com> <yw1x8ugxe8t9.fsf@unicorn.mansr.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 20 Jan 2015 11:13:12 -0600
Message-ID: <CAL_JsqKkFDDdzHKZrzhSNkBF3+ewq-Vbb_LCOh0shwd9a=COKA@mail.gmail.com>
Subject: Re: [PATCH] of: Custom printk format specifier for device node
To: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:05 AM, Måns Rullgård <mans@mansr.com> wrote:
> Pantelis Antoniou <pantelis.antoniou@konsulko.com> writes:
>
>> Hi Geert,
>>
>>> On Jan 20, 2015, at 17:24 , Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>
>>> On Tue, Jan 20, 2015 at 3:47 PM, Rob Herring <robherring2@gmail.com> wrote:
>>>>> +       Examples:
>>>>> +
>>>>> +       %pO     /foo/bar@0              - Node full name
>>>>> +       %pO0    /foo/bar@0              - Same as above
>>>>> +       %pO1    /foo/bar@0[10]          - Node full name + phandle
>>>>> +       %pO2    /foo/bar@0[10:DdPB]     - Node full name + phandle + node flags
>>>>> +                                        D - dynamic
>>>>> +                                        d - detached
>>>>> +                                        P - Populated
>>>>> +                                        B - Populated bus
>>>>
>>>> We should think about what else we want to print for a node. Perhaps
>>>> 'On' for name, 'Oc' for compatible, etc.
>>>
>>> I was just going to say "The least verbose variant is name, not full_name”.
>>>
>>
>> Unfortunately in the context of device tree nodes ‘name' is usually
>> not what you want to print to identify the node in question. ‘name’ is
>> usually not unique.
>
> Name and address without the full path is usually a good compromise
> between uniqueness (it is usually unique for memory-mapped things) and
> verbosity.

How much of the address is in the name depends on how the address
translation is done. I don't think we really need to do full address
translations here.

%pOn     /foo/bar@0              - Node full name
%pOn0   bar@0              - Node name and unit address
%pOn1    /foo/bar@0[10]          - Node full name + phandle
%pOn2    /foo/bar@0[10:DdPB]     - Node full name + phandle + node flags
%pOc      vendor,foo-bar          - Most significant compatible string

We could do phandle and/or node flags as separate specifiers such as
%pOf for flags.

I'm not proposing implementing all these now, but just want to make
sure we have a structure to do so later.

Rob
