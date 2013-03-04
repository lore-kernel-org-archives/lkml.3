Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab3CDUa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:30:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577Ab3CDUaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:30:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 05/32] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Mon, 4 Mar 2013 20:30:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <1360686546-24277-1-git-send-email-thomas.petazzoni@free-electrons.com> <201302122236.37491.arnd@arndb.de> <20130304172850.5e18fbfb@skate>
In-Reply-To: <20130304172850.5e18fbfb@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303042030.01817.arnd@arndb.de>
X-Provags-ID: V02:K0:HqviucrZdduFbgR6tZVVC0HyCbkoFoxyy2SE45n8fIm
 gOcJgIVnrPaZAPH0/F6um11WhY+0oHGrmzRwC97zNKXdJKaNfG
 ObayikwWU92MZGN5poVXDQNMWew2411EuV7b/84jq9d4fo2zqf
 FwGeg5GN5VG/H909twflJ6pQuVRmEdlLuldhB31xYUxeItclOv
 DpZNLE6OJZTPwjPx2IdIfd0XFXyO5T71Pnt1LWU+FBF2zQKCZq
 foxfv66RClfeBhK8UsPs/uYabLpul4zFlIK8Hh2nkZRy7y9fGn
 shyDIafJOfewjVvrLdYYZq7EUkOhIPscIfGo3u6iaUno+TNvZC
 ZxMqW3/Pg/wGrXrH/F+o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 March 2013, Thomas Petazzoni wrote:
> FWIW, a patch that is doing what I was initially proposing has been
> merged for 3.9, and it doesn't contain the
> IS_ENABLED(CONFIG_HAS_IOPORT) test you were proposing (and which I
> think was correct). See:
> 
> commit 9ed8a30f3471347c1b763bd062fa78ae80f18eae
> Author: Jingoo Han <jg1.han@samsung.com>
> Date:   Wed Feb 27 17:02:42 2013 -0800
> 

Sigh.

I'll take it as an additional incentive to finally clean up the logic behind
CONFIG_HAS_IOPORT by introducing a CONFIG_HAS_IOPORT_MAP symbol to replace it.

Thanks for the heads up.

	Arnd
