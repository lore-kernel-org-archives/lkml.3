Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3GXPuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:50:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30858 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3GXPun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:50:43 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-ba-51eff7d143c4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, devel@driverdev.osuosl.org,
        konrad.wilk@oracle.com, Piotr Sarna <p.sarna@partner.samsung.com>,
        linux-kernel@vger.kernel.org, bob.liu@oracle.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Cristian =?ISO-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Subject: Re: [PATCH] zcache: fix "zcache=" kernel parameter
Date: Wed, 24 Jul 2013 17:50:29 +0200
Message-id: <5294696.DFxsrtntLy@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1940908.YDS0uX8aZx@amdc1032>
References: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
 <20130724150627.GF15095@kroah.com> <1940908.YDS0uX8aZx@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9jAd2L398HGvzp07XoOjWVxeLev2lM
	FnvO/GK3aF68ns1i2eKnjBZnm96wW1zeNYfN4lXzd1aLVYuiHDg97u07zOKxf+4ado9jJ1+y
	enx8eovF4+C7PUwefVtWMXqcWXCE3ePzJrkAjigum5TUnMyy1CJ9uwSujINTHrEWTNKpuPxs
	D3sD43rlLkZODgkBE4mDO78wQthiEhfurWfrYuTiEBJYxChx79cKdginhUliy9+DzCBVbAJW
	EhPbV4F1iAhoSLw8eosFpIhZYDmTxP2+XywgCWEBa4njBx6CNbAIqEp82nmZFcTmFdCUeHNk
	HlizqICrxLlFP8DqOQW0JFbeaIJa3ccosfjAAqgGQYkfk++BFTELaEs8eXeBFcLWkej9/o15
	AqPALCRls5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGw8k9rBuLLB4hCj
	AAejEg9vwax3gUKsiWXFlbmHGCU4mJVEeN8+eB8oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdA
	q3WgkEB6YklqdmpqQWoRTJaJg1OqgVFMYbqjsWA9g+SJslrrdcZLrmh0XE9d/jPWvUv4/tON
	925UXAz4Gn5ob9f/zcqfa99P+vz1XOCye1/Kvr3hzcoqq+G/FOs/O6k0iD1cYcHkA/1iwact
	Ur//3Dq/9p+L7d7uNyqLL0Z5bSm9d/5H0rpvOxZeWfzR5sde1WebUzSO7HVet/XKNbkpSizF
	GYmGWsxFxYkApujJaIkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday, July 24, 2013 05:39:20 PM Bartlomiej Zolnierkiewicz wrote:
> 
> On Wednesday, July 24, 2013 08:06:27 AM Greg KH wrote:
> > On Wed, Jul 24, 2013 at 01:54:56PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > On Wednesday, July 24, 2013 01:41:57 PM Michal Hocko wrote:
> > > > On Wed 24-07-13 12:32:32, Bartlomiej Zolnierkiewicz wrote:
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > On Wednesday, July 24, 2013 12:04:41 PM Michal Hocko wrote:
> > > > > > On Wed 24-07-13 12:02:35, Michal Hocko wrote:
> > > > > > > I have posted a similar fix quite some time ago and I guess Greg should
> > > > > > > already have it.
> > > > > > 
> > > > > > For reference https://lkml.org/lkml/2013/6/26/410
> > > > > 
> > > > > There was a reply from Greg:
> > > > > 
> > > > > 	https://lkml.org/lkml/2013/6/26/410
> > > > 
> > > > I guess you meant https://lkml.org/lkml/2013/6/26/569
> > > 
> > > Uh, yes.
> > > 
> > > > > and it seems that Greg's request has not been fullfilled.
> > > > 
> > > > Bob Liu has resent the patch (I cannot find the email in the archive).
> > > 
> > > Indeed, I've found it here:
> > > 
> > > http://comments.gmane.org/gmane.linux.kernel.mm/102484
> > > 
> > > > > Anyway Piotr's patch seems to be more complete:
> > > > > - it also fixes case in which invalid "zcache=" option is given (returns
> > > > >   an error value 1 while with your patch the code still erronously retuns 0)
> > > > > - it prints information about compressor type being used when "zcache="
> > > > >   option is used (your patch skips it due to addition of "goto out_alloc")
> > > > 
> > > > I do not care which one will make it I just pointed out that there is
> > > > another patch dealing with the same and it is a question how far that
> > > > one went.
> > > 
> > > OK.
> > > 
> > > Greg, could you please pick Piotr's patch?
> > 
> > Wait, I'm going to take the first one I got, from Michal, as that's the
> > original author here, not Piotr...
> > 
> > confused, and really grumpy about the whole zcache mess...
> 
> Just get the second one (from Piotr) as it is more complete (it fixes
> also problem with invalid data being given to "zcache=" option or chosen
> compressor not being supported by Crypto API).
> 
> I feel a bit sad that this newer patch makes Michal's one obsolete but
> I don't have a good idea how to resolve it in other way while sticking to
> "chose the best technical solution" principle. :(
> 
> Oh, wait. I updated patch (attached below) to give Michal & Cristian some
> credit (also added Konrad's Acked-by while at it). I hope that this is
> an acceptable solution.

Michal/Cristian, are you fine with that?  Could you please Ack this patch?
 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
> From: Piotr Sarna <p.sarna@partner.samsung.com>
> Subject: [PATCH] zcache: fix "zcache=" kernel parameter

...

This time with fixed Bob's email address and better link to an old
patch. Sorry for that.

From: Piotr Sarna <p.sarna@partner.samsung.com>
Subject: [PATCH] zcache: fix "zcache=" kernel parameter

Commit 835f2f5 ("staging: zcache: enable zcache to be built/loaded as
a module") introduced an incorrect handling of "zcache=" parameter.

Inside zcache_comp_init() function, zcache_comp_name variable is
checked for being empty. If not empty, the above variable is tested
for being compatible with Crypto API. Unfortunately, after that
function ends unconditionally (by the "goto out" directive) and returns:
- non-zero value if verification succeeded, wrongly indicating an error
- zero value if verification failed, falsely informing that function
  zcache_comp_init() ended properly.

A solution to this problem is as following:
1. Move the "goto out" directive inside the "if (!ret)" statement
2. In case that crypto_has_comp() returned 0, change the value of ret
   to non-zero before "goto out" to indicate an error.

This patch replaces an earlier one from Michal Hocko (based on report
from Cristian Rodríguez):

	http://permalink.gmane.org/gmane.linux.kernel.mm/102484

It also addressed the same issue but didn't fix the zcache_comp_init()
for case when the compressor data passed to "zcache=" option was invalid
or unsupported.

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
[bzolnier: updated patch description]
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Bob Liu <bob.liu@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index dcceed2..81972fa 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1811,10 +1811,12 @@ static int zcache_comp_init(void)
 #else
 	if (*zcache_comp_name != '\0') {
 		ret = crypto_has_comp(zcache_comp_name, 0, 0);
-		if (!ret)
+		if (!ret) {
 			pr_info("zcache: %s not supported\n",
 					zcache_comp_name);
-		goto out;
+			ret = 1;
+			goto out;
+		}
 	}
 	if (!ret)
 		strcpy(zcache_comp_name, "lzo");
-- 
1.7.9.5



