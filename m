Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaKFM3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:29:51 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47269 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaKFM3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:29:47 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org,
        Laura Abbott <lauraa@codeaurora.org>, iamjoonsoo.kim@lge.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: CMA alignment question
In-Reply-To: <CAL1ERfMk+rhd=-MaLC2VVj61-T17_SVgKL4=Z_okhEYktFJ+tQ@mail.gmail.com>
Organization: http://mina86.com/
References: <CADtm3G7DtGkvPk36Fiunwen8grw-94V6=iv82iusGumfNJkn-g@mail.gmail.com> <xa1tlhnq7ga7.fsf@mina86.com> <CADtm3G7bU6Y2aKco5Vb81KSqsy=FH9zmdDJm=Tixjoep1YeJ7Q@mail.gmail.com> <CAL1ERfMYmQcQ_sX7E0HC2bXmC-imh4T-7Q4nBVQRXkQSaTjvQQ@mail.gmail.com> <xa1tsihxwblf.fsf@mina86.com> <CAL1ERfMk+rhd=-MaLC2VVj61-T17_SVgKL4=Z_okhEYktFJ+tQ@mail.gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141106:computersforpeace@gmail.com::imo6baGjTetVhdxZ:000000000000000000000000000000000010oc
X-Hashcash: 1:20:141106:weijie.yang.kh@gmail.com::ja/8IucDv93hemnm:00000000000000000000000000000000000001WMW
X-Hashcash: 1:20:141106:gregory.0xf0@gmail.com::piOFRXeXe8IwZKCQ:0000000000000000000000000000000000000001ehv
X-Hashcash: 1:20:141106:linux-mm@kvack.org::gMYJlw7bECsDFxJT:00000000000000000000000000000000000000000003fXQ
X-Hashcash: 1:20:141106:f.fainelli@gmail.com::3BIaEFSJYKShqU3v:000000000000000000000000000000000000000005/cW
X-Hashcash: 1:20:141106:iamjoonsoo.kim@lge.com::AxBy/rgy3O8CNTMp:0000000000000000000000000000000000000005r+t
X-Hashcash: 1:20:141106:m.szyprowski@samsung.com::/+5ruf+y4N7/vs0c:0000000000000000000000000000000000000B51G
X-Hashcash: 1:20:141106:linux-kernel@vger.kernel.org::7oaSyoHz457/6G8P:000000000000000000000000000000000An5c
X-Hashcash: 1:20:141106:lauraa@codeaurora.org::TUlm//kdQO62MPka:0000000000000000000000000000000000000000HmI1
Date: Thu, 06 Nov 2014 13:29:42 +0100
Message-ID: <xa1td290ikax.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06 2014, Weijie Yang <weijie.yang.kh@gmail.com> wrote:
> I agree the current code doesn't handle this issue properly.
> However, I prefer to add specific usage to CMA interface rather than
> modify the cma code, Because the latter hide the issue and could waste
> memory.

cma_alloc should handle whatever alignment caller uses.  Sure, if CMA
area has smaller alignment this may lead to wasted memory, but so can
allocation with small alignment followed by allocation with big
alignment.

If you're saying that platform should try to get the CMA area aligned
such that no alignment offset happens I agree.  If you're saying that
cma_alloc should fail (to properly align) an allocation request,
I disagree.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
