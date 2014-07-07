Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaGGMcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:32:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53691 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaGGMcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:32:16 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Michael Lentine <mlentine@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] tools: perf: prefer clarity in setup_pager
In-Reply-To: <CAB1dqC7BqsaDtXVYx24M5R9eaY7ZfpEtu3bxbJHXNHYhAbJETg@mail.gmail.com>
Organization: http://mina86.com/
References: <1404668531-31550-1-git-send-email-mina86@mina86.com> <CAB1dqC7BqsaDtXVYx24M5R9eaY7ZfpEtu3bxbJHXNHYhAbJETg@mail.gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140707:linux-kernel@vger.kernel.org::uCZwJUthUS/VQ0/X:00000000000000000000000000000000006iv
X-Hashcash: 1:20:140707:mlentine@google.com::fvV0IzSSEqDFRzNb:0000000000000000000000000000000000000000004I4M
X-Hashcash: 1:20:140707:mingo@elte.hu::L5AXLdjGKT26HkR5:00006+mq
X-Hashcash: 1:20:140707:eranian@google.com::g4pkmzZDoB7pVSEc:0000000000000000000000000000000000000000000H+cf
Date: Mon, 07 Jul 2014 14:32:08 +0200
Message-ID: <xa1tmwcl1h9z.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06 2014, Michael Lentine <mlentine@google.com> wrote:
> Unless I'm missing something this removes defaulting the pager to cat
> if nothing is found which is very useful for devices/oses without less
> or pager.

The last two conditions are merged together, i.e.

       if (!pager)
               pager = "cat";
       if (!*pager || !strcmp(pager, "cat"))
               return;

becomes:

       if (!pager || !*pager || !strcmp(pager, "cat"))
               return;

This also in my opinion simplifies the code since the original is a bit
convoluted.  If pager is NULL it first assigns "cat" to it and then in
the very next condition compares pager to "cat".  With this change, it's
more obvious that if pager is NULL, the function will terminate.

> On Sun, Jul 6, 2014 at 10:42 AM, Michal Nazarewicz <mina86@mina86.com>
> wrote:
>> “!(pager || access(…))” is indeed pretty smart way to write
>> “!pager && access(…) == 0” but other than being clever it gives
>> no advantages and merely confuses the reader who needs to wonder
>> what is actually going on.
>>
>> As such, replace the checks with much cleaner ones.
>>
>> Also, while at it, merge the lest “!pager” test with the next
>> test that yields true after the “!pager” if's body is executed.
>> ---
>>  tools/perf/util/pager.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
>> index 31ee02d..14da1b0 100644
>> --- a/tools/perf/util/pager.c
>> +++ b/tools/perf/util/pager.c
>> @@ -57,13 +57,11 @@ void setup_pager(void)
>>         }
>>         if (!pager)
>>                 pager = getenv("PAGER");
>> -       if (!(pager || access("/usr/bin/pager", X_OK)))
>> +       if (!pager && access("/usr/bin/pager", X_OK) == 0)
>>                 pager = "/usr/bin/pager";
>> -       if (!(pager || access("/usr/bin/less", X_OK)))
>> +       if (!pager && access("/usr/bin/less", X_OK) == 0)
>>                 pager = "/usr/bin/less";
>> -       if (!pager)
>> -               pager = "cat";
>> -       if (!*pager || !strcmp(pager, "cat"))
>> +       if (!pager || !*pager || !strcmp(pager, "cat"))
>>                 return;
>>
>>         spawned_pager = 1; /* means we are emitting to terminal */

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
