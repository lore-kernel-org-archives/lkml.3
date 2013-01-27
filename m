Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3A0Qly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 11:41:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32787 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab3A0Qlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 11:41:52 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1359304802-28240-3-git-send-email-emilgoode@gmail.com>
References: <1359304802-28240-1-git-send-email-emilgoode@gmail.com> <1359304802-28240-3-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/3] ALSA: intel8x0: Check return value before assigning
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 27 Jan 2013 08:40:36 -0800
To: Emil Goode <emilgoode@gmail.com>, mtosatti@redhat.com, gleb@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, avi@redhat.com, mst@redhat.com,
        perex@perex.cz, tiwai@suse.de, crimsun@ubuntu.com, wfp5p@virginia.edu,
        peter.senna@gmail.com
CC: x86@kernel.org, kvm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <868012ba-3527-4bcb-ba1b-f976024c221b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wtf?
 
This patch seems semibogus at best and the description is even more ridiculous...

Emil Goode <emilgoode@gmail.com> wrote:

>The first patch in this series changes the return type of function
>kvm_para_available to bool. In the function snd_intel8x0_inside_vm
>we now need to check it's return value before assigning a value to
>the result variable.
>
>Signed-off-by: Emil Goode <emilgoode@gmail.com>
>---
> sound/pci/intel8x0.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
>index 3b9be75..fa9337e 100644
>--- a/sound/pci/intel8x0.c
>+++ b/sound/pci/intel8x0.c
>@@ -2982,7 +2982,7 @@ static int snd_intel8x0_inside_vm(struct pci_dev
>*pci)
> 	}
> 
> 	/* detect KVM and Parallels virtual environments */
>-	result = kvm_para_available();
>+	result = kvm_para_available() ? 1 : 0;
> #ifdef X86_FEATURE_HYPERVISOR
> 	result = result || boot_cpu_has(X86_FEATURE_HYPERVISOR);
> #endif

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
