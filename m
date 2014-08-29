Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaH2R0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:26:32 -0400
Received: from smtp104.biz.mail.gq1.yahoo.com ([98.137.12.179]:33564 "EHLO
	smtp104.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693AbaH2R0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:26:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4jwt0CAVM1lQfhVNDdvm7zgSt6mBFI44cAtHZ5JIap2SHun
 F4uSp88K3cPPj7JP8M.mRGW8CG0_FMNeND_6vVjHpWNb_.ruhZA0KxX_LqAi
 Uhp7oSD57OuyumhYuMETQ.jzpPTzh1RPYAwrgolp_TlJCnmTd9VMRmPNE48P
 HEaHT_ZI06crdGKlQAuPrsPmRzWmSzf_dqw7uTw_G9GNHTKguWBrJP7RqTBm
 W6Z0rvd_i01yud.k88t0AFEh1gG9CV_MPUWcrsEOLyc7uKcKqLPhUr_14cod
 pfCoWqQ2RwCepa.c8jLtIB5ntLKy0m0qBNwtRw7_4t9jS1B5pOIh8RjvJL7k
 Ss5vwHKEECJcs9VePWIja6wnztty7vd94Fmu38FbFCRAo2np1rncwi60Kw4s
 Yr09ZtcT.WROFlul.7PSbJl4RSk8RT.RzFQDwFnBwcBDKPyEnlX6VDYNXpEv
 _JF1iTKtczlUt.KQPRfQAzBe8F0qPlxyiHbwCcAsty3xbwjLU8q0mx4R9dsU
 _crmRgcJszEaCCIiamfoSvoerJZCYhWv4aLgcy8ASnD2tFw0oKPe0p9Rn_.S
 afKE0l6R1YO7X7mJeZtNy_ILppiA5V8aMOSKnVwucz3Y2nIg402Kk1cMHe5.
 p7dMnn2MDFg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <5400B637.1060303@schaufler-ca.com>
Date: Fri, 29 Aug 2014 10:19:51 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>, r.krypa@samsung.com,
        havner@gmail.com, m.lis@samsung.com,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/3] Fix a bidirectional UDS connect check typo
References: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com> <1409324575-12057-2-git-send-email-l.pawelczyk@samsung.com>
In-Reply-To: <1409324575-12057-2-git-send-email-l.pawelczyk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2014 8:02 AM, Lukasz Pawelczyk wrote:
> The 54e70ec5eb090193b03e69d551fa6771a5a217c4 commit introduced a
> bidirectional check that should have checked for mutual WRITE access
> between two labels. Due to a typo the second check was incorrect.
>
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.18

> ---
>  security/smack/smack_lsm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 478d99e..00443a9 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3302,8 +3302,8 @@ static int smack_unix_stream_connect(struct sock *sock,
>  		rc = smk_bu_note("UDS connect", skp, okp->smk_known,
>  					MAY_WRITE, rc);
>  		if (rc == 0) {
> -			rc = smk_access(okp, okp->smk_known, MAY_WRITE, NULL);
> -			rc = smk_bu_note("UDS connect", okp, okp->smk_known,
> +			rc = smk_access(okp, skp->smk_known, MAY_WRITE, NULL);
> +			rc = smk_bu_note("UDS connect", okp, skp->smk_known,
>  						MAY_WRITE, rc);
>  		}
>  	}

