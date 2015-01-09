Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbbAIRZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:25:09 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:31656 "EHLO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757914AbbAIRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:25:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7xG1siYVM1nH1qOroPacOw1r0rcXHhc3QQE2rYNWo_OZYYl
 oQ3QjCI5A5e8mfo2lMfLGvgzCX3JC5H9XSGY.QRb9lNkSBDeicQTSmxV45Ue
 U3N1MXyuL1Wgmrx2_CxqGMooe3jbkC8f3DXq5FQkg3LUMJHlK8WgrpLDdjfq
 fR.SrkEQuoz_2ASfpn45_2ruzgQ0MH8nlmF2OamjY4mdaT87z1l.7hzr5v32
 p2BQZRhZlX0AZoaJWEnU9yQ6M9LA9j8DoZR4zfGkuau_dEiFCJzJ.CBZFs0C
 _OG.rTt2NTiYSO9qZA7Odo2iZQ2mhkO7f8uGiQlheyZYMidIvXGlyBwoSLxj
 l6nhZilEdxC18aysbaeuYF7CD6xj.eoRGO0b5SXEFrQUVfPPh11okKq_0Bh0
 .c6o43BCabhBBelbK83j0WPYtne9iPD27kTzI1VcuJRHLLT3uXB4GkeFSqSq
 Z.q3Et0XmWX7lgdpXZCMlCbMxfDtyU9Wov47lLZz3tOsF1Jk5NQ0JmG4jpyp
 FwYJCyzgfDFfHyBcujeHadbpjMPSqhtWl5NsnaR8pJmwsY_84bjWkEpuLTzH
 MFHQquLh65.iGgjthCTQL8IEmQKqPjXXUGujWbnTs0Q86MZo5ERvDfG4O.x6
 Qo47WbvPabRDL
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54B00EE8.4050606@schaufler-ca.com>
Date: Fri, 09 Jan 2015 09:24:56 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] smack: Add missing logging in bidirectional UDS connect
 check
References: <1420739565-11392-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1420739565-11392-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2015 9:52 AM, Rafal Krypa wrote:
> During UDS connection check, both sides are checked for write access to
> the other side. But only the first check is performed with audit support.
> The second one didn't produce any audit logs. This simple patch fixes that.
>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.20

> ---
>  security/smack/smack_lsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 8716ade..a688f7b 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3333,7 +3333,7 @@ static int smack_unix_stream_connect(struct sock *sock,
>  		if (rc == 0) {
>  			okp = osp->smk_out;
>  			skp = ssp->smk_in;
> -			rc = smk_access(okp, skp, MAY_WRITE, NULL);
> +			rc = smk_access(okp, skp, MAY_WRITE, &ad);
>  			rc = smk_bu_note("UDS connect", okp, skp,
>  						MAY_WRITE, rc);
>  		}

