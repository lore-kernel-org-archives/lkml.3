Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3JRPXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:23:05 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:46509 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3JRPXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:23:04 -0400
Date: Fri, 18 Oct 2013 18:23:01 +0300 (EEST)
From: Joonas Saarinen <jza@saunalahti.fi>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <26801338.9419821382109781265.JavaMail.jza@saunalahti.fi>
Subject: Re: AMD Bobcat cpufreq
MIME-Version: 1.0
Content-Type: text/plain; Charset=iso-8859-1; Format=Flowed
Content-Transfer-Encoding: 7bit
X-Mailer: Saunalahti webmail - http://saunalahti.fi
X-Originating-IP: 80.223.182.224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov [bp@alien8.de] wrote:
> You can also try turbostat in tools/power/x86/turbostat/
> 
> # ./turbostat -i 1

We might be on to something. With work pinned on one core:

cor CPU   GHz  TSC
        1.16 1.00
  0   0 1.17 1.00
  1   1 0.80 1.00

When both cores are occupied:

cor CPU   GHz  TSC
        1.00 1.00
  0   0 1.00 1.00
  1   1 1.00 1.00

In this case both cores are limited to 1GHz, but it might be intentional
to avoid overheating.

So there is some turbo functionality indeed. The frequency shown by 
turbostat is still a bit off the target, not sure if there is any actual
problem though.

Joonas

