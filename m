Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887Ab3BTAVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:21:31 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43593 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab3BTAV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:21:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130220001743.GE16950@blaptop>
References: <20130219044012.GA23356@lizard.sbx00618.mountca.wayport.net>
	<20130220001743.GE16950@blaptop>
Date: Tue, 19 Feb 2013 16:21:28 -0800
X-Google-Sender-Auth: kTtwYM8x_mNs1muKVwXf63LT_Lg
Message-ID: <CAOS58YOPjcH_pFFhPLJEAdaLkm5FoOy9mG2i-PkWAcb7O6V_Kw@mail.gmail.com>
Subject: Re: [PATCH v2] memcg: Add memory.pressure_level events
From: Tejun Heo <tj@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, cgroups@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 19, 2013 at 4:17 PM, Minchan Kim <minchan@kernel.org> wrote:
> Should we really enable memcg for just pressure notificaion in embedded side?
> I didn't check the size(cgroup + memcg) and performance penalty but I don't want
> to add unnecessary overhead if it is possible.
> Do you have a plan to support it via global knob(ie, /proc/mempressure), NOT memcg?

That should be handled by mempressure at the root cgroup. If that adds
significant amount of overhead code or memory-wise, we just need to
fix root cgroup handling in memcg. No reason to further complicate the
interface which already is pretty complex.

Thanks.

-- 
tejun
