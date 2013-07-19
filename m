Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab3GSH1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:27:52 -0400
Received: from mout.gmx.net ([212.227.15.18]:50601 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759790Ab3GSH1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:27:50 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/72] 3.10.2-stable review
References: <20130719052559.852627424@linuxfoundation.org>
Date: Fri, 19 Jul 2013 09:27:46 +0200
In-Reply-To: <20130719052559.852627424@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Thu, 18 Jul 2013 22:25:17 -0700")
Message-ID: <8761w7dn65.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K0:tqRJFB8FpgLzvuZhTRDw/0Ld9xH1UfBf3DldvUZbj87z9InxsuM
 WnqXYqeVpxSlU+c4vTAjeKWePiJSl9YNpI/obZlxj6zwIwKi5Ek7fSpOIObSrrbNDGWEGP8
 8ptv2Zmyo04WU5tW1ry2XrWsroxInM8HNC9/4GDNd/drX+p4c2LhTlJXDS//Af3FvaFr3jx
 fV2hw42lFAMLXbRlHVcrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-07-19 07:25 +0200, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 3.10.2 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul 21 05:25:08 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc1.gz

I've spent just half an hour trying to figure out why this kernel failed
to install with an incomprehensible error message:

,----
|  BUILDDEB
| rm: invalid option -- 'c'
| Try `rm --help' for more information.
| make[2]: *** [_modinst_] Error 1
`----

It turned out that there's a trailing space in the 

SUBLEVEL = 2 

line in the Makefile, and that extra space ends up in MODLIB, finally
passing the 'rm' command _two_ parameters rather than one, the second
starting with "-rc1".

Cheers,
       Sven
