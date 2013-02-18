Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3BRWg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:36:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3BRWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:36:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dongjin Kim <tobetter@gmail.com>
Subject: Re: [PATCH v3] mmc: dw_mmc: Add MSHC compatible for Exynos4412
Date: Mon, 18 Feb 2013 22:36:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, Chris Ball <cjb@laptop.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
In-Reply-To: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302182236.43877.arnd@arndb.de>
X-Provags-ID: V02:K0:T+YOMatPhcng8X1AhAYriqFcflxgKtZtbje1OZ/1pen
 r8Gv9N37sJ2rlkCZ/GJuXmjsAEp9pFyLKR6RYQJ5RrK5AlAOhU
 r22kLdoiMaY0VyUvuWnzz+RFI+RdGPahjj7yxWii9BIsHgptHV
 e5fOYuwCiAgS8SoRdsP+ppPu8eFrvwbIXbErKpwsOEcv/Swy/e
 4fAnHqbWDIR0LOrqZsRA97fadDAmvtED51+HV4hqmC3ffrp70Y
 dLKNoWhStV6Lsn/U0Ol2cwsE7p9b6s6bd4lhHQaTi7qtedx+Oe
 pdBMzcCoGab8Dz2QvIfaKp7Hzu94BRZczzftpVx6C2QueIeoA6
 niwjvd310oRcNzrqMM1U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013, Dongjin Kim wrote:
> 
> This patch adds the compatible string for MSHC controller of Exynos4412, and
> share the controller specific properties with Exynos5250 since they have same
> features. Its driver data name is changed to exynos_drv_data instead SoC
> specific name.
> 
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>

If they are completely compatibly, you can just list
"samsung,exynos4412-dw-mshc" in the compatible property of the
exynos5250 device tree, along with the other ones like:

	compatible = "samsung,exynos5250-dw-mshc", "samsung,exynos4412-dw-mshc", "snps,dw-mshc";

then you don't need to change the driver at all.

	Arnd
