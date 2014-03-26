Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaCZT42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:56:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:50570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbaCZT4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:56:22 -0400
Message-ID: <533330D6.3070808@biereigel.de>
Date: Wed, 26 Mar 2014 20:56:06 +0100
From: Stefan Biereigel <stefan@biereigel.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>
CC: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Stefan Biereigel <security@biereigel-wb.de>,
        Lan Tianyu <lantianyu1986@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        San Zamoyski <san@plusnet.pl>, "D. Jansen" <dennis.jansen@web.de>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>
Subject: Re: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after
 suspend to RAM.
References: <532FE3B2.9060808@biereigel-wb.de> <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com> <533014B1.4030307@biereigel-wb.de> <CAOLK0pyOV50Vqt+bX_QpH_tjL=8eWwvu+O70EvTOZ+ixWZmr3Q@mail.gmail.com> <CAGf84Q+9RcQqi=YYvF8X8EJzbtk7dJYTxScaZN4347U+POQ4AQ@mail.gmail.com> <5331E5EB.5000304@biereigel-wb.de> <5331E9E4.4050201@gmail.com> <5332099B.8090305@gmail.com> <5332AF10.90109@biereigel.de> <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com>
In-Reply-To: <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:9J7zNy1efZu00jwzWYW0lpm3mKfGfAwqzt50EFjTJxH
 5CXranfbtVn7dMH1t+AtW8Vo/BdiWMBzrokau9KHZ8h8Lg6S8Z
 b2h4PBx/Mt14bzcZ5Q091EHtJFF+y0/GE4A6H2ze3b5kI3jdW1
 lwwLqm6HIQIFP/8Yk7P1Qw1vNiBW27wNX3Cww0fzPjIR9q1u1U
 FoaGr6KRbeKloCcFM7VGawSkALIulDY8HzJ6iCqaQn5XtTMY3M
 g/FTY6dqgideYNtk+X83uTLgpYfWuCFpr0oWN8FsG9Q0ixrNTQ
 eNGRttdHg4sxsI3p8/JExTnyPnVPPNF0RrvKcLwTeZk94riVnp
 Mx/pfAYtbTz/vyUMVkbg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested both of your patches. The processing of events works well on my
N150, the lid is reported open correctly after resume.
For the second patch (the whitelisting-approach), I had to change the
Product Name to "N150/N210/N220" instead of "N150P", because that is
what dmidecode reports for my netbook.

So, all three approaches work equally well for me (whitelisting my
broken N150, blacklisting the broken Series 5/7/9, processing all the
stale events). I personally would prefer a solution which needs to
handle (best case) no custom cases, because there are always n+1 of
them. But, as I don't know if there may be any problems with the
approach that needs no special handling (processing all stale events) in
the future, I'm not the one to decide the correct solution.

What would you do? Do any of these patches create issues for you?

Greetings
Stefan

Am 26.03.2014 15:38, schrieb Kieran Clancy:
> On Wed, Mar 26, 2014 at 9:12 PM, Stefan Biereigel <stefan@biereigel.de> wrote:
>>
>> I don't know if it is a valid idea, but maybe it would be ok to process
>> events after resume in general, and only throw away events on those
>> platforms that continue to log events while in standby (Samsung 5/7/9)?
> 
> We can give it a shot!
> 
> It may even be that on Samsung 5/7/9 there is no harm in processing
> the events instead of discarding them.
> 
> Here's a patch that we can try for that:
> 
> http://kieranclancy.com/tmp/2014/03/ec_clear_process.patch
> 
> I'm going to have to clear up some hard drive space before I can
> compile a kernel with it (curse this tiny SSD), but if anyone else
> wants to give it a shot please feel free.
> 
> One thing I am still trying to think about is that Stefan's system
> must be about to check and process this EC event anyway, but we
> discard it first. I wonder if there is some difference in state (e.g.
> EC status bits) here that we might detect.
> 
> Failing all that, it might be easier to just whitelist this product
> rather than try to find every series 5/7/9/?/... Samsung product name.
> Something like this:
> 
> http://kieranclancy.com/tmp/2014/03/ec_clear_exclude_N150P.patch (not
> intended for use with other patch, they are mutually exclusive
> approaches)
> 
>> But after all, it would be better to find the command to tell the EC to
>> stop recording events and issue that before going to sleep. Is there any
>> way to find that command (for example on Windows)? Maybe that one is so
>> generic that we can issue it to all ECs, regardless of if it would
>> continue to log events during sleep.
> 
> It would be great to know what Windows does here, but even then we
> still need to be able to clear a jammed EC. You can still find posts
> around the internet where Windows users who've never touched Linux
> have these same kind of problems with their Samsung laptops. My guess
> is it only takes one blue screen of death or something where the EC
> isn't shut down properly, the EC fills up and then it's more or less a
> permanent state until the EC is cleared manually.
> 
> Thanks again for your testing, Stefan.
> 
> Kieran.
> 
