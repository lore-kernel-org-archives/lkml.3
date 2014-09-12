Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaILXhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:37:48 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57840 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaILXhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:37:46 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Rustad <mark.d.rustad@intel.com>,
        "Kirsher\, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to avoid -Wshadow warnings
In-Reply-To: <20140912154013.47dad90e7519146c6da115e5@linux-foundation.org>
Organization: http://mina86.com/
References: <1410471576-12053-1-git-send-email-mina86@mina86.com> <1410471576-12053-2-git-send-email-mina86@mina86.com> <20140912154013.47dad90e7519146c6da115e5@linux-foundation.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140912:jeffrey.t.kirsher@intel.com::c2wZrh4nxI2VCW71:00000000000000000000000000000000001Gp3
X-Hashcash: 1:20:140912:mark.d.rustad@intel.com::9sr6xfe9TLhSWe7A:000000000000000000000000000000000000002Bm9
X-Hashcash: 1:20:140912:linux-kernel@vger.kernel.org::4Cv5s6b6o/dH6CWz:0000000000000000000000000000000002SdT
X-Hashcash: 1:20:140912:rostedt@goodmis.org::wDbyJTO2YIhGN/eL:0000000000000000000000000000000000000000002oZb
X-Hashcash: 1:20:140912:hagen@jauu.net::QH7kt2BKO9bn2Alu:0004ouw
X-Hashcash: 1:20:140912:akpm@linux-foundation.org::db2wX8ph4wMVNMcx:0000000000000000000000000000000000004GJu
Date: Sat, 13 Sep 2014 01:37:40 +0200
Message-ID: <xa1tppf0xvej.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 11 Sep 2014 23:39:36 +0200 Michal Nazarewicz <mina86@mina86.com> wrote:
>
>> Because min and max macros use the same variable names no matter
>> how many times they are called (or how deep the nesting of their
>> calls), each time min or max calls are nested, the same variables
>> are declared.  This is especially noisy after min3 and max3 have
>> been changed to nest min/max calls.
>> 
>> Using __COUNTER__ solves the problem since each variable will get
>> a unique number aadded to it.  The code will still work even if
>> the compiler does not support __COUNTER__, but then the protection
>> from shadow warning won't work.
>> 
>> The same applies to min_t and max_t macros.
>> 
>> ...
>>
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -695,15 +695,27 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>>  #endif /* CONFIG_TRACING */
>>  
>>  /*
>> + * Preprocessor magic generating unique identifiers to avoid -Wshadow warnings
>> + * used by min, max, min_t and max_t macros.  cnt is __COUNTER__, op is the
>> + * comparison operator; tx (ty) is type of the first (second) argument,
>> + * xx (yy) is name of a temporary variable to hold the first (second) argument,
>> + * and x (y) is the first (second) argument.
>> + */
>> +#define _min_max_var(cnt, base) _mm_ ## cnt ## base
>> +#define _min_max__(op, tx, xx, x, ty, yy, y) ({		\
>> +	tx xx = (x);					\
>> +	ty yy = (y);					\
>> +	(void) (&xx == &yy);				\
>> +	xx op yy ? xx : yy; })
>> +#define _min_max_(cnt, op, tx, x, ty, y)		\
>> +	_min_max__(op, tx, _min_max_var(cnt, a), x, ty, _min_max_var(cnt, b), y)
>> +#define _min_max(...) _min_max_(__COUNTER__, __VA_ARGS__)
>
> The fact that __COUNTER__ is used in compiler-gcc4.h but not in
> compiler-gcc3.h makes me suspicious about its availability?

http://gcc.gnu.org/ml/gcc-patches/2007-05/msg01579.html so looks like it
has 7 years.  But as the commit message says, the code will still work,
even w/o working __COUNTER__.

> I do think that [1/2] made the code significantly worse-looking

Oh?  I actually thought [1/2] makes it nicer by having a single place
where the min/max logic is implemented.

> and this one is getting crazy.  How useful is W=2 anyway?

I actually do agree with that.  I didn't have high hopes about getting
this patch accepted, but wanted to send it out to show that it can be
done, if it's really deemed useful.

> Has anyone found a bug using it?  The number of warnings in default
> builds is already way too high :(

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
