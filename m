Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab3DDNC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:02:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955Ab3DDNC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:02:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 18/18] cpufreq: powerpc/platforms/cell: move cpufreq driver to drivers/cpufreq
Date: Thu, 4 Apr 2013 13:02:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: rjw@sisk.pl, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1365079581.git.viresh.kumar@linaro.org> <0f989533f2e47d4d632710029bf0273082bafee3.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <0f989533f2e47d4d632710029bf0273082bafee3.1365079581.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304041302.09995.arnd@arndb.de>
X-Provags-ID: V02:K0:qN8EVUHv/JYE9dLKH1+KnmTYaFt3902hfWgxFdDB8Vr
 +QGSjD8Awr1k+uMgnyX3KsqHseI8RoCHpSdCV9FotrWJ4KR3W2
 /RQqBtOIvX793yWZ4SCgPxveQXnf7ZceHnm+xbsA22gjTQykvx
 ApTsP9lDlzuH1koefdSjhvNbhSHxbQrmmcPukKql1OQ1qQYEat
 9hJqdtYu35gPelW61zFkQ0Ck13Lpf4vRpVSdlYfzFoW7cjlGGQ
 To3OAkYkkxoADmcGXrx/U6WEoM25ZrJblERGm8ltEx0pwrct1o
 c5XqroauzQqHRX0ycO6mdaRN9wRcBuBip+kbeqJc/7QNzRijUi
 P072eKIrXBDTg1dnLPC8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 April 2013, Viresh Kumar wrote:
> This patch moves cpufreq driver of powerpc platforms/cell to drivers/cpufreq.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Compile Tested only.
> 
>  arch/powerpc/platforms/cell/Kconfig                | 26 +---------------------
>  arch/powerpc/platforms/cell/Makefile               |  3 ---
>  drivers/cpufreq/Kconfig.powerpc                    | 18 +++++++++++++++
>  drivers/cpufreq/Makefile                           |  3 +++
>  .../cpufreq/ppc_cbe_cpufreq.c                      |  2 +-
>  .../cpufreq/ppc_cbe_cpufreq_pervasive.c            |  3 +--
>  .../cpufreq/ppc_cbe_cpufreq_pmi.c                  |  3 +--
>  .../linux/ppc_cbe_cpufreq.h                        |  4 ++--

Moving the files is good, but I don't see a reason to make the cbe_cpufreq.h
header globally visible in include/linux/. Isn't it just used by as the
interface between ppc_cbe_cpufreq_pmi.c  and ppc_cbe_cpufreq.c?

	Arnd
