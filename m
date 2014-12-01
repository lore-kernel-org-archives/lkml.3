Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaLAMTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:19:15 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:60547 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaLAMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:19:13 -0500
Message-ID: <547C5CBC.6060607@cogentembedded.com>
Date: Mon, 01 Dec 2014 15:19:08 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/3] net-PPP: Deletion of unnecessary checks before the
 function call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net>
In-Reply-To: <547B496E.604@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/30/2014 7:44 PM, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 30 Nov 2014 17:02:07 +0100

> The kfree() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

> This issue was detected by using the Coccinelle software.

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/net/ppp/ppp_mppe.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)

> diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
> index 911b216..7e44212 100644
> --- a/drivers/net/ppp/ppp_mppe.c
> +++ b/drivers/net/ppp/ppp_mppe.c
> @@ -238,8 +238,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
>   	return (void *)state;
>
>   	out_free:
> -	    if (state->sha1_digest)
> -		kfree(state->sha1_digest);
> +	kfree(state->sha1_digest);

    Please keep this line aligned to the others.

>   	    if (state->sha1)
>   		crypto_free_hash(state->sha1);
>   	    if (state->arc4)

[...]

WBR, Sergei

