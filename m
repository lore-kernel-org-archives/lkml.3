Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaFPMWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:22:21 -0400
Received: from mx0b-00176a03.pphosted.com ([67.231.157.48]:38289 "EHLO
	mx0b-00176a03.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbaFPMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:22:20 -0400
X-Greylist: delayed 9289 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 08:22:20 EDT
Message-ID: <539EBD2D.9030504@ge.com>
Date: Mon, 16 Jun 2014 10:47:25 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: nick <nickkrause@sympatico.ca>
CC: <manohar.vanga@gmail.com>, <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <dan.carpenter@oracle.com>
Subject: =?UTF-8?B?UmU6IFBBVENIW1t2bWUvYnJpZGdlcy92bWVfY2E5MWN4NDIuYzoxMzg=?=
 =?UTF-8?B?MjogQmFkIGlmIHRlc3QgQnVnIEZpeF3igI/igI8=?=
References: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl>
In-Reply-To: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [3.159.212.191]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-15_03:2014-06-13,2014-06-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1406160097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

Sorry for the delay in responding.

I'm staring at the manual for the ca91c142 and the relevant bits in the 
VSIx_CTL registers definitely need to be set to 0 for A16, likewise with 
the LM_CTL register. The pattern (3<<16) would enable one of the 
"reserved" address spaces.

Martyn

On 12/06/14 15:33, nick wrote:
> Here is the fixed patch. Having issues with using Thunderbird
> so just used Evolution for now.
> Nick
> --- drivers/vme/bridges/vme_ca91cx42.h.orig	2014-06-11 22:50:29.339671939 -0400
> +++ drivers/vme/bridges/vme_ca91cx42.h	2014-06-11 23:15:36.027685173 -0400
> Fixes bug issues with wrong bus width in if statments in vme_ca91cx42.c
> Signed-off-by: Nicholas Krause <nickkrause@sympatico.ca>
> @@ -526,7 +526,7 @@ static const int CA91CX42_LINT_LM[] = {
>   #define CA91CX42_VSI_CTL_SUPER_SUPR	(1<<21)
>
>   #define CA91CX42_VSI_CTL_VAS_M		(7<<16)
> -#define CA91CX42_VSI_CTL_VAS_A16	0
> +#define CA91CX42_VSI_CTL_VAS_A16	(3<<16)
>   #define CA91CX42_VSI_CTL_VAS_A24	(1<<16)
>   #define CA91CX42_VSI_CTL_VAS_A32	(1<<17)
>   #define CA91CX42_VSI_CTL_VAS_USER1	(3<<17)
> @@ -549,7 +549,7 @@ static const int CA91CX42_LINT_LM[] = {
>   #define CA91CX42_LM_CTL_SUPR		(1<<21)
>   #define CA91CX42_LM_CTL_NPRIV		(1<<20)
>   #define CA91CX42_LM_CTL_AS_M		(5<<16)
> -#define CA91CX42_LM_CTL_AS_A16		0
> +#define CA91CX42_LM_CTL_AS_A16		(3<<16)
>   #define CA91CX42_LM_CTL_AS_A24		(1<<16)
>   #define CA91CX42_LM_CTL_AS_A32		(1<<17)
>
>
>

-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
