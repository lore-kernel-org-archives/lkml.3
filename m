Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaA3Lnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 06:43:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55963 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaA3Lnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 06:43:52 -0500
Message-ID: <52EA3AE9.3030000@ti.com>
Date: Thu, 30 Jan 2014 17:13:37 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mohit Kumar <mohit.kumar@st.com>, <arnd@arndb.de>
CC: Pratyush Anand <pratyush.anand@st.com>, <spear-devel@list.st.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/8] phy: Initialize phy core with subsys_initcall
References: <cover.1391077731.git.mohit.kumar@st.com> <6f2dbd4fcb99a070c07b39545d98eca58101daa0.1391077731.git.mohit.kumar@st.com>
In-Reply-To: <6f2dbd4fcb99a070c07b39545d98eca58101daa0.1391077731.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 30 January 2014 04:18 PM, Mohit Kumar wrote:
> From: Pratyush Anand <pratyush.anand@st.com>
> 
> PCIe RC drivers are initialized with subsys_initcall. Few PCIe drivers
> like SPEAr13xx needs phy drivers to be initialized.

Instead change PCIe RC drivers to module init. Phy drivers should be loaded
very early otherwise. (Hint: drivers/Makefile).

Thanks
Kishon
> 
> Therefore initialize phy core driver with subsys_initcall to avoid
> calling of phy_get before phy_class is created.
> 
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit Kumar <mohit.kumar@st.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: spear-devel@list.st.com
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/phy/phy-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb..fa73101 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -685,7 +685,7 @@ static int __init phy_core_init(void)
>  
>  	return 0;
>  }
> -module_init(phy_core_init);
> +subsys_initcall(phy_core_init);
>  
>  static void __exit phy_core_exit(void)
>  {
> 

