Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3IXKdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:33:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16731 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3IXKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:33:40 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-0c-52416a82991f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, m.chehab@samsung.com,
        t.figa@samsung.com, kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: s5p-tv: Replace mxr_ macro by default dev_
Date: Tue, 24 Sep 2013 12:33:34 +0200
Message-id: <1583471.Ys4OY3iSLA@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <52415ED9.3030407@samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <13162989.WhfDRzW6dg@amdc1032> <52415ED9.3030407@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jAd3mLMcggx4ri7NNb9gtNj2+xmpx
	edccNoueDVtZLS6uk7c4veYUs8XhN+2sFutnvGaxmNf+ktWB02PzknqPg+/2MHn0bVnF6PF5
	k1wASxSXTUpqTmZZapG+XQJXxtUDSxgLGuUrJrfNZ21gXCLRxcjBISFgInHln38XIyeQKSZx
	4d56ti5GLg4hgUWMEpd6LrBCOC1MEgteHGICqWITsJKY2L6KEcQWETCSONLewwhSxCzwk1Fi
	8oxDbCAJYQFficvn77OD2CwCqhJbH+wBa+AV0JT4tu4FK4gtKuAp8WnSUmYQm1NAW+LU8i1M
	ENt6GSUOLf7IDtEgKPFj8j0WEJtZQF5i3/6prBC2jsT+1mlsExgFZiEpm4WkbBaSsgWMzKsY
	RVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoP9mdQOxpUNFocYBTgYlXh4d3g7BAmxJpYVV+Ye
	YpTgYFYS4b1h6xgkxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJ
	g1OqgdHN95Cimlb9tB8MPW9OGOTOWLFfo8h2uckWZZbUqlyuS3xvejYviZ3aeq/plVLGqU/Z
	r30v1kel7O3Q+/1Zlj06atlqjvfZh/cUOIZcj3SySNOd1bhe/dOz4xYcdtFXnNsnz7I3OCQ6
	9fa1e61fzZf+TQz2XLZgc+8W6Yn13/qXmZfKXX7hkqLEUpyRaKjFXFScCABjieefcgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tomasz,

On Tuesday, September 24, 2013 11:43:53 AM Tomasz Stanislawski wrote:
> Hi,
> 
> On 09/23/2013 05:48 PM, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi Tomasz,
> > 
> > On Monday, September 23, 2013 04:50:01 PM Tomasz Stanislawski wrote:
> >> Hello,
> >> May I ask what is the rationale for this patch?
> >> To reduce a few lines of code?
> > 
> > This patch makes source code more generic-like and easier to follow (mxd_r*
> 
> more generic(-like?) - NOT. Using mxr_ macros is a more generic way to produce logs

Using mxr_* macros is not more generic, don't be silly. :)

> because one can change only one line to change error format for the whole module.
> For example, in case of mxr_ family, a patch adding function name to debug message
> would require just a few lines patch. Using in case of dev_ family, one has to
> produce 200-lines of highly conflicting patch.

* For over two and half year since the s5p-tv driver introduction there was no such
  need and it is very _unlikely_ that it will be one in the future.

* Optimizing for the completely _theorethical_ future patches size is just
  over-enginneering IMHO.

> 'easier to follow' - MAYBE. I agree that some people may prefer to
> see more directly what is happening, but tell me if you really consider line:
> 
> mxr_dbg(mdev, "this is debug\n");
> 
> as a very confusing and obfuscated piece of code.
> 
> COME ON!

It is confusing becuase you have to lookup what mxr_dbg() actually does,
extra time needs to be spent on seeing that the mxr_* macros are just
a needless wrappers. You also have to recall it from the memory or look it
up again if you come back to the code some time later. Just stop arguing
about this trivial change and Ack Mateusz's patch already. :)

PS Please try to not top post, thanks.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Regards,
> TS
> 
> > macros currently only obfuscate the code and make them harder to read for
> > everybody, maybe besides the original driver author ;). Removal of few
> > superfluous lines of code is just a bonus.
> > 
> >> Or to give up possibility of changing message format in just one place?
> > 
> > For over two and half year (since s5p-tv driver introduction in Feb 2011)
> > such change was not needed and it doesn't seem that keeping the code to
> > allow such possibility is worth an added code obfuscation.
> > 
> > Besides you can easily script a change to message format so in practice
> > I don't see a real advantage of keeping non-standard messaging macros
> > just for easing a potential message format conversion.
> > 
> >> I could see migrating from mxr_* to pr_* could seen as the fix, but not this.
> > 
> > Such migration seems to be pointless as you would have to add an extra
> > argument to pr_* to not lose the device information.
> 
> There is something called pr_fmt. It may help with mentioned issue.
> 
> > 
> 
> 
> 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> > 
> >> Waiting for reply,
> >> Tomasz Stanislawski
> >>
> >>
> >> On 09/21/2013 05:00 PM, Mateusz Krawczuk wrote:
> >>> Replace mxr_dbg, mxr_info and mxr_warn by generic solution.
> >>>
> >>> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> >>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>> ---
> >>>  drivers/media/platform/s5p-tv/mixer.h           |  12 ---
> >>>  drivers/media/platform/s5p-tv/mixer_drv.c       |  47 ++++++-----
> >>>  drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
> >>>  drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
> >>>  drivers/media/platform/s5p-tv/mixer_video.c     | 100 ++++++++++++------------
> >>>  drivers/media/platform/s5p-tv/mixer_vp_layer.c  |   2 +-
> >>>  6 files changed, 78 insertions(+), 91 deletions(-)
> >>>

