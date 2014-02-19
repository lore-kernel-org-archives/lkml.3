Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaBSDsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:48:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50162 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaBSDsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:48:50 -0500
Message-ID: <5304297B.8050201@zytor.com>
Date: Tue, 18 Feb 2014 19:48:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Konstantin Ozerkov <kozerkov@parallels.com>,
        "Denis V. Lunev" <den@openvz.org>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: snd_intel8x0_inside_vm()
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just stumbled upon the function snd_intel8x0_inside_vm(), and quite
frankly the code seems bizarre:

        /* detect KVM and Parallels virtual environments */
        result = kvm_para_available();
#ifdef X86_FEATURE_HYPERVISOR
        result = result || boot_cpu_has(X86_FEATURE_HYPERVISOR);
#endif
        if (!result)
                goto fini;

Why don't we simply rely on the PCI SSIDs?

	-hpa
