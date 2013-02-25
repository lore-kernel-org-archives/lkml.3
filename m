Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab3BYOdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:33:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab3BYOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:33:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 24/35] mfd: ab8500: Remove unnecessary 'struct device' declaration
Date: Mon, 25 Feb 2013 14:33:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org> <1360933026-30325-25-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1360933026-30325-25-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302251433.36121.arnd@arndb.de>
X-Provags-ID: V02:K0:Mgq8LiMlIaEoC4DAJcnjzf08P/Do3xN0O/spAYNWz07
 jdLHV5OOWosiWUA4sZQJFUiFjJrPcqofiPANQKoVg4sT5lJHJV
 q8KsVrmPC/SA/LBUztIXFZjHOPRVXguBAzMWdtSFwBsmU7qU/u
 ZcZUeSICKbmv2u5jxQ181/g91DwbvgCnkScEYPbE4mOzjgiq1+
 X43KdiFfePdf+NOQhbQkddu/MK7fLHytspPFIKxvvmzyfAGyvk
 RK9Q2xAg6roP8h6TDaFhkPrhFSv7/RnLUpjIFv3PQBdoiqchPp
 sQ0utXmLTrXQMQpUpXMKpZIoCYxhpI+9rxqO8cTwFsMovU10C4
 fmGL0d+hjUmN2efIJdIc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2013, Lee Jones wrote:
> A recent patch saw the device.h include being removed from some other
> include files and replaced with a 'struct device' declaration instead.
> However, neither the include nor the declaration is actually required.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/abx500.h |    2 --
>  1 file changed, 2 deletions(-)

In my copy of the file, we the declaration


int ab8500_bm_of_probe(struct device *dev,
                       struct device_node *np,
                       struct abx500_bm_data *bm);



and others that use 'struct device'. C99 requires that a struct is declared
in advance  before you use it in a function declaration.

	Arnd
