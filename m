Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3KPCDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 21:03:09 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:43196 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3KPCDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 21:03:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131110122638.GA17775@pd.tnic>
References: <20131110122638.GA17775@pd.tnic>
Date: Fri, 15 Nov 2013 18:02:59 -0800
Message-ID: <CAADWXX_FdW4vGn8N4TA_GcNBrwuqeH_=qxmK2J7K7kfAWztxPA@mail.gmail.com>
Subject: Re: [GIT PULL] A minor amd64_edac fix for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This was in my spam collection. I don't quite know why, but it might
signify problems with your email setup. Quite often, when gmail is
unhappy about kernel developer emails, it's been because their email
provider ends up doing something odd.

But the headers actually have "spf=pass" and "dkim=pass", so it's
nothing obvious. ]

That said, I don't much like the patch either. The "fixed' version
looks worse than the original. If it's an unsigned type, no extra code
will be generated, and if it's a signed type, it's correct. In either
way, the code looks good, and the range test means that people reading
it don't even need to worry about whether the type is signed or not.

If this patch was written because of some f*cking broken compiler
warning, then just tell the compiler to shut the hell up about it.
This is a clear example of where compiler warnings are actually making
things worse.

             Linus


On Sun, Nov 10, 2013 at 4:26 AM, Borislav Petkov <bp@alien8.de> wrote:
> Hi Linus,
>
> please pull this one minor thing which has been lying around since
> forever... (at least it feels like it - I almost forgot about it :-)).
>
> Thanks.
>
> --
> The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:
>
>   Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.13
>
> for you to fetch changes up to c3e511e4c4d9cb962976f63d37816ff8e8efacc5:
>
>   amd64_edac: Remove superfluous condition check. (2013-09-19 09:55:20 +0200)
>
> ----------------------------------------------------------------
> A minor correctness fix.
>
> ----------------------------------------------------------------
> Aravind Gopalakrishnan (1):
>       amd64_edac: Remove superfluous condition check.
>
>  drivers/edac/amd64_edac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 3c9e4e98c651..bbd1913ce27c 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1576,7 +1576,7 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>                                              num_dcts_intlv, dct_sel);
>
>         /* Verify we stay within the MAX number of channels allowed */
> -       if (channel > 4 || channel < 0)
> +       if (channel > 4)
>                 return -EINVAL;
>
>         leg_mmio_hole = (u8) (dct_cont_base_reg >> 1 & BIT(0));
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
