Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaKEWB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:01:56 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:48628 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaKEWBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:01:53 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>
Cc: linux-mm@kvack.org, Laura Abbott <lauraa@codeaurora.org>,
        iamjoonsoo.kim@lge.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: CMA alignment question
In-Reply-To: <CAL1ERfMYmQcQ_sX7E0HC2bXmC-imh4T-7Q4nBVQRXkQSaTjvQQ@mail.gmail.com>
Organization: http://mina86.com/
References: <CADtm3G7DtGkvPk36Fiunwen8grw-94V6=iv82iusGumfNJkn-g@mail.gmail.com> <xa1tlhnq7ga7.fsf@mina86.com> <CADtm3G7bU6Y2aKco5Vb81KSqsy=FH9zmdDJm=Tixjoep1YeJ7Q@mail.gmail.com> <CAL1ERfMYmQcQ_sX7E0HC2bXmC-imh4T-7Q4nBVQRXkQSaTjvQQ@mail.gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141105:m.szyprowski@samsung.com::/RmCDym6P+6MMC/K:0000000000000000000000000000000000000085+
X-Hashcash: 1:20:141105:iamjoonsoo.kim@lge.com::jJ1TBS/VKR3WKjRR:0000000000000000000000000000000000000001aM7
X-Hashcash: 1:20:141105:lauraa@codeaurora.org::vnuRBScpsXNmW4m7:00000000000000000000000000000000000000001qHG
X-Hashcash: 1:20:141105:computersforpeace@gmail.com::jtoaP8m7WiRITmH1:000000000000000000000000000000000028nR
X-Hashcash: 1:20:141105:f.fainelli@gmail.com::AToVKL/RlhpDMfCd:000000000000000000000000000000000000000002Ku9
X-Hashcash: 1:20:141105:weijie.yang.kh@gmail.com::BpS1TlfvWYL7RgHA:00000000000000000000000000000000000004Zsq
X-Hashcash: 1:20:141105:linux-mm@kvack.org::3UVVGOd84o/eMvzC:00000000000000000000000000000000000000000003fsR
X-Hashcash: 1:20:141105:gregory.0xf0@gmail.com::w6NV4TD7Y1v5x7AS:0000000000000000000000000000000000000005a9D
X-Hashcash: 1:20:141105:linux-kernel@vger.kernel.org::MacOIKc5kD3pS0FV:0000000000000000000000000000000007qFT
Date: Wed, 05 Nov 2014 23:01:48 +0100
Message-ID: <xa1tsihxwblf.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 04 2014, Gregory Fong wrote:
>> The alignment in cma_alloc() is done w.r.t. the bitmap.  This is a
>> problem when, for example:
>>
>> - a device requires 16M (order 12) alignment
>> - the CMA region is not 16 M aligned

On Wed, Nov 05 2014, Weijie Yang wrote:
> I think the device driver should ensure that situation could not occur,
> by assign suitable alignment parameter in cma_declare_contiguous().

What about default CMA area? Besides, I think principle of least
surprise applies here and alignment should be physical.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
