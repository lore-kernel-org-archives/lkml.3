Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3HPNKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:10:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab3HPNKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:10:43 -0400
Message-ID: <520E24CE.9040604@suse.cz>
Date: Fri, 16 Aug 2013 15:10:38 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux kbuild ML <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the ext4 tree
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au> <CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com> <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au> <87zjsted0c.fsf@linaro.org> <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au> <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au> <20130808191650.GB3282@free.fr> <20130808215449.GD3282@free.fr> <20130809114248.GA5691@merkur.ravnborg.org> <20130811213923.GA5312@free.fr>
In-Reply-To: <20130811213923.GA5312@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.8.2013 23:39, Yann E. MORIN wrote:
> On 2013-08-09 13:42 +0200, Sam Ravnborg spake thusly:
>> If we drop the special handling of "MODULES" and introduced
>> the following in we may fix it - hopefully:
>>
>> config MODULES
>> 	option modules
>>
>> The option handling is already in place. It is even documented :-)
> 
> Yes, indeed, that one is pretty easy! :-)
> 
>> At least we could then drop the sym_lookup here (zconf.y):
>>         if (!modules_sym->prop) {
>>                 struct property *prop;
>>
>>                 prop = prop_alloc(P_DEFAULT, modules_sym);
>>                 prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
>>         }
>> Without the sym_lookup I think the symbol will not be defined and tus not marked valid.
> 
> Sorry, I don't understand what we should do here.
> 
> From what I understand, here's what happens:
>   - there's no symbol that declared the 'modules' option, so the
>     modules_sym->prop is NULL;
>   - so we look for the symbol 'MODULES' and use that as the symbol used
>     to evaluate if tristates are enabled.
> 
> So, now we have 'option modules' added to MODULES, we never enter this
> if() condition.
> 
> But what would happen to other projects that do not have a symbol set
> with 'option modules' and no 'MODULES' symbol? Surely, those projects do
> not need tristates, but what should the code do in this case?
> 
> So, I don't know what to replace this 'sym_lookup("MODULES", 0)' with.

If the Kconfig files do not provide any symbol with 'option modules',
then set modules_sym to a dummy bool with the value 'n'?

Thanks,
Michal
