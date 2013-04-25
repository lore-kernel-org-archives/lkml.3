Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3DYI5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:57:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab3DYI51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:57:27 -0400
Message-ID: <5178EFF6.50208@suse.cz>
Date: Thu, 25 Apr 2013 10:57:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Korsgaard <jacmet@uclibc.org>
Subject: Re: [PATCH 8/8] kconfig: implement KCONFIG_PROBABILITY for randconfig
References: <cover.1366841993.git.yann.morin.1998@free.fr> <e43956e607692f9b1c710311e4a6591ffba1edf0.1366841993.git.yann.morin.1998@free.fr>
In-Reply-To: <e43956e607692f9b1c710311e4a6591ffba1edf0.1366841993.git.yann.morin.1998@free.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.4.2013 00:29, Yann E. MORIN wrote:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Currently the odds to set each symbol is (rounded):
>     booleans:   y: 50%          n: 50%
>     tristates:  y: 33%  m: 33%  n: 33%
> 
> Introduce a KCONFIG_PROBABILITY environment variable to tweak the
> probabilities (in percentage), as such:
>     KCONFIG_PROBABILITY     y:n split           y:m:n split
>     -----------------------------------------------------------------
> [1] unset or empty          50  : 50            33  : 33  : 34
> [2] N                        N  : 100-N         N/2 : N/2 : 100-N
>     N:M                     N+M : 100-(N+M)      N  :  M  : 100-(N+M)
>     N:M:L                    N  : 100-N          M  :  L  : 100-(M+L)

I did a naive test with the current kconfig branch and with
yem-kconfig-for-next:

$ git checkout a45c7df
$ echo CONFIG_MODULES=y >all.config
$ >test-orig; for i in `seq 1000`; do KCONFIG_ALLCONFIG=1 make
randconfig || break; grep -c '=m' .config >>test-orig; done
...
$ git checkout e43956e
$ >test-new; ...

$ awk '{ sum += $1; num++ } END { print sum / num}' test-orig
573.247
$ awk '{ sum += $1; num++ } END { print sum / num}' test-new
565.194

I am not a statistician, but this looks OK to me. For reference, the
figure was ~340 with the previous patch.

I pulled your changes to kbuild.git#kconfig.

Thanks,
Michal
