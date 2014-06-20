Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaFTOoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:44:34 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58837 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaFTOoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:44:30 -0400
MIME-Version: 1.0
In-Reply-To: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
References: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Fri, 20 Jun 2014 16:44:05 +0200
Message-ID: <CAMxnaaUThGenvkYkcx062tjwYgBnBDsXNsUzeFtrUa7AV8Pk-A@mail.gmail.com>
Subject: Re: [PATCH 1/3] thunderbolt: add PCI dependency
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the series.

Patch 2 is equivalent to patches 1 and 2 from Sachin Kamat's series.

@Greg: This series together with Sachin's patches should fix all build
errors. I'll send patches for the remaining warnings later.

Andreas

On Fri, Jun 20, 2014 at 3:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The thunderbolt drivers cannot be built if CONFIG_PCI is disabled,
> better add an explicit Kconfig dependency.
> The "default no" line is redundant and can be removed at the same
> time.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/thunderbolt/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
> index 3a25529..5aab79b 100644
> --- a/drivers/thunderbolt/Kconfig
> +++ b/drivers/thunderbolt/Kconfig
> @@ -1,6 +1,6 @@
>  menuconfig THUNDERBOLT
>         tristate "Thunderbolt support for Apple devices"
> -       default no
> +       depends on PCI
>         help
>           Cactus Ridge Thunderbolt Controller driver
>           This driver is required if you want to hotplug Thunderbolt devices on
> --
> 1.8.3.2
>
