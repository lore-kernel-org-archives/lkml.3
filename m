Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJTMXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:23:34 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53805 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbaJTMXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:23:33 -0400
Message-ID: <1413807810.17703.6.camel@x41>
Subject: Re: [PATCH] Documentation: fix vdso_standalone_test_x86 on 32-bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Foley <pefoley2@pefoley.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org, jkosina@suse.cz,
        luto@amacapital.net, hpa@zytor.com, jwboyer@fedoraproject.org,
        linux-doc@vger.kernel.org
Date: Mon, 20 Oct 2014 14:23:30 +0200
In-Reply-To: <1412797764-11466-1-git-send-email-pefoley2@pefoley.com>
References: <1412797764-11466-1-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2014 12:23:30.0335 (UTC) FILETIME=[A866AAF0:01CFEC60]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Foley schreef op wo 08-10-2014 om 15:49 [-0400]:
> vdso_standalone_test_x86 needs -lgcc_s to build succesfully on 32bit.
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>
> ---
>  Documentation/vDSO/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
> index 2b99e57..5e5ad9f 100644
> --- a/Documentation/vDSO/Makefile
> +++ b/Documentation/vDSO/Makefile
> @@ -10,3 +10,6 @@ always := $(hostprogs-y)
>  HOSTCFLAGS := -I$(objtree)/usr/include -std=gnu99
>  HOSTCFLAGS_vdso_standalone_test_x86.o := -fno-asynchronous-unwind-tables -fno-stack-protector
>  HOSTLOADLIBES_vdso_standalone_test_x86 := -nostdlib
> +ifeq($(CONFIG_X86_32),y)
> +HOSTLOADLIBES_vdso_standalone_test_x86 += -lgcc_s
> +endif

Applying this patch on top of v3.18-rc1 to get it to build for 32 bit
x86 triggers this build error (when calling "make -s mrproper", which is
done early in the build of a Fedora kernel rpm):
    Documentation/vDSO/Makefile:13: *** missing separator.  Stop.
    make[1]: *** [Documentation/vDSO] Error 2
    make: *** [_clean_Documentation] Error 2

Using 
    ifeq ($(CONFIG_X86_32),y)

fixes that error. And with that space added this patch unbreaks the
build of v3.18-rc1 for 32 bit x86.

Thanks,


Paul Bolle

