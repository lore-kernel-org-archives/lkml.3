Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaJWHtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:49:22 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:51189 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaJWHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:49:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com,
        linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
        gorcunov@openvz.org
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Thu, 23 Oct 2014 09:49:14 +0200
Message-ID: <2940943.qiYEMaLEXx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3m9qsP7tjXTQ645ClUHk8D7SvzZCIiNG31orWI+gygC
 7Mlv3xZX2QI22z0Ra3lf5sRoRo7x6IQAoyTMIFv7SvPKPGYZr5
 QSLhbbMadxjT53AwHVJNPU68ovsDOjSunasnjlyJAvAOQ1aJKz
 M9pRGUIrQcILlQYBkutL/K6KQqZpScO6dYuf5Scr8RuxNSb+U0
 g6mGJXae4lLUKA1/S4+FYjeQ94+7HePVjJi/kfSv9QHCi29dDs
 4mZALHtIxLAjHU+Pr57J3ZZTkTNF0FfPV5k+LYv1P8bOOZt1cM
 Lp9Z+XA1wLFAbs+EgKruy6DDv8PgQ6L8T1Liq5m60y6r4c6Nxn
 GfRhPFSeUbvyayl22GEw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2014 16:07:12 Michael Ellerman wrote:
> --- a/include/linux/kcmp.h
> +++ b/include/linux/kcmp.h
> @@ -1,17 +1,6 @@
>  #ifndef _LINUX_KCMP_H
>  #define _LINUX_KCMP_H
>  
> -/* Comparison type */
> -enum kcmp_type {
> -       KCMP_FILE,
> -       KCMP_VM,
> -       KCMP_FILES,
> -       KCMP_FS,
> -       KCMP_SIGHAND,
> -       KCMP_IO,
> -       KCMP_SYSVSEM,
> -
> -       KCMP_TYPES,
> -};
> +#include <uapi/linux/kcmp.h>
>  
>  #endif /* _LINUX_KCMP_H */
> 

If the file is empty except for the uapi include, I think it's better to
delete it completely. The include path logic should ensure we pick the
other one up.

	Arnd
