Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaFWQDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:03:08 -0400
Received: from fujitsu24.fnanic.fujitsu.com ([192.240.6.14]:44541 "EHLO
	fujitsu24.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbaFWQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:03:06 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 23 Jun 2014 09:01:26 -0700
Subject: RE: [patch 1/4] mm: vmscan: remove remains of kswapd-managed
 zone->all_unreclaimable
Thread-Topic: [patch 1/4] mm: vmscan: remove remains of kswapd-managed
 zone->all_unreclaimable
Thread-Index: Ac+OqoctGGa5QHFPRgSnQYTA39zWrgAUc1pw
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E341D40237A@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
 <20140623061604.GA15594@bbox>
In-Reply-To: <20140623061604.GA15594@bbox>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-23_07:2014-06-23,2014-06-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5NG3Ch2020616



> -----Original Message-----
> From: Minchan Kim [mailto:minchan@kernel.org]
> Sent: Monday, June 23, 2014 2:16 AM
> To: Johannes Weiner
> Cc: Andrew Morton; Mel Gorman; Rik van Riel; Michal Hocko; linux-mm@kvack.org; linux-kernel@vger.kernel.org; Motohiro Kosaki JP
> Subject: Re: [patch 1/4] mm: vmscan: remove remains of kswapd-managed zone->all_unreclaimable
> 
> On Fri, Jun 20, 2014 at 12:33:47PM -0400, Johannes Weiner wrote:
> > shrink_zones() has a special branch to skip the all_unreclaimable()
> > check during hibernation, because a frozen kswapd can't mark a zone
> > unreclaimable.
> >
> > But ever since 6e543d5780e3 ("mm: vmscan: fix do_try_to_free_pages()
> > livelock"), determining a zone to be unreclaimable is done by directly
> > looking at its scan history and no longer relies on kswapd setting the
> > per-zone flag.
> >
> > Remove this branch and let shrink_zones() check the reclaimability of
> > the target zones regardless of hibernation state.
> >
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Minchan Kim <minchan@kernel.org>
> 
> It would be not bad to Cced KOSAKI who was involved all_unreclaimable series several time with me.

Looks good to me.

KOSAKI Motohiro <Kosaki.motohiro@jp.fujitsu.com>




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
